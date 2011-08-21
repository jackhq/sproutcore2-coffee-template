(function() {
  window.awesome = SC.Object.extend({
    first: 'Tom',
    last: 'Wilson',
    full_name: (function() {
      return "" + (this.get('first')) + " " + (this.get('last'));
    }).property('first', 'last')
  });
}).call(this);
