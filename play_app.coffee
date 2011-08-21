Play = SC.Application.create()

Play.Friend = SC.Object.extend
  name: null
  category: null
  hide: false

Play.friendsController = SC.ArrayProxy.create
  content: []
  best: []
  coworkers: []
  basic: []
  arrayDidChange: (item, idx, removedCnt, addedCnt) ->
    console.log 'changed...'
    @_super(item, idx, removedCnt, addedCnt)
    @set 'best', @filterProperty('category', 'best')
    @set 'coworkers', @filterProperty('category', 'coworker')
    @set 'basic', @filterProperty('category', 'basic')



store = []
# Create Friends
store.push(Play.Friend.create(name: friend.name, category: friend.category)) for friend in [
  { name: 'Tom', category: 'best' }
  { name: 'Dick', category: 'coworker' }
  { name: 'Harry', category: 'basic' }
]

Play.friendsController.set('content', store)

# Play.friendsController.set('best', Play.friendsController.filterProperty('category', 'best'))
# Play.friendsController.set('coworkers', Play.friendsController.filterProperty('category', 'coworker'))
# Play.friendsController.set('basic', Play.friendsController.filterProperty('category', 'basic'))


window.Play = Play
