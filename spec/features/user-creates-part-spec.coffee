feature 'Feature: user creates part'

test 'add new part', ->
  andThen ->
    equal(find('section#piano-roll #keyboard li').eq(0).text().trim(), 'C8', "fantastic")

test 'add new note', ->
  press("c")
  assertNotesLength(1)

test 'move note', ->
  press("c")
  assertLeft("0%")
  press("right")
  assertLeft("6.25%")

test 'extend note', ->
  press("c")
  assertWidth("6.25%")
  press("shift+right")
  assertWidth("12.5%")
