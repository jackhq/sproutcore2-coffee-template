(function() {
  var Play, cat, cats, friend, _i, _j, _len, _len2, _ref;
  cats = ['best', 'coworker', 'basic'];
  Play = SC.Application.create();
  Play.Category = SC.Object.extend({
    name: null,
    friends: null
  });
  Play.Friend = SC.Object.extend({
    name: null,
    category: null,
    hide: false,
    early_morning: false,
    morning: false,
    noon: false
  });
  Play.categoriesController = SC.ArrayProxy.create({
    content: [],
    arrayDidChange: function(item, idx, removedCnt, addedCnt) {
      this._super(item, idx, removedCnt, addedCnt);
      if ((item != null) && item.length > 0 && item[idx].friends === null) {
        if (item[idx].name === 'best') {
          item[idx].friends = Play.friendsController.filterProperty('category', 'best');
        }
        if (item[idx].name === 'coworker') {
          item[idx].friends = Play.friendsController.filterProperty('category', 'coworker');
        }
        if (item[idx].name === 'basic') {
          return item[idx].friends = Play.friendsController.filterProperty('category', 'basic');
        }
      }
    }
  });
  Play.friendsController = SC.ArrayProxy.create({
    content: [],
    best: [],
    coworkers: [],
    basic: [],
    name: null,
    cat: null,
    arrayDidChange: function(item, idx, removedCnt, addedCnt) {
      this._super(item, idx, removedCnt, addedCnt);
      this.set('best', this.filterProperty('category', 'best'));
      this.set('coworkers', this.filterProperty('category', 'coworker'));
      return this.set('basic', this.filterProperty('category', 'basic'));
    },
    createFriend: function() {
      this.pushObject(Play.Friend.create({
        name: this.get('name'),
        category: this.get('cat')
      }));
      this.set('name', '');
      return this.set('cat', '');
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
  for (_j = 0, _len2 = cats.length; _j < _len2; _j++) {
    cat = cats[_j];
    Play.categoriesController.pushObject(Play.Category.create({
      name: cat
    }));
  }
}).call(this);
