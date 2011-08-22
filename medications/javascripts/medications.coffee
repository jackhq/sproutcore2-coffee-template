#######
# App #
#######

window.ResidentsShow = SC.Application.create()

##########
# Models #
##########

ResidentsShow.Resident = SC.Object.extend
  id: null
  name: null
  dob: null
  gender: null
  unit: null
  wing: null
  room: null
  bed: null


ResidentsShow.Medication = SC.Object.extend
  id: null
  resident_id: null
  name: null
  strength: null
  form: null
  sig: null
  rx_medical_note: null
  last_administered_by: null
  last_administered_at: null
  image_filename: null
  early_morning: false
  morning: false
  noon: false
  evening: false
  before_bedtime: false
  bedtime: false
  other: false
  as_needed: false
  editMode: false
  state: null
  administration_comments: null

ResidentsShow.Allergy = SC.Object.extend
  id: null
  resident_id: null
  name: null
  concept_type: null

ResidentsShow.TimeTaken = SC.Object.extend
  title: null
  medications: []
  hide: false
  editable: false
  medication_count: SC.computed -> @medications.length


###############
# Controllers #
###############

ResidentsShow.residentsController = SC.ArrayProxy.create
  content: []
  createResident: (attributes) -> @pushObject ResidentsShow.Resident.create(attributes)

ResidentsShow.timesTakenController = SC.ArrayProxy.create
  content: []
  create: (attributes) -> @pushObject ResidentsShow.TimeTaken.create attributes


ResidentsShow.medicationsController = SC.ArrayProxy.create
  content: []

  arrayDidChange: (item, idx, removeCnt, addedCnt) ->
    @_super(item, idx, removeCnt, addedCnt)
    times_taken = ['early_morning', 'morning', 'noon', 'evening', 'before_bedtime', 'bedtime', 'other', 'as_needed']
    states = ['current', 'morning', 'on_hold', 'discontinued']
    for time_taken in times_taken
      @set(time_taken, @filterProperty(time_taken, true))
    for state in states
      @set(state, @filterProperty('state', state))

  createMedication: (attributes) -> @pushObject ResidentsShow.Medication.create attributes


ResidentsShow.allergiesController = SC.ArrayProxy.create
  content: []
  createAllergy: (attributes) -> @pushObject ResidentsShow.Allergy.create attributes

#########
# Views #
#########

ResidentsShow.MedicationDetailView = SC.View.extend
  templateName: 'medication-detail'

ResidentsShow.MedicationCollectionView = SC.CollectionView.extend
  itemViewClass: ResidentsShow.MedicationDetailView
  tagName: 'ul'

ResidentsShow.ResidentDetailView = SC.View.extend
  templateName: 'resident-detail'

ResidentsShow.ResidentCollectionView = SC.CollectionView.extend
  itemViewClass: ResidentsShow.ResidentDetailView
  tagName: 'ul'

ResidentsShow.TimeTakenDetailView = SC.View.extend
  templateName: 'time-taken-detail'

ResidentsShow.TimesTakenCollectionView = SC.CollectionView.extend
  itemViewClass: ResidentsShow.TimeTakenDetailView
  tagName: 'ul'

ResidentsShow.EditModeView = SC.Checkbox.extend
  valueBinding: "parentView.content.editable"
  classNames: 'right'

ResidentsShow.HideView = SC.Checkbox.extend
  valueBinding: "parentView.content.hide"
  classNames: 'left'

#############
# Mock Data #
#############

genders = -> ["M","F"]
units = -> ["Unit 1","Unit 2","Concelman"]
wings = -> ["Hall A", "Hall B"]
rooms = -> [1,2,3,4,5,6,7,8]
beds = -> ['Private', 'A','B']

med_names = -> ["Plavix Oral", "Bentyl", "Albuterol Inhl", "Adalimumab", "Methotrexate (Anti-Rheumatic) Oral", "Prednisone Oral", "Prevacid", "Methotrexate Na (Preserv Free) Inj", "Penicillin G", "Percocet Oral", "Tylenol Oral", "Morphine", "Oxycodone Oral", "Neurontin", "Loratadine Oral", "Omeprazole Oral", "Desipramine", "Amitriptyline Oral", "Ranitidine Oral", "Warfarin"]
strengths = -> ['5 mg', '10 mg', '25mg', '50 mg']
forms = -> ['tablet', 'capsule']
sigs = -> ['Take 2 tablets (5mg) by mouth twice a day as needed for pain.', 'Take 1 capsule by mouth at bedtime for blood pressure.', '2.0 TAB(s) once a day (at bedtime)']
rx_medical_notes = -> ["Refill send to Episcopo's", "Participant request for a refill at his visit today in the clinic.", "Ordered by Hamilton GI"]
allergy_names = -> ['penicillins', 'donepezil', 'carbamazepine', 'codeine', 'sulfa drugs']
allergy_types = -> ['allergen', 'ingredient']
true_false = -> [true, false]

times_taken = [{title: "Early Morning", name: "early_morning"}, {title: "Morning", name: "morning"}, {title: "Noon", name: "noon"}, {title: "Evening", name: "evening"}, {title: "Before Bedtime", name: "before_bedtime"}, {title: "Bedtime", name: "bedtime"}, {title: "Other", name: "other"}, {title: "As Needed", name: "as_needed"}]

medication_states = ['current', 'on_hold', 'discontinued']

# Faker Generate Meds
for resident_id in [1]
  ResidentsShow.residentsController.createResident
    id: resident_id
    name: Faker.Name.findName()
    dob: Date.create("#{Faker.Helpers.randomNumber(80).toString()} years ago").format('{MM}-{dd}-{yyyy}')
    gender: Faker.Helpers.randomize(genders())
    unit: Faker.Helpers.randomize(units())
    wing: Faker.Helpers.randomize(wings())
    room: Faker.Helpers.randomize(rooms())
    bde: Faker.Helpers.randomize(beds())

  for med_id in [1..20]
    ResidentsShow.medicationsController.createMedication
      id: med_id
      resident_id: resident_id
      name: Faker.Helpers.randomize(med_names())
      strength: Faker.Helpers.randomize(strengths())
      form: Faker.Helpers.randomize(forms())
      sig: Faker.Helpers.randomize(sigs())
      rx_medical_note: Faker.Helpers.randomize(rx_medical_notes())
      last_administered_by: Faker.Name.findName()
      last_administered_at: Date.create("#{Faker.Helpers.randomNumber(80).toString()}").format('{MM}-{dd}-{yyyy}')
      image_filename: '../images/jrs-logo.png'
      early_morning: Faker.Helpers.randomize(true_false())
      morning: Faker.Helpers.randomize(true_false())
      noon: Faker.Helpers.randomize(true_false())
      evening: Faker.Helpers.randomize(true_false())
      before_bedtime: Faker.Helpers.randomize(true_false())
      bedtime: Faker.Helpers.randomize(true_false())
      other: Faker.Helpers.randomize(true_false())
      as_needed: Faker.Helpers.randomize(true_false())
      state: Faker.Helpers.randomize(medication_states)
      administration_comments: "hello world"

  for time_taken in times_taken
    ResidentsShow.timesTakenController.create
      title: time_taken.title
      medications: ResidentsShow.medicationsController.filterProperty('state', 'current').filterProperty(time_taken.name, true)

  for allergy_id in [1..5]
    ResidentsShow.allergiesController.createAllergy
      id: allergy_id
      resident_id: resident_id
      name: Faker.Helpers.randomize(allergy_names())
      concept_type: Faker.Helpers.randomize(allergy_types())
