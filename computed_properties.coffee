window.awesome = SC.Object.extend
  first: 'Tom'
  last: 'Wilson'
  full_name: ( -> "#{@get('first')} #{@get('last')}" ).property('first','last')
