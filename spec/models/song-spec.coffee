moduleFor 'model:song', 'Song',
  needs:[
    'model:part'
    'model:synthesizer'
    'model:midiInstrument'
    'model:note'
  ]
  setup: (container)->
    stubAudio container
    @store = configureTestStore container

  teardown: ->
    localStorage.removeItem('seq25test')
    Seq25.reset()

test 'loads empty songs', ->
  expect(1)
  localStorage.setItem 'seq25test', JSON.stringify
    song:
      records:
        1:
          id: 1

  Seq25.Song.load(@store, 1)
  .then (song)->
    equal song.get('id'), 1

test 'loads songs with parts', ->
  expect(1)
  localStorage.setItem 'seq25test', JSON.stringify
    song:
      records:
        s:
          id: 's'
          parts: ['p']
    part:
      records:
        p:
          id: 'p'
          song: 's'

  Seq25.Song.load(@store, 's')
  .then (song)->
    equal song.get('parts.firstObject.id'), 'p'

test 'loads song with instruments', ->
  expect(2)
  localStorage.setItem 'seq25test', JSON.stringify
    song:
      records:
        s:
          id: 's'
          parts: ['p']
    part:
      records:
        p:
          id: 'p'
          song: 's'
          synthesizers: ['syn']
          midiInstruments: ['midi']
    synthesizer:
      records:
        syn:
          id: 'syn'
          part: 'p'
    midiInstrument:
      records:
        midi:
          id: 'midi'
          part: 'p'

  Seq25.Song.load(@store, 's')
  .then (song)->
    deepEqual song.get('parts.firstObject.midiInstruments').mapProperty('id'), ['midi']
    deepEqual song.get('parts.firstObject.synthesizers').mapProperty('id'), ['syn']

test 'deletes parts when deleted', ->
  expect(2)
  localStorage.setItem 'seq25test', JSON.stringify
    song:
      records:
        s:
          id: 's'
          parts: ['p']
    part:
      records:
        p:
          id: 'p'
          song: 's'
          notes: ['n']
          synthesizers: ['syn']
          midiInstruments: ['midi']
    note:
      records:
        n:
          id: 'n'
          part: 'p'

    synthesizer:
      records:
        syn:
          id: 'syn'
          part: 'p'

    midiInstrument:
      records:
        midi:
          id: 'midi'
          part: 'p'

  Seq25.Song.load(@store, 's')
  .then (song)->
    equal song.get('parts.length'), 1
    song.destroyRecord()
    .then ->
      deepEqual JSON.parse(localStorage.seq25test),
        part:
          records: {}
        song:
          records: {}
        note:
          records: {}
        synthesizer:
          records: {}
        midiInstrument:
          records: {}
