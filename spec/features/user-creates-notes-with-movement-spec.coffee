module 'Feature: user creates part with movement',
  setup: ->
    Seq25.ApplicationAdapter = DS.LSAdapter.extend namespace: 'seq25test'
    visit('/')
    click('button')

  teardown: ->
    delete localStorage.seq25test

test 'add new note to the right', ->
  click('li.empty')
  press("c")
  assertNotesLength(1)
  press("ctrl+shift+right") #<--- action
  assertNotesLength(2)
  assertLeft("0%", 1)
  assertLeft("6.25%", 2)

test 'add new note to the left', ->
  click('li.empty')
  press("c, right")
  assertNotesLength(1)
  assertLeft("6.25%", 1)
  press("ctrl+shift+left") #<--- action
  assertNotesLength(2)
  assertLeft("6.25%", 1)
  assertLeft("0%", 2)

test 'add new note up', ->
  click('li.empty')
  press("c, down")
  assertNotesLength(1)
  assertLeft("0%", 1)
  press("ctrl+shift+up") #<--- action
  assertNotesLength(2)
  assertLeft("0%", 1)
  assertLeft("0%", 2)
  assertNotesLength(2)
  notesAreOnDifferentPitches(".notes li:nth-child(1)", ".notes li:nth-child(2)")

test 'add new note down', ->
  click('li.empty')
  press("c")
  assertNotesLength(1)
  assertLeft("0%", 1)
  press("ctrl+shift+down") #<--- action
  assertNotesLength(2)
  assertLeft("0%", 1)
  assertLeft("0%", 2)
  notesAreOnDifferentPitches(".notes li:nth-child(1)", ".notes li:nth-child(2)")

test 'new note from selected note has same length and is placed at end', ->
  click('li.empty')
  press("c, shift+right")
  assertNotesLength(1)
  press("ctrl+shift+right") #<--- action
  assertNotesLength(2)
  assertLeft("0%", 1)
  assertLeft("12.5%", 2)
  assertWidth("12.5%", 1)
  assertWidth("12.5%", 2)
