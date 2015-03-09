`import startApp from '../helpers/start-app'`
`import {stubAudio} from '../helpers/unit'`
`import {test, module} from 'qunit'`
`import {helpers} from '../helpers/helper'`

application = null
module 'Acceptance: chooses song',
  beforeEach: ->
    localStorage.setItem 'seq25', JSON.stringify
      song:
        records:
          s:
            id: 's'
            parts: ['p']
      part:
        records:
          p:
            id: 'p'
            name: 'Q'
            beat_count: 16
            song: 's'
            notes: ['n']
      note:
        records:
          n:
            id: 'n'
            part: 'p'

    application = startApp()
    stubAudio(application)

  afterEach: ->
    window.localStorage.removeItem 'seq25'
    Ember.run application, 'destroy'

test 'see song preview', ->

  visit('/')
  andThen ->
    equal find('#songs .song ul.notes li.Q').length, 1
