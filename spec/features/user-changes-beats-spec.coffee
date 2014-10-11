module 'Feature: user note actions must be constrained',
  setup: ->
    Seq25.ApplicationAdapter = DS.LSAdapter.extend namespace: 'seq25test'
    visit('/')
    click('button')
    click('li.empty')

  teardown: ->
    delete localStorage.seq25test

test 'change beats with keyboard', ->

  assertMeasureWidth("6.25%")
  press("2, 0, b")
  assertMeasureWidth("5%")

test 'change beats with keyboard should change note width', ->

  press("c")
  assertWidth("6.25%")
  press("2, 0, b")
  assertMeasureWidth("5%")

assertMeasureWidth = (w) ->
  andThen ->
    equal(width(".measure"), w)
