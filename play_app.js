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
    basic: [],
    arrayDidChange: function() {
      this.set('best', this.filterProperty('category', 'best'));
      this.set('coworkers', this.filterProperty('category', 'coworker'));
      return this.set('basic', this.filterProperty('category', 'basic'));
    }
  });
  window.Play = Play;
  _ref = [
    {
      name: 'Tom',
      category: 'best'
    }, {
      name: 'Dick',
      category: 'best'
    }, {
      name: 'Harry',
      category: 'best'
    }, {
      name: 'Jim',
      category: 'basic'
    }, {
      name: 'Mary',
      category: 'basic'
    }, {
      name: 'Sue',
      category: 'coworker'
    }
  ];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    friend = _ref[_i];
    Play.friendsController.pushObject(Play.Friend.create({
      name: friend.name,
      category: friend.category
    }));
  }
  Play.FooView = SC.CollectionView.extend({
    contentBinding: SC.Binding.from('Play.friendsController'),
    tagName: 'ul'
  });
}).call(this);
