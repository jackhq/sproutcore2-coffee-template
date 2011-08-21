(function() {
  var resident, residents, residentsData, unit, units, unitsData;
  unitsData = [
    {
      name: 'Unit A',
      wings: ['Wing 1', 'Wing 2']
    }, {
      name: 'Unit B',
      wings: ['Wing 3', 'Wing 4']
    }, {
      name: 'Unit C',
      wings: ['Wing 5', 'Wing 6']
    }
  ];
  residentsData = [
    {
      id: '1',
      dob: '09/13/1975',
      gender: 'Male',
      full_name: 'P. Barrett Little',
      unit: 'Unit A',
      wing: 'Wing 1',
      room: '1',
      bed: '1'
    }, {
      id: '2',
      dob: '09/03/1987',
      gender: 'M',
      full_name: 'Robert Walton Pearce',
      unit: 'Unit B',
      wing: 'Wing 3',
      room: '1',
      bed: '1'
    }, {
      id: '3',
      dob: '04/02/1984',
      gender: 'M',
      full_name: 'Keith Thornton',
      unit: 'Unit C',
      wing: 'Wing 5',
      room: '1',
      bed: '1'
    }, {
      id: '4',
      dob: '09/03/1977',
      gender: 'M',
      full_name: 'Wanda Smith',
      unit: 'Unit C',
      wing: 'Wing 4',
      room: '1',
      bed: '1'
    }
  ];
  window.Residents = SC.Application.create();
  Residents.Resident = SC.Object.extend({
    id: null,
    dob: null,
    gender: null,
    full_name: null,
    unit: null,
    wing: null,
    room: null,
    bed: null
  });
  Residents.Unit = SC.Object.extend({
    wings: [],
    unit_name: null
  });
  Residents.residentsController = SC.ArrayProxy.create({
    content: [],
    createResident: function(resident) {
      return this.pushObject(Residents.Resident.create({
        id: resident.id,
        dob: resident.dob,
        gender: resident.gender,
        full_name: resident.full_name,
        unit: resident.unit,
        wing: resident.wing,
        room: resident.room,
        bed: resident.bed
      }));
    }
  });
  Residents.unitsController = SC.ArrayProxy.create({
    content: [],
    arrayDidChange: function(addedObjects, removedObjects, changeIndex, addedCount) {
      var unit, _i, _len, _results;
      this._super(addedObjects, removedObjects, changeIndex, addedCount);
      if ((addedObjects != null) && addedObjects.length > 0) {
        _results = [];
        for (_i = 0, _len = unitsData.length; _i < _len; _i++) {
          unit = unitsData[_i];
          _results.push(addedObjects[removedObjects].unit_name === unit.name ? addedObjects[removedObjects].residents = Residents.residentsController.filterProperty('unit', unit.name) : void 0);
        }
        return _results;
      }
    },
    createUnit: function(unit) {
      return this.pushObject(Residents.Unit.create({
        unit_name: unit.name,
        wings: unit.wings
      }));
    }
  });
  Residents.unitsView = SC.CollectionView.extend({
    contentBinding: 'Residents.unitsController',
    tagName: 'ul'
  });
  Residents.residentsView = SC.CollectionView.extend({
    contentBinding: 'Residents.residentsController',
    tagName: 'ul'
  });
  residents = (function() {
    var _i, _len, _results;
    _results = [];
    for (_i = 0, _len = residentsData.length; _i < _len; _i++) {
      resident = residentsData[_i];
      _results.push(Residents.residentsController.createResident(resident));
    }
    return _results;
  })();
  units = (function() {
    var _i, _len, _results;
    _results = [];
    for (_i = 0, _len = unitsData.length; _i < _len; _i++) {
      unit = unitsData[_i];
      _results.push(Residents.unitsController.createUnit(unit));
    }
    return _results;
  })();
}).call(this);
