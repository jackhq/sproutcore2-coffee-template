Friends = SC.Application.create()

Friends.Category = SC.Object.extend
  label: null
  value: null
  friends: null

Friends.Friend = SC.Object.extend
  id: null
  name: null
  category: null
  hide: false

Friends.categoriesController = SC.ArrayProxy.create
  content: []
  arrayDidChange: (item, idx, removedCnt, addedCnt) ->
    @_super(item, idx, removedCnt, addedCnt)
    if item? and item.length > 0 and item[idx].friends is null
      item[idx].friends = Friends.friendsController.filterProperty('category', 'best') if item[idx].name is 'best'
      item[idx].friends = Friends.friendsController.filterProperty('category', 'coworker') if item[idx].name is 'coworker'
      item[idx].friends = Friends.friendsController.filterProperty('category', 'basic')  if item[idx].name is 'basic'

Friends.friendsController = SC.ArrayProxy.create
  content: []
  best: []
  coworkers: []
  basic: []
  
  name: null
  cat: 'basic'
  hide: true
  
  arrayDidChange: (item, idx, removedCnt, addedCnt) ->
    @_super(item, idx, removedCnt, addedCnt)
    @set 'best', @filterProperty('category', 'best')
    @set 'coworkers', @filterProperty('category', 'coworker')
    @set 'basic', @filterProperty('category', 'basic')

  createFriend: ->
    @pushObject(Friends.Friend.create
      name: @get 'name'
      category: @get 'cat'
    )
    @set 'name',''
    @set 'cat','basic'
    @set 'hide', false
    
  saveAll: ->
    # add new ones
    for friend in @filterProperty('id', null)
      data = { friend: {name: friend.name, category: friend.category}}
      console.log data
      $.post('/friends', data)
    @set 'hide', true

window.Friends = Friends

# Load Data
$.getJSON('/friends').done (data) ->
  for friend in data
    Friends.friendsController.pushObject Friends.Friend.create #(friend)
      id: friend.id
      name: friend.name
      category: friend.category
      
# Load Categories
$.getJSON('/categories').done (data) ->
  for category in data
    Friends.categoriesController.pushObject Friends.Category.create
      label: category.name
      value: category.name

#cats = ['basic','coworker','best']
#Friends.categoriesController.pushObject(Friends.Category.create(label: cat, value: cat)) for cat in cats

