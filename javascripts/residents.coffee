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

# This hide is not working for wings yet. Same thing works for the unit just fine.
Residents.Unit = SC.Object.extend
  wings: [{hide: false}]
  unit_name: null

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
      wings: unit.wings

#########
# Views #
#########

Residents.UnitsView = SC.CollectionView.extend
  contentBinding: 'Residents.unitsController'
  tagName: 'ul'

Residents.UnitsFilterView = SC.Checkbox.extend
  contentBinding: 'Residents.unitsController'
  tagName: 'ul'

#############
# Load Data #
#############

residents = for resident in residentsData
  Residents.residentsController.createResident(resident)

units = for unit in unitsData
  Residents.unitsController.createUnit(unit)