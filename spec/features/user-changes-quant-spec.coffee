module 'Feature: User changes quant',
  setup: ->
    Seq25.ApplicationAdapter = DS.LSAdapter.extend namespace: 'seq25test'

  teardown: ->
    delete localStorage.seq25test

test 'change quant with keyboard', ->
  visit('/')
  click('li.empty')

  andThen ->
    keyTrigger("2")

  andThen ->
    keyTrigger("x")

  andThen ->
    keyTrigger("c")

  andThen ->
    equal(left(".notes li"), "0%")

  andThen -> #set beats to 20 for nice %s
    keyTrigger("2")
    keyTrigger("0")
    keyTrigger("b")

  andThen ->
    equal(left(".notes li"), "0%")

  andThen ->
    keyTrigger("right")

  andThen ->
    equal(left(".notes li"), "2.5%")
