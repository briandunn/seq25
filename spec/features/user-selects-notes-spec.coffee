module 'Feature: selects notes'

test 'selected note changest color', ->
  visit '/'
  click 'button'
  click 'li.empty'
  clickPosition '.notes'
  clickPosition '.notes li'
  andThen ->
    equal find('.notes li.selected').length, 1
