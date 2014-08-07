Ember.Test.registerAsyncHelper 'keyTrigger', (app, key) ->
  Mousetrap.trigger(key)

Ember.Test.registerHelper 'width', (app, selector) ->
  find(selector).attr("style").split(";")[1].split(": ")[1]

Ember.Test.registerHelper 'left', (app, selector) ->
  find(selector).attr("style").split(";")[0].split(": ")[1]

module 'Feature: user note actions must be constrained',
  setup: ->
    Seq25.ApplicationAdapter = DS.LSAdapter.extend namespace: 'seq25test'

  teardown: ->
    delete localStorage.seq25test
    Seq25.reset()

test 'cannot shorten note to 0', ->
  visit('/')
  click('li.empty')

  andThen ->
    keyTrigger("c")

  andThen ->
    equal(width(".notes li"), "6.25%")

  andThen ->
    keyTrigger("shift+left")

  andThen ->
    equal(width(".notes li"), "6.25%")
