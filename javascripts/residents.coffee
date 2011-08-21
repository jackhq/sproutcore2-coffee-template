#############
# Mock Data #
#############

unitsData = [
  {
    name: 'Unit A',
    wings: ['Wing 1', 'Wing 2']
  },
  {
    name: 'Unit B',
    wings: ['Wing 3', 'Wing 4']
  },
  {
    name: 'Unit C',
    wings: ['Wing 5', 'Wing 6']
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
  wings: []
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

Residents.unitsView = SC.CollectionView.extend
  contentBinding: 'Residents.unitsController'
  tagName: 'ul'

Residents.residentsView = SC.CollectionView.extend
  contentBinding: 'Residents.residentsController'
  tagName: 'ul'

#############
# Load Data #
#############

residents = for resident in residentsData
  Residents.residentsController.createResident(resident)

units = for unit in unitsData
  Residents.unitsController.createUnit(unit)
