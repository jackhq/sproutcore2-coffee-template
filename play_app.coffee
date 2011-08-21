cats = ['best','coworker','basic']

Play = SC.Application.create()

Play.Category = SC.Object.extend
  name: null
  friends: null

Play.Friend = SC.Object.extend
  name: null
  category: null
  hide: false
  early_morning: false
  morning: false
  noon: false

Play.categoriesController = SC.ArrayProxy.create
  content: []
  arrayDidChange: (item, idx, removedCnt, addedCnt) ->
    @_super(item, idx, removedCnt, addedCnt)
    console.log item
    console.log idx
    if item? and item.length > 0 and item[idx].friends is null
      item[idx].friends = Play.friendsController.filterProperty('category', 'best') if item[idx].name is 'best'
      item[idx].friends = Play.friendsController.filterProperty('category', 'coworker') if item[idx].name is 'coworker'
      item[idx].friends = Play.friendsController.filterProperty('category', 'basic')  if item[idx].name is 'basic'
      console.log 'Added Friends...'

Play.friendsController = SC.ArrayProxy.create
  content: []
  best: []
  coworkers: []
  basic: []
  arrayDidChange: (item, idx, removedCnt, addedCnt) ->
    @_super(item, idx, removedCnt, addedCnt)
    @set 'best', @filterProperty('category', 'best')
    @set 'coworkers', @filterProperty('category', 'coworker')
    @set 'basic', @filterProperty('category', 'basic')
  createFriend: ->
    @pushObject(Play.Friend.create())


window.Play = Play

#store = []
# Create Friends
Play.friendsController.pushObject(Play.Friend.create(name: friend.name, category: friend.category)) for friend in [
  { name: 'Tom', category: 'best' }
  { name: 'Dick', category: 'best' }
  { name: 'Harry', category: 'best' }
  { name: 'Jim', category: 'basic' }
  { name: 'Mary', category: 'basic' }
  { name: 'Sue', category: 'coworker' }

]

Play.categoriesController.pushObject(Play.Category.create(name: cat)) for cat in cats

#Play.friendsController.set('content', store)

