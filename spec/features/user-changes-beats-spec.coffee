module 'Feature: user note actions must be constrained',
  setup: ->
    Seq25.ApplicationAdapter = DS.LSAdapter.extend namespace: 'seq25test'

  teardown: ->
    delete localStorage.seq25test

test 'change beats with keyboard', ->
  visit('/')
  click('li.empty')

  andThen ->
    equal(width(".measure"), "6.25%")

  andThen ->
    keyTrigger("2")
    keyTrigger("0")
    keyTrigger("b")

  andThen ->
    equal(width(".measure"), "5%")

test 'change beats with keyboard should change note width', ->
  visit('/')
  click('li.empty')

  andThen ->
    keyTrigger("c")

  andThen ->
    equal(width(".notes li"), "6.25%")

  andThen ->
    keyTrigger("2")
    keyTrigger("0")
    keyTrigger("b")

  andThen ->
    equal(width(".notes li"), "5%")
