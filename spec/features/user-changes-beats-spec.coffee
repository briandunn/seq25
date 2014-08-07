module 'Feature: user note actions must be constrained',
  setup: ->
    Seq25.ApplicationAdapter = DS.LSAdapter.extend namespace: 'seq25test'

  teardown: ->
    delete localStorage.seq25test
    Seq25.reset()

test 'change beats with keyboard', ->
  visit('/')
  click('li.empty')

  andThen ->
    equal(width(".measure"), "6.25%")

  andThen ->
    keyTrigger("4")
    keyTrigger("b q")

  andThen ->
    equal(width(".measure"), "5%")
