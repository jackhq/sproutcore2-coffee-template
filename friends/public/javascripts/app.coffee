# # Friends
# Friends is an example sproutcore 2.0
# Application that connects to a remote
# datastore, also binds to several
# filtered locations

# Application Create
Friends = SC.Application.create()

# # Models

# ## Category
# A SproutCore Category Model
# Reflects the label and value of the
# Select drop down as well as 
# maps a friends array to a 
# given category
Friends.Category = SC.Object.extend
  label: null
  value: null
  friends: null

# ## Friend
# A SproutCore Friend Model
# Reflects the name and category
# Stored on the friend data store
# It also contains a hide attribute
# to drive view logic
Friends.Friend = SC.Object.extend
  id: null
  name: null
  category: null
  hide: false

# # Controllers
#
# ## categoriesController
#
# In this controller we want to capture
# the array change and build a list of
# friends for each category.
Friends.categoriesController = SC.ArrayProxy.create
  content: []
  arrayDidChange: (item, idx, removedCnt, addedCnt) ->
    @_super(item, idx, removedCnt, addedCnt)
    if item? and item.length > 0 and item[idx].friends is null
      item[idx].friends = Friends.friendsController.filterProperty('category', 'best') if item[idx].name is 'best'
      item[idx].friends = Friends.friendsController.filterProperty('category', 'coworker') if item[idx].name is 'coworker'
      item[idx].friends = Friends.friendsController.filterProperty('category', 'basic')  if item[idx].name is 'basic'

# ## friendsController
#
# In this controller we want to create
# separate buckets for each category of friend
# We also are creating a binding holder for
# new Friend form. (name, cat)
#
# Lastly, we are creating a hide attribute
# to drive the visibility of the save all
# button.
Friends.friendsController = SC.ArrayProxy.create
  content: []
  best: []
  coworkers: []
  basic: []

  name: null
  cat: 'basic'
  hide: true

  # Place new Friends in sub buckets
  arrayDidChange: (item, idx, removedCnt, addedCnt) ->
    @_super(item, idx, removedCnt, addedCnt)
    @set 'best', @filterProperty('category', 'best')
    @set 'coworkers', @filterProperty('category', 'coworker')
    @set 'basic', @filterProperty('category', 'basic')

  # Create a new friend! from Form
  createFriend: ->
    @pushObject(Friends.Friend.create
      name: @get 'name'
      category: @get 'cat'
    )
    
    # Reset New Form
    @set 'name',''
    @set 'cat','basic'
    
    # Show Save All Button
    @set 'hide', false
    
  # Save all new Friends to server
  saveAll: ->
    # add new ones
    for friend in @filterProperty('id', null)
      data = { friend: {name: friend.name, category: friend.category}}
      console.log data
      $.post('/friends', data)
    @set 'hide', true

# Set Global Scope to App
window.Friends = Friends

# Load Friends from Server
$.getJSON('/friends').done (data) ->
  for friend in data
    Friends.friendsController.pushObject Friends.Friend.create #(friend)
      id: friend.id
      name: friend.name
      category: friend.category
      
# Load Categories from Server
$.getJSON('/categories').done (data) ->
  for category in data
    Friends.categoriesController.pushObject Friends.Category.create
      label: category.name
      value: category.name

