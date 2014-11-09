module 'Feature: user creates and destroys song spec',
  setup: ->
    Seq25.ApplicationAdapter = DS.LSAdapter.extend namespace: 'seq25test'
    visit('/')
    click('button')

  teardown: ->
    delete localStorage.seq25test

test 'create song and then delete song', ->
  click('li.empty')
  visitRoute("songs")
  andThen ->
    equal(find("li.song").length, 1)
  click('#songs ul li.song:first-child .actions:first-child button:first-child')
  equal(find("li.song").length, 0)
