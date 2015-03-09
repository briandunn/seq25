`import Ember from 'ember'`
`import { module, test } from 'qunit'`
`import startApp from '../helpers/start-app'`
`import {stubAudio} from '../helpers/unit'`
`import {helpers} from '../helpers/helper'`

application = null

module 'Acceptance: user creates part',
  beforeEach: ->
    window.localStorage.removeItem 'seq25'
    application = startApp()
    stubAudio(application)
    visit('/')
    click('button')
    click('li.empty')
    return

  afterEach: ->
    Ember.run application, 'destroy'

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
