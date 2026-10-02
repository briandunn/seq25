import Keystrokes from "seq25/models/keystrokes";

const ApplicationView = Ember.View.extend({
  didInsertElement() {
    return Keystrokes.bind("shift+?", () => {
      return this.get('controller').toggleHelp();
    });
  }
});

export default ApplicationView;
