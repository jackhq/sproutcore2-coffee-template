(function() {
  var Play, friend, store, _i, _len, _ref;
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
    arrayDidChange: function(item, idx, removedCnt, addedCnt) {
      console.log('changed...');
      this._super(item, idx, removedCnt, addedCnt);
      this.set('best', this.filterProperty('category', 'best'));
      this.set('coworkers', this.filterProperty('category', 'coworker'));
      return this.set('basic', this.filterProperty('category', 'basic'));
    }
  });
  store = [];
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
    store.push(Play.Friend.create({
      name: friend.name,
      category: friend.category
    }));
  }
  Play.friendsController.set('content', store);
  window.Play = Play;
}).call(this);
