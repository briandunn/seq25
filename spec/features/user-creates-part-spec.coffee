module 'Feature: user creates part',
  setup: ->
    Seq25.ApplicationAdapter = DS.LSAdapter.extend namespace: 'seq25test'
    visit('/')
    click('button')

  teardown: ->
    delete localStorage.seq25test

test 'add new part', ->
  click('li.empty')

  andThen ->
    equal(find('section#piano-roll #keyboard li').eq(0).text().trim(), 'B7', "fantastic")

test 'add new note', ->
  click('li.empty')
  press("c")
  assertNotesLength(1)

test 'move note', ->
  click('li.empty')
  press("c")
  assertLeft("0%")
  press("right")
  assertLeft("6.25%")

test 'extend note', ->
  click('li.empty')
  press("c")
  assertWidth("6.25%")
  press("shift+right")
  assertWidth("12.5%")

assertNotesLength = (n) ->
  andThen ->
    equal(find(".notes li").length, n)
