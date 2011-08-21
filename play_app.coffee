Play = SC.Application.create()

Play.Friend = SC.Object.extend
  name: null
  category: null
  hide: false
  early_morning: false
  morning: false
  noon: false


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

#Play.friendsController.set('content', store)

