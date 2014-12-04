feature 'Feature: selects notes'

test 'selected note changes color', ->
  expect(4)
  visit '/'
  click 'button'
  click 'li.empty'
  clickPosition '.notes'
  andThen ->
    equal find('.notes li.selected').length, 1
  clickPosition '.notes li'
  andThen ->
    notes = find('.notes')
    equal notes.length, 1
    equal notes.filter('.selected').length, 0
  clickPosition '.notes li'
  andThen ->
    equal find('.notes li.selected').length, 1

test 'clicking the next note selects it only', ->
  visit '/'
  click 'button'
  click 'li.empty'
  clickPosition '.notes'
  clickPosition '.notes', x: 100, y: 100
  andThen ->
    equal find('.notes li').length, 2
  clickPosition '.notes li'
  andThen ->
    notes = find('.notes li')
    ok notes.first().is('.selected')
    ok notes.last().is(':not(.selected)')
  clickPosition '.notes li:eq(1)'
  andThen ->
    notes = find('.notes li')
    equal notes.length, 2
    ok notes.first().is(':not(.selected)')
    ok notes.last().is('.selected')

test 'shift+clicking the next note selects it too', ->
  visit '/'
  click 'button'
  click 'li.empty'
  clickPosition '.notes'
  clickPosition '.notes', x: 100, y: 100
  clickPosition '.notes li'
  clickPosition '.notes li:eq(1)', shift: true
  andThen ->
    notes = find('.notes li')
    equal notes.length, 2
    ok notes.first().is('.selected')
    ok notes.last().is('.selected')
