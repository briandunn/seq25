const ApplicationController = Ember.Controller.extend({

  showHelp: false,

  toggleHelp() {
    this.toggleProperty('showHelp');
    return this.send('openHelp');
  }
});

export default ApplicationController;
