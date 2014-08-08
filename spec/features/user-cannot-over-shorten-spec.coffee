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

test 'cannot move note to < 0', ->
  visit('/')
  click('li.empty')

  andThen ->
    keyTrigger("c")

  andThen ->
    equal(left(".notes li"), "0%")

  andThen ->
    keyTrigger("left")

  andThen ->
    equal(left(".notes li"), "0%")
