Seq25.setupForTesting()
emq.globalize()
setResolver Ember.DefaultResolver.create namespace: Seq25
Seq25.injectTestHelpers()

QUnit.testStart ->
  Seq25.reset()

parseStyles = (selector) ->
  styles = {}
  _.each(find(selector).attr("style").split(";"), (keyval) ->
    [key, value] = keyval.split(":")
    styles[key.trim()] = value?.trim()
  )
  styles

Ember.Test.registerAsyncHelper 'keyTrigger', (app, key) ->
  Mousetrap.trigger(key)

Ember.Test.registerHelper 'width', (app, selector) ->
  styles = parseStyles(selector)
  styles["width"]

Ember.Test.registerHelper 'left', (app, selector) ->
  styles = parseStyles(selector)
  styles["left"]
