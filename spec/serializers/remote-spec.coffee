moduleFor 'serializer:remote', 'remote serializer',
  needs: [
    'model:midiInstrument'
    'model:note'
    'model:part'
    'model:song'
    'model:synthesizer'
  ]
  setup: (container)->
    stubAudio container
    @store = configureTestStore container

test 'creates a nested document', ->
  Em.run =>
    song = @store.createRecord('song', tempo: 100)
    part = song.get('parts').createRecord(name: 'Q')
    part.get('notes').createRecord(pitchNumber: 74)
    part.get('midiInstruments').createRecord(channel: 2)
    part.get('synthesizers').createRecord(attack: 0.5)

    payload = @subject().serialize(song)
    {parts:[{notes:[{pitchNumber: pitch}]}]} = payload
    equal pitch, 74
