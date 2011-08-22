(function() {
  var resident, residents, residentsData, unit, units, unitsData, wing, wings;
  unitsData = [
    {
      name: 'Unit A',
      wings: [
        {
          name: 'Wing 1'
        }, {
          name: 'Wing 2'
        }
      ]
    }, {
      name: 'Unit B',
      wings: [
        {
          name: 'Wing 3'
        }, {
          name: 'Wing 4'
        }
      ]
    }, {
      name: 'Unit C',
      wings: [
        {
          name: 'Wing 5'
        }, {
          name: 'Wing 6'
        }
      ]
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
    unit_wings: [],
    unit_name: null,
    isSelected: true
  });
  Residents.Wing = SC.Object.extend({
    wing_residents: [],
    name: null,
    isSelected: true
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
    createUnit: function(unit) {
      return this.pushObject(Residents.Unit.create({
        unit_name: unit.name,
        unit_wings: unit.wings
      }));
    }
  });
  Residents.wingsController = SC.ArrayProxy.create({
    content: [],
    createWing: function(wing) {
      return this.pushObject(Residents.Wing.create({
        name: wing.name,
        wing_residents: wing.residents
      }));
    }
  });
  Residents.ResidentsView = SC.CollectionView.extend({
    contentBinding: 'Residents.unitsController',
    tagName: 'ul'
  });
  Residents.UnitFilterView = SC.CollectionView.extend({
    contentBinding: 'Residents.unitsController',
    tagName: 'ul'
  });
  Residents.UnitFilterItemView = SC.Checkbox.extend({
    contentBinding: 'Residents.unitsController',
    valueBinding: "parentView.content.isSelected"
  });
  Residents.WingFilterView = SC.CollectionView.extend({
    contentBinding: "parentView.content.unit_wings",
    tagName: 'ul'
  });
  Residents.WingFilterItemView = SC.Checkbox.extend({
    contentBinding: 'Residents.wingsController',
    valueBinding: "parentView.content.isSelected"
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
      wings = (function() {
        var _j, _len2, _ref, _results2;
        _ref = unit.wings;
        _results2 = [];
        for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
          wing = _ref[_j];
          wing.wing_residents = [];
          wing.isSelected = true;
          residents = Residents.residentsController.filterProperty('wing', wing.name);
          _results2.push((function() {
            var _k, _len3, _results3;
            _results3 = [];
            for (_k = 0, _len3 = residents.length; _k < _len3; _k++) {
              resident = residents[_k];
              wing.wing_residents.push(resident);
              _results3.push(Residents.wingsController.createWing(wing));
            }
            return _results3;
          })());
        }
        return _results2;
      })();
      _results.push(Residents.unitsController.createUnit(unit));
    }
    return _results;
  })();
}).call(this);
