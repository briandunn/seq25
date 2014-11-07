module 'Feature: user deletes note',
  setup: ->
    delete localStorage.seq25test
    Seq25.ApplicationAdapter = DS.LSAdapter.extend namespace: 'seq25test'

test 'delete selected note', ->
  visit('/')
  click('button')
  click('li.empty')
  clickPosition '.notes'
  clickPosition '.notes li'
  keyTrigger("backspace")
  andThen ->
    equal find('.notes').find('li').length, 0
  andThen ->
    deepEqual JSON.parse(localStorage.seq25test).note.records, {}
