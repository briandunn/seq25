Seq25.rootElement = '#qunit-fixture'
Seq25.setupForTesting()
emq.globalize()
setResolver Ember.DefaultResolver.create namespace: Seq25
Seq25.injectTestHelpers()

QUnit.testStart ->
  Seq25.reset()

QUnit.begin ->
  sinon.expectation.fail = sinon.assert.fail = (msg) -> QUnit.ok false, msg

  sinon.assert.pass = (assertion) -> QUnit.ok true, assertion

  sinon.config =
    injectIntoThis: true
    injectInto: null
    properties: ["spy", "stub", "mock", "clock", "sandbox"]
    useFakeTimers: false
    useFakeServer: false

  do ->
    qTest = QUnit.test

    QUnit.test = @test = (testName, expected, callback, async) ->
      if arguments.length == 2
        callback = expected
        expected = null

      qTest(testName, expected, sinon.test(callback), async)

parseStyles = (selector) ->
  styles = {}
  _.each(find(selector).attr("style").split(";"), (keyval) ->
    [key, value] = keyval.split(":")
    styles[key.trim()] = value?.trim()
  )
  styles

Ember.Test.registerAsyncHelper 'keyTrigger', (app, key) ->
  Seq25.Keystrokes.trigger(key)

Ember.Test.registerHelper 'width', (app, selector) ->
  styles = parseStyles(selector)
  styles["width"]

Ember.Test.registerHelper 'left', (app, selector) ->
  styles = parseStyles(selector)
  styles["left"]
