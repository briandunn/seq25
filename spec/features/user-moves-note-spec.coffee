module 'Feature: user moves note',
  setup: ->
    Seq25.ApplicationAdapter = DS.LSAdapter.extend namespace: 'seq25test'
    visit('/')
    click('button')
    click('li.empty')

  teardown: ->
    delete localStorage.seq25test

test 'move note when is quant is 0', ->

  press("2, 0, b")
  press("c")
  press("0, x")

  andThen ->
    equal(find("input#quant").val(), "0")

  assertLeft("0%")

  press("right")

  andThen ->
    value = left(".notes li")
    equal(value[0..4], "0.052")
