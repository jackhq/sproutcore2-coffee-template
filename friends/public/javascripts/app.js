(function() {
  var Friends;
  Friends = SC.Application.create();
  Friends.Category = SC.Object.extend({
    label: null,
    value: null,
    friends: null
  });
  Friends.Friend = SC.Object.extend({
    id: null,
    name: null,
    category: null,
    hide: false
  });
  Friends.categoriesController = SC.ArrayProxy.create({
    content: [],
    arrayDidChange: function(item, idx, removedCnt, addedCnt) {
      this._super(item, idx, removedCnt, addedCnt);
      if ((item != null) && item.length > 0 && item[idx].friends === null) {
        if (item[idx].name === 'best') {
          item[idx].friends = Friends.friendsController.filterProperty('category', 'best');
        }
        if (item[idx].name === 'coworker') {
          item[idx].friends = Friends.friendsController.filterProperty('category', 'coworker');
        }
        if (item[idx].name === 'basic') {
          return item[idx].friends = Friends.friendsController.filterProperty('category', 'basic');
        }
      }
    }
  });
  Friends.friendsController = SC.ArrayProxy.create({
    content: [],
    best: [],
    coworkers: [],
    basic: [],
    name: null,
    cat: 'basic',
    hide: true,
    arrayDidChange: function(item, idx, removedCnt, addedCnt) {
      this._super(item, idx, removedCnt, addedCnt);
      this.set('best', this.filterProperty('category', 'best'));
      this.set('coworkers', this.filterProperty('category', 'coworker'));
      return this.set('basic', this.filterProperty('category', 'basic'));
    },
    createFriend: function() {
      this.pushObject(Friends.Friend.create({
        name: this.get('name'),
        category: this.get('cat')
      }));
      this.set('name', '');
      this.set('cat', 'basic');
      return this.set('hide', false);
    },
    saveAll: function() {
      var data, friend, _i, _len, _ref;
      _ref = this.filterProperty('id', null);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        friend = _ref[_i];
        data = {
          friend: {
            name: friend.name,
            category: friend.category
          }
        };
        console.log(data);
        $.post('/friends', data);
      }
      return this.set('hide', true);
    }
  });
  window.Friends = Friends;
  $.getJSON('/friends').done(function(data) {
    var friend, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = data.length; _i < _len; _i++) {
      friend = data[_i];
      _results.push(Friends.friendsController.pushObject(Friends.Friend.create({
        id: friend.id,
        name: friend.name,
        category: friend.category
      })));
    }
    return _results;
  });
  $.getJSON('/categories').done(function(data) {
    var category, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = data.length; _i < _len; _i++) {
      category = data[_i];
      _results.push(Friends.categoriesController.pushObject(Friends.Category.create({
        label: category.name,
        value: category.name
      })));
    }
    return _results;
  });
}).call(this);
