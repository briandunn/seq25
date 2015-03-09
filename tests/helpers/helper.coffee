`import Keystrokes from "seq25/models/keystrokes"`
server = null

QUnit.testStart ->
  server = sinon.fakeServer.create()
  server.autoRespond = true
  server.respondWith "GET", "/songs", (request)->
    Ember.run ->
      request.respond 200, { "Content-Type": "application/json" }, '[]'

QUnit.testDone ->
  server.restore()

QUnit.begin ->

  sinon.expectation.fail = sinon.assert.fail = (msg) -> QUnit.ok false, msg

  sinon.assert.pass = (assertion) -> QUnit.ok true, assertion

  sinon.config =
    injectIntoThis: true
    injectInto: null
    properties: ["spy", "stub", "mock", "clock", "sandbox"]
    useFakeTimers: false
    useFakeServer: true

parseStyles = (selector) ->
  find(selector).attr('style').match(/\S*:[^;]*/g)
  .map((style)-> style.split(/\s*:\s*/))
  .reduce(
    ((styles, [k,v])->
      styles[k] = v
      styles
    ),{})

helpers = do ->
  Ember.Test.registerAsyncHelper 'keyTrigger', (app, key) ->
    Keystrokes.trigger(key)

  Ember.Test.registerHelper 'width', (app, selector) ->
    styles = parseStyles(selector)
    styles["width"]

  Ember.Test.registerHelper 'topStyle', (app, selector) ->
    styles = parseStyles(selector)
    styles["top"]

  Ember.Test.registerAsyncHelper 'clickPosition', (app, selector, options={})->
    {x, y, shift} = options
    el = app.testHelpers.findWithAssert(selector)
    {top, left} = el.offset()
    for eventName in 'mousedown click mouseup'.w()
      el.trigger Em.$.Event eventName, pageX: left + (x || 0), pageY: top + (y || 0), shiftKey: shift

  Ember.Test.registerHelper 'left', (app, selector) ->
    styles = parseStyles(selector)
    styles["left"]

  Ember.Test.registerAsyncHelper 'assertLeft', (app, l, noteIndex=1) ->
    equal(left(".notes li:nth-child(#{noteIndex})"), l)

  Ember.Test.registerAsyncHelper 'assertWidth', (app, w, noteIndex=1) ->
    equal(width(".notes li:nth-child(#{noteIndex})"), w)

  Ember.Test.registerAsyncHelper 'assertNotesLength', (app, n) ->
    equal(find(".notes li").length, n)

  Ember.Test.registerAsyncHelper 'assertSelectedNotesLength', (app, n) ->
    equal(find(".notes li.selected").length, n)

  Ember.Test.registerHelper 'press', (app, keys)->
    andThen ->
      for k in keys.split(",")
        keyTrigger(k.trim())

  Ember.Test.registerAsyncHelper 'notesAreOnDifferentPitches', (app, firstNote, secondNote) ->
    topA = topStyle(firstNote)
    topB = topStyle(secondNote)
    notEqual(topA, topB)

  Ember.Test.registerHelper 'visitRoute', (app, routeName) ->
    app.__container__.lookup('router:main').transitionTo(routeName)

`export {helpers}`
