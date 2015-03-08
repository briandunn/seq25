`import { test, moduleFor } from "ember-qunit"`
`import {configureTestStore, stubAudio} from "../../helpers/unit"`

moduleFor 'serializer:remote',
  needs: [
    'model:midiInstrument'
    'model:note'
    'model:part'
    'model:song'
    'model:synthesizer'
  ]

test 'creates a nested document', ->
  Em.run =>
    configureTestStore @container
    stubAudio @container

    store = @container.lookup 'store:main'

    song = store.createRecord('song', tempo: 100)
    part = song.get('parts').createRecord(name: 'Q')
    part.get('notes').createRecord(pitchNumber: 74)
    part.get('midiInstruments').createRecord(channel: 2)
    part.get('synthesizers').createRecord(attack: 0.5)

    #song must be a DS.Snapshot. wtf?
    payload = @subject().serialize(new DS.Snapshot(song))
    {parts:[{notes:[{pitchNumber: pitch}]}]} = payload
    equal pitch, 74
