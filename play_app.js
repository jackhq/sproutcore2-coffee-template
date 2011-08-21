(function() {
  var Play, friend, _i, _len, _ref;
  Play = SC.Application.create();
  Play.Friend = SC.Object.extend({
    name: null,
    category: null,
    hide: false
  });
  Play.friendsController = SC.ArrayProxy.create({
    content: [],
    best: [],
    coworkers: [],
    basic: []
  });
  window.Play = Play;
  _ref = [
    {
      name: 'Tom',
      category: 'best'
    }, {
      name: 'Dick',
      category: 'coworker'
    }, {
      name: 'Harry',
      category: 'basic'
    }
  ];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    friend = _ref[_i];
    Play.friendsController.pushObject(Play.Friend.create({
      name: friend.name,
      category: friend.category
    }));
  }
  Play.friendsController.set('best', Play.friendsController.filterProperty('category', 'best'));
  Play.friendsController.set('coworkers', Play.friendsController.filterProperty('category', 'coworker'));
  Play.friendsController.set('basic', Play.friendsController.filterProperty('category', 'basic'));
}).call(this);
