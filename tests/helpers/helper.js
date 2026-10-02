import Keystrokes from "seq25/models/keystrokes";
import startApp from '../helpers/start-app';
import {stubAudio} from '../helpers/unit';
let server = null;

QUnit.testStart(function() {
  server = sinon.fakeServer.create();
  server.autoRespond = true;
  return server.respondWith("GET", "/songs", request => Ember.run(() => request.respond(200, { "Content-Type": "application/json" }, '[]')));
});

QUnit.testDone(() => server.restore());

QUnit.begin(function() {

  sinon.expectation.fail = (sinon.assert.fail = msg => QUnit.ok(false, msg));

  sinon.assert.pass = assertion => QUnit.ok(true, assertion);

  return sinon.config = {
    injectIntoThis: true,
    injectInto: null,
    properties: ["spy", "stub", "mock", "clock", "sandbox"],
    useFakeTimers: false,
    useFakeServer: true
  };
});

const parseStyles = selector => find(selector).attr('style').match(/\S*:[^;]*/g)
.map(style => style.split(/\s*:\s*/))
.reduce(
  (function(styles, ...rest){
    const [k,v] = Array.from(rest[0]);
    styles[k] = v;
    return styles;
  }),{});

const feature = function(title) {
  let application = null;
  return module(`Acceptance: ${title}`, {
    beforeEach() {
      application = startApp();
      stubAudio(application);
      visit('/');
      click('button');
      click('li.empty');
    },

    afterEach() {
      window.localStorage.removeItem('seq25');
      return Ember.run(application, 'destroy');
    }
  }
  );
};

const helpers = (function() {
  Ember.Test.registerAsyncHelper('keyTrigger', (app, key) => Keystrokes.trigger(key));

  Ember.Test.registerHelper('width', function(app, selector) {
    const styles = parseStyles(selector);
    return styles["width"];
});

  Ember.Test.registerHelper('topStyle', function(app, selector) {
    const styles = parseStyles(selector);
    return styles["top"];
});

  Ember.Test.registerAsyncHelper('clickPosition', function(app, selector, options){
    if (options == null) { options = {}; }
    const {x, y, shift} = options;
    const el = find(selector);
    if (el.length !== 1) { throw `${selector} is ambiguous. matched ${el.length} elements.`; }
    const {top, left} = el.offset();
    return Array.from('mousedown click mouseup'.w()).map((eventName) =>
      el.trigger(Em.$.Event(eventName, {pageX: left + (x || 0), pageY: top + (y || 0), shiftKey: shift})));
  });

  Ember.Test.registerHelper('left', function(app, selector) {
    const styles = parseStyles(selector);
    return styles["left"];
});

  Ember.Test.registerAsyncHelper('assertLeft', function(app, l, noteIndex) {
    if (noteIndex == null) { noteIndex = 1; }
    return equal(left(`.notes li:nth-child(${noteIndex})`), l);
  });

  Ember.Test.registerAsyncHelper('assertWidth', function(app, w, noteIndex) {
    if (noteIndex == null) { noteIndex = 1; }
    return equal(width(`.notes li:nth-child(${noteIndex})`), w);
  });

  Ember.Test.registerAsyncHelper('assertNotesLength', (app, n) => equal(find(".notes li").length, n));

  Ember.Test.registerAsyncHelper('assertSelectedNotesLength', (app, n) => equal(find(".notes li.selected").length, n));

  Ember.Test.registerHelper('press', (app, keys) => andThen(() => Array.from(keys.split(",")).map((k) =>
    keyTrigger(k.trim()))));

  Ember.Test.registerAsyncHelper('notesAreOnDifferentPitches', function(app, firstNote, secondNote) {
    const topA = topStyle(firstNote);
    const topB = topStyle(secondNote);
    return notEqual(topA, topB);
  });

  return Ember.Test.registerHelper('visitRoute', (app, routeName) => app.__container__.lookup('router:main').transitionTo(routeName));
})();

export {helpers, feature};
