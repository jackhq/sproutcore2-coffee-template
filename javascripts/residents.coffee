#############
# Mock Data #
#############

unitsData = [
  {
    name: 'Unit A',
    wings: [{name: 'Wing 1'}, {name: 'Wing 2'}]
  },
  {
    name: 'Unit B',
    wings: [{name: 'Wing 3'}, {name: 'Wing 4'}]
  },
  {
    name: 'Unit C',
    wings: [{name: 'Wing 5'}, {name: 'Wing 6'}]
  }
]

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
  },
  {
    id: '2',
    dob: '09/03/1987',
    gender: 'M',
    full_name: 'Robert Walton Pearce',
    unit: 'Unit B',
    wing: 'Wing 3',
    room: '1',
    bed: '1'
  },
  {
    id: '3',
    dob: '04/02/1984',
    gender: 'M',
    full_name: 'Keith Thornton',
    unit: 'Unit C',
    wing: 'Wing 5',
    room: '1',
    bed: '1'
  },
  {
    id: '4',
    dob: '09/03/1977',
    gender: 'M',
    full_name: 'Wanda Smith',
    unit: 'Unit C',
    wing: 'Wing 4',
    room: '1',
    bed: '1'
  }
]

#######
# App #
#######

window.Residents = SC.Application.create()

##########
# Models #
##########

Residents.Resident = SC.Object.extend
  id: null
  dob: null
  gender: null
  full_name: null
  unit: null
  wing: null
  room: null
  bed: null

Residents.Unit = SC.Object.extend
  unit_wings: []
  unit_name: null
  isSelected: true

Residents.Wing = SC.Object.extend
  wing_residents: []
  wing_name: null

###############
# Controllers #
###############

Residents.residentsController = SC.ArrayProxy.create
  content: []

  createResident: (resident) ->
    @pushObject Residents.Resident.create
      id: resident.id
      dob: resident.dob
      gender: resident.gender
      full_name: resident.full_name
      unit: resident.unit
      wing: resident.wing
      room: resident.room
      bed: resident.bed

Residents.unitsController = SC.ArrayProxy.create
  content: []

  arrayDidChange: (addedObjects, removedObjects, changeIndex, addedCount) ->
    @_super(addedObjects, removedObjects, changeIndex, addedCount)

    if addedObjects? and addedObjects.length > 0
      for unit in unitsData
        if addedObjects[removedObjects].unit_name is unit.name
          addedObjects[removedObjects].residents = Residents.residentsController.filterProperty('unit', unit.name)

  createUnit: (unit) ->
    @pushObject Residents.Unit.create
      unit_name: unit.name
      unit_wings: unit.wings

Residents.wingsController = SC.ArrayProxy.create
  content: []

  createWing: (wing) ->
    @pushObject Residents.Wing.create
      wing_name: wing.name
      wing_residents: wing.residents

#########
# Views #
#########

Residents.ResidentsView = SC.CollectionView.extend
  contentBinding: 'Residents.unitsController'
  tagName: 'ul'

Residents.UnitFilterView = SC.CollectionView.extend
  contentBinding: 'Residents.unitsController'
  tagName: 'ul'

Residents.WingFilterView = SC.CollectionView.extend
  contentBinding: "parentView.content.unit_wings"
  tagName: 'ul'

Residents.FilterItemView = SC.Checkbox.extend
  contentBinding: 'Residents.unitsController'
  valueBinding: "parentView.content.isSelected"

#############
# Load Data #
#############

residents = for resident in residentsData
  Residents.residentsController.createResident(resident)

units = for unit in unitsData
  wings = for wing in unit.wings
    wing.wing_residents = []
    residents = Residents.residentsController.filterProperty('wing', wing.name)
    for resident in residents
      wing.wing_residents.push resident
      Residents.wingsController.createWing(wing)
  Residents.unitsController.createUnit(unit)
