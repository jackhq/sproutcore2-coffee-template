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

window.Play = Play


# Create Friends
Play.friendsController.pushObject(Play.Friend.create(name: friend.name, category: friend.category)) for friend in [
  { name: 'Tom', category: 'best' }
  { name: 'Dick', category: 'coworker' }
  { name: 'Harry', category: 'basic' }
]

# Load Friends
Play.friendsController.set('best', Play.friendsController.filterProperty('category', 'best'))
Play.friendsController.set('coworkers', Play.friendsController.filterProperty('category', 'coworker'))
Play.friendsController.set('basic', Play.friendsController.filterProperty('category', 'basic'))
