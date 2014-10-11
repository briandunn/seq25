Seq25.rootElement = '#qunit-fixture'
Seq25.setupForTesting()
emq.globalize()
setResolver Ember.DefaultResolver.create namespace: Seq25
Seq25.injectTestHelpers()

server = null

QUnit.testStart ->
  server = sinon.fakeServer.create()
  server.autoRespond = true
  server.respondWith "GET", "/songs", (request)->
    Ember.run ->
      request.respond 200, { "Content-Type": "application/json" }, '[]'

  Seq25.reset()

QUnit.testDone ->
  server.restore()

QUnit.begin ->
  $('head').append(
    $ '<link/>',
      rel:"stylesheet"
      type:"text/css"
      href: "http://localhost:8000/css/app.css"
      media:"all"
  )

  $('#qunit-fixture').css
    top: 'calc(100% - 384px)'
    left: 'calc(100% - 640px)'
    position: 'fixed'
    background: 'white'
    bottom: 0
    right: 0
    width: '640px'
    height: '384px'
    overflow: 'auto'
    zIndex: 9999
    border: '1px solid #ccc'

  sinon.expectation.fail = sinon.assert.fail = (msg) -> QUnit.ok false, msg

  sinon.assert.pass = (assertion) -> QUnit.ok true, assertion

  sinon.config =
    injectIntoThis: true
    injectInto: null
    properties: ["spy", "stub", "mock", "clock", "sandbox"]
    useFakeTimers: false
    useFakeServer: true

  do ->
    qTest = QUnit.test

    QUnit.test = @test = (testName, expected, callback, async) ->
      if arguments.length == 2
        callback = expected
        expected = null

      qTest(testName, expected, sinon.test(callback), async)

parseStyles = (selector) ->
  styles = {}
  _.each(find(selector).attr("style").split(/\s*;\s*/), (keyval) ->
    [key, value] = keyval.split /\s*:\s*/
    styles[key.trim()] = value?.trim()
  )
  styles

Ember.Test.registerHelper 'stubAudio', (app, container) ->
  stubContext =
    createGain: ->
      connect: ->
      gain: {}
  container.register 'audioContext:main', stubContext

Ember.Test.registerHelper 'configureTestStore', (app, container) ->
  container.register 'adapter:application', DS.LSAdapter.extend(namespace: 'seq25test')
  container.register 'serializer:application', DS.LSSerializer.extend()
  DS._setupContainer container
  container.lookup 'store:main'

Ember.Test.registerAsyncHelper 'keyTrigger', (app, key) ->
  Seq25.Keystrokes.trigger(key)

Ember.Test.registerHelper 'width', (app, selector) ->
  styles = parseStyles(selector)
  styles["width"]

Ember.Test.registerAsyncHelper 'clickPosition', (app, selector, options={})->
  {x, y, shift} = options
  el = app.testHelpers.findWithAssert(selector)
  {top, left} = el.offset()
  for eventName in 'mousedown click mouseup'.w()
    el.trigger Em.$.Event eventName, pageX: left + (x || 0), pageY: top + (y || 0), shiftKey: shift

Ember.Test.registerHelper 'left', (app, selector) ->
  styles = parseStyles(selector)
  styles["left"]

Ember.Test.registerHelper 'assertLeft', (app, l) ->
  andThen ->
    equal(left(".notes li"), l)

Ember.Test.registerHelper 'assertWidth', (app, w) ->
  andThen ->
    equal(width(".notes li"), w)

Ember.Test.registerHelper 'press', (app, keys) ->
  andThen ->
    for k in keys.split(",")
      keyTrigger(k.trim())
