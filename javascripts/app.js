(function() {
  window.ResidentApp = SC.Application.create();
  ResidentApp.Patient = SC.Object.extend({
    name: null
  });
  ResidentApp.patientsController = SC.ArrayProxy.create({
    content: [],
    createPatient: function(attributes) {
      var patient;
      patient = ResidentApp.Patient.create(attributes);
      this.pushObject = patient;
      return true;
    }
  });
  ResidentApp.CreatePatientView = SC.TextField.extend({
    insertNewline: function() {
      var value;
      value = this.get('value');
      if (value) {
        ResidentApp.patientsController.createPatient({
          name: value
        });
        this.set('value', '');
      }
      return true;
    }
  });
}).call(this);
