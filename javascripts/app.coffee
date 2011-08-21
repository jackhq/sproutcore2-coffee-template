window.ResidentApp = SC.Application.create()

ResidentApp.Patient = SC.Object.extend
  name: null
  
ResidentApp.patientsController = SC.ArrayProxy.create
  content: []
  createPatient: (attributes) ->
    patient = ResidentApp.Patient.create(attributes)
    this.pushObject = patient
    true

ResidentApp.CreatePatientView = SC.TextField.extend
  insertNewline: ->
    value = @get('value')
    if value
      ResidentApp.patientsController.createPatient({ name: value})
      @set('value','')
    true