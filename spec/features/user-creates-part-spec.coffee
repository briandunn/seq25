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

  andThen ->
    keyTrigger("c")

  andThen ->
    equal(find(".notes li").length, 1)

test 'move note', ->
  click('li.empty')

  andThen ->
    keyTrigger("c")

  andThen ->
    equal(left(".notes li"), "0%")

  andThen ->
    keyTrigger("right")

  andThen ->
    equal(left(".notes li"), "6.25%")

test 'extend note', ->
  click('li.empty')

  andThen ->
    keyTrigger("c")

  andThen ->
    equal(width(".notes li"), "6.25%")

  andThen ->
    keyTrigger("shift+right")

  andThen ->
    equal(width(".notes li"), "12.5%")
