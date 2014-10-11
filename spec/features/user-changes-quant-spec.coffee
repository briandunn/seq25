module 'Feature: User changes quant',
  setup: ->
    Seq25.ApplicationAdapter = DS.LSAdapter.extend namespace: 'seq25test'
    visit('/')
    click('button')
    click('li.empty')

  teardown: ->
    delete localStorage.seq25test

test 'change quant with keyboard', ->

  press("2, x")
  press("c")
  assertLeft("0%")

  press("2, 0, b")

  assertLeft("0%")

  press("right")

  assertLeft("2.5%")
