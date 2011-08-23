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

  isSelectedWillChange: ( ->
    # This attribute is being set correctly.
    # The unit name changes to 'Foo' when checked.
    # However, iterating over the unit wings
    # and updating the isSelected property
    # isn't working correctly.
    # There is an issues with the wing bindings below.
    # -pb
    this.set('unit_name', 'Foo')
  ).observes('*isSelected')

Residents.Wing = SC.Object.extend
  wing_residents: []
  name: null
  isSelected: true

  isSelectedWillChange: ( ->
    # These attributes are not being set correctly.
    # The point of this setter is test that the
    # bindings are working correctly.
    # The wing name should change to 'Bar' when checked.
    # -pb
    this.set('name', 'Bar')
    this.set('isSelected', true)
    console.log this
  ).observes('*isSelected')

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

  createUnit: (unit) ->
    @pushObject Residents.Unit.create
      unit_name: unit.name
      unit_wings: unit.wings

Residents.wingsController = SC.ArrayProxy.create
  content: []

  createWing: (wing) ->
    @pushObject Residents.Wing.create
      name: wing.name
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

Residents.UnitFilterItemView = SC.Checkbox.extend
  contentBinding: 'Residents.unitsController'
  valueBinding: "parentView.content.isSelected"

Residents.WingFilterView = SC.CollectionView.extend
  contentBinding: "parentView.content.unit_wings"
  tagName: 'ul'

Residents.WingFilterItemView = SC.Checkbox.extend
  # Not sure which binding is correct. WIP -pb
  # contentBinding: 'parentView.content.unit_wings'
  contentBinding: 'parentView.content.unit_wings'
  valueBinding: "parentView.content.isSelected"

#############
# Load Data #
#############

for resident in residentsData
  Residents.residentsController.createResident(resident)

for unit in unitsData
  for wing in unit.wings
    wing.wing_residents = []
    wing.isSelected = true

    residents = Residents.residentsController.filterProperty('wing', wing.name)
    for resident in residents
      wing.wing_residents.push resident
      Residents.wingsController.createWing(wing)

  Residents.unitsController.createUnit(unit)
