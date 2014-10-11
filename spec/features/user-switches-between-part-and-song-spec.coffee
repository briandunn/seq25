module 'Feature: user switches between part and song',
  setup: ->
    Seq25.ApplicationAdapter = DS.LSAdapter.extend namespace: 'seq25test'
    visit('/')
    click('button')

  teardown: ->
    delete localStorage.seq25test

test 'user switches between part and song', ->

  assertView("song")
  press("q, g")
  assertView("part")
  press("t")
  assertView("song")

assertView = (viewName) ->
  andThen ->
    if viewName == "part"
      equal(find('section#piano-roll').length, 1)
      equal(find('#parts').length, 0)
    else if viewName == "song"
      equal(find('section#piano-roll').length, 0)
      equal(find('#parts').length, 1)
    else
      equal(false)
