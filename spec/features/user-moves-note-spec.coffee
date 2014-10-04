module 'Feature: user moves note',
  setup: ->
    Seq25.ApplicationAdapter = DS.LSAdapter.extend namespace: 'seq25test'
    visit('/')
    click('button')
    click('li.empty')

  teardown: ->
    delete localStorage.seq25test

test 'move note when is quant is 0', ->

  andThen -> #set beats to 20 for nice %s
    keyTrigger("2")
    keyTrigger("0")
    keyTrigger("b")

  andThen ->
    keyTrigger("c")

  andThen ->
    keyTrigger("0")
    keyTrigger("x")

  andThen ->
    equal(find("input#quant").val(), "0")

  andThen ->
    equal(left(".notes li"), "0%")

  andThen ->
    keyTrigger("right")

  andThen ->
    value = left(".notes li")
    equal(value[0..4], "0.052")
