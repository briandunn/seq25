feature 'Feature: user creates part with movement'

test 'add new note left from selected note has same length and is placed at end', ->
  press("c, right, right, shift+right")
  assertNotesLength(1)
  assertLeft("12.5%", 1)
  press("ctrl+shift+left") #<--- action
  assertNotesLength(2)
  assertLeft("12.5%", 1)
  assertLeft("0%", 2)
  assertWidth("12.5%", 1)
  assertWidth("12.5%", 2)

test 'add new note up', ->
  press("c, down, shift+right")
  assertNotesLength(1)
  assertLeft("0%", 1)
  press("ctrl+shift+up") #<--- action
  assertNotesLength(2)
  assertLeft("0%", 1)
  assertLeft("0%", 2)
  assertNotesLength(2)
  notesAreOnDifferentPitches(".notes li:nth-child(1)", ".notes li:nth-child(2)")
  assertWidth("12.5%", 1)
  assertWidth("12.5%", 2)

test 'add new note down', ->
  press("c, shift+right")
  assertNotesLength(1)
  assertLeft("0%", 1)
  press("ctrl+shift+down") #<--- action
  assertNotesLength(2)
  assertLeft("0%", 1)
  assertLeft("0%", 2)
  notesAreOnDifferentPitches(".notes li:nth-child(1)", ".notes li:nth-child(2)")
  assertWidth("12.5%", 1)
  assertWidth("12.5%", 2)

test 'new note right from selected note has same length and is placed at end', ->
  press("c, shift+right")
  assertNotesLength(1)
  press("ctrl+shift+right") #<--- action
  assertNotesLength(2)
  assertLeft("0%", 1)
  assertLeft("12.5%", 2)
  assertWidth("12.5%", 1)
  assertWidth("12.5%", 2)

test 'new note right from selected note is x * duration away from note', ->
  press("c, shift+right")
  assertNotesLength(1)
  press("2, ctrl+shift+right") #<--- action
  assertNotesLength(2)
  assertLeft("0%", 1)
  assertLeft("25%", 2) #<-- key difference
  assertWidth("12.5%", 1)
  assertWidth("12.5%", 2)

test 'add new note left from selected note is x * duration in front of note', ->
  press("c, 4, right, shift+right")
  assertNotesLength(1)
  assertLeft("25%", 1)
  press("2, ctrl+shift+left") #<--- action
  assertNotesLength(2)
  assertLeft("25%", 1)
  assertLeft("0%", 2)
  assertWidth("12.5%", 1)
  assertWidth("12.5%", 2)

test 'if multiple notes selected are different lengths, move by quant', ->
  press("c, down, shift+right")
  press("c")
  assertNotesLength(2)
  andThen ->
    triggerEvent(".notes li:nth-child(1)", 'click', {shiftKey: true})
  assertSelectedNotesLength(2)
  press("ctrl+shift+right") #<--- action
  assertNotesLength(4)
  assertLeft("0%", 1)
  assertLeft("0%", 2)
  assertLeft("6.25%", 3)
  assertLeft("6.25%", 4)

test 'two moves makes two more notes', ->
  press("c, ctrl+shift+right, ctrl+shift+right")
  assertNotesLength(3)
