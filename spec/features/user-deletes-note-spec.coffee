feature 'Feature: user deletes note'

test 'delete selected note', ->
  visit '/'
  click 'button'
  click 'li.empty'
  clickPosition '.notes'
  andThen ->
    equal $('li.selected').length, 1
  keyTrigger "backspace"
  andThen ->
    equal find('.notes').find('li').length, 0
  andThen ->
    deepEqual JSON.parse(localStorage.seq25test).note.records, {}
