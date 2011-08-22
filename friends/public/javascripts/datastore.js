(function() {
  var data, query;
  $.ajaxSetup({
    cache: false,
    dataType: "json"
  });
  App.reopen({
    store: SC.Store.create().from('App.DataSource'),
    datastoreCreateFriend: function(dataHash) {
      var friend;
      friend = Friends.store.createRecord(App.Friend, dataHash);
      friend.save();
      return friend;
    },
    datastoreUpdateFriends: function() {
      var changes, store;
      store = App.store;
      changes = store.get('changelog');
      changes.forEach((function() {
        var id, rec;
        id = store.idFor(storeKey);
        rec = store.find(App.Friend, id);
        return rec.save();
      }), this);
      return YES;
    }
  });
  App.friendsController.reopen({
    saveAllFriends: function() {
      return App.datastoreUpdateFriends();
    }
  });
  App.DataSource = SC.DataSource.extend({
    fetch: function(store, query) {
      var jqxhr, recordType;
      recordType = query.get('recordType');
      jqxhr = $.ajax({
        url: '/friends'
      }).done(function(dataHashes) {
        var ids;
        ids = dataHashes.map((function(dataHash) {
          var id;
          id = dataHash.id;
          delete dataHash.id;
          return id;
        }), this);
        store.loadRecords(recordType, dataHashes, ids);
        return store.dataSourceDidFetchQuery(query);
      });
      return YES;
    }
  });
  App.Friend = SC.Record.extend({
    name: SC.Record.attr(String),
    category: SC.Record.attr(String),
    createdAt: SC.Record.attr(SC.DateTime, {
      key: 'created_at'
    }),
    updatedAt: SC.Record.attr(SC.DateTime, {
      key: 'updated_at'
    }),
    save: function() {
      var K, id, jqxhr, recordType, status, store, storeKey;
      K = SC.Record;
      recordType = this;
      store = this.get('store');
      storeKey = this.get('storeKey');
      status = store.readStatus(storeKey);
      if (status === K.READY_NEW) {
        jqxhr = $.ajax({
          type: 'POST',
          url: '/friends',
          data: {
            'friend': store.readDataHash(storeKey)
          }
        }).done(function(dataHash) {
          var newId;
          newId = dataHash.id;
          delete dataHash.id;
          store.writeStatus(storeKey, K.READY_CLEAN);
          SC.Store.replaceIdFor(storeKey, newId);
          return store.pushRetrieve(recordType, newId, dataHash, storeKey);
        });
        return YES;
      } else if (status === K.READY_DIRTY) {
        id = this.get('id');
        return jqxhr = $.ajax({
          type: 'PUT',
          url: "/friends/" + id,
          data: {
            'friend': store.readDataHash(storeKey)
          }
        }).done(function(dataHash) {
          delete dataHash.id;
          store.writeStatus(storeKey, K.READY_CLEAN);
          return store.pushRetrieve(recordType, id, dataHash, storeKey);
        });
      } else {
        return NO;
      }
    },
    "delete": function() {
      var id, jqxhr, rec;
      rec = this;
      id = this.get('id');
      jqxhr = $.ajax({
        type: 'DELETE',
        url: '/friends/#{id}'
      }).done(function() {
        return rec.destroy();
      });
      return YES;
    }
  });
  query = SC.Query.local(App.Friend);
  data = App.store.find(query);
}).call(this);
