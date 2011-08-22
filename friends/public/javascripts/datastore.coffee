$.ajaxSetup 
  cache: false
  dataType: "json"
  
App.reopen
  store: SC.Store.create().from('App.DataSource')
  datastoreCreateFriend: (dataHash) ->
    friend = Friends.store.createRecord App.Friend, dataHash
    friend.save()
    friend
  datastoreUpdateFriends: ->
    store = App.store
    changes = store.get 'changelog'
    # could be a problem
    changes.forEach ( ->
      id = store.idFor storeKey
      rec = store.find App.Friend, id
      rec.save()
      ), this
    YES

App.friendsController.reopen
  saveAllFriends: ->
    App.datastoreUpdateFriends()

App.DataSource = SC.DataSource.extend
  fetch: (store, query) ->
    recordType = query.get 'recordType'
    jqxhr = $.ajax(url: '/friends')
      .done (dataHashes) ->
        ids = dataHashes.map ( (dataHash) ->
          id = dataHash.id
          delete dataHash.id
          id), this
        store.loadRecords(recordType, dataHashes, ids)
        store.dataSourceDidFetchQuery(query)
    YES

App.Friend = SC.Record.extend
  name: SC.Record.attr(String)
  category: SC.Record.attr(String)
  createdAt: SC.Record.attr(SC.DateTime, { key: 'created_at' })
  updatedAt: SC.Record.attr(SC.DateTime, { key: 'updated_at' })
   
  save: ->
    K = SC.Record
    recordType = this
    store = @get 'store'
    storeKey = @get 'storeKey'
    status = store.readStatus storeKey
     
    if status == K.READY_NEW
      jqxhr = $.ajax(type: 'POST', url: '/friends', data: { 'friend': store.readDataHash(storeKey)})
        .done (dataHash) ->
          newId = dataHash.id
          delete dataHash.id

          store.writeStatus storeKey, K.READY_CLEAN
          SC.Store.replaceIdFor storeKey, newId
          store.pushRetrieve recordType, newId, dataHash, storeKey
      YES
    else if status == K.READY_DIRTY
      id = @get 'id'
      jqxhr = $.ajax(type: 'PUT', url: "/friends/#{id}", data: { 'friend': store.readDataHash(storeKey)})
        .done (dataHash) ->
          delete dataHash.id
          store.writeStatus storeKey, K.READY_CLEAN
          store.pushRetrieve recordType, id, dataHash, storeKey
    else
      NO
  delete: ->
    rec = this
    id = @get 'id'
    jqxhr = $.ajax(type: 'DELETE', url: '/friends/#{id}')
      .done ->
        rec.destroy()
    YES

query = SC.Query.local App.Friend
data = App.store.find query

# observer = ->
#   if data.get('status') == SC.Record.READY_CLEAN
#     data.removeObserver('status', this, observer)
#     App.friendsController.set('content', [data])
#     
# data.addObserver 'status', this, observer
