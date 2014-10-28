module 'Feature: user switches between part and song',
  setup: ->
    Seq25.ApplicationAdapter = DS.LSAdapter.extend namespace: 'seq25test'
    visit('/')
    click('button')

  teardown: ->
    delete localStorage.seq25test

test 'user switches between part and song', ->

  andThen ->
    equal(find('section#piano-roll').length, 0)
    equal(find('#parts').length, 1)

  andThen ->
    keyTrigger("q")
    keyTrigger("g")

  andThen ->
    equal(find('section#piano-roll').length, 1)
    equal(find('#parts').length, 0)

  andThen ->
    keyTrigger("t")

  andThen ->
    equal(find('section#piano-roll').length, 0)
    equal(find('#parts').length, 1)
