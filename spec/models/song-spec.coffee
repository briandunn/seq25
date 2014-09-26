moduleFor 'model:song', 'Song',
  needs:[
    'model:part'
    'model:instrument'
    'model:note'
  ]
  setup: (container)->
    Seq25.ApplicationAdapter = DS.LSAdapter.extend namespace: 'seq25test'
    Seq25.ApplicationSerializer = DS.LSSerializer.extend()

    container.register 'adapter:application', Seq25.ApplicationAdapter
    container.register 'serializer:application', Seq25.ApplicationSerializer
    DS._setupContainer(container)
    @store = container.lookup 'store:main'

  teardown: ->
    delete localStorage.seq25test
    Seq25.reset()

test 'loads empty songs', ->
  expect(1)
  localStorage.seq25test = JSON.stringify
    song:
      records:
        1:
          id: 1

  Seq25.Song.loadDefault(@store)
  .then (song)->
    equal song.get('id'), 1

test 'loads songs with parts', ->
  expect(1)
  localStorage.seq25test = JSON.stringify
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

  Seq25.Song.loadDefault(@store)
  .then (song)->
    equal song.get('parts.firstObject.id'), 'p'

test 'loads song with instruments', ->
  expect(1)
  localStorage.seq25test = JSON.stringify
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
          instruments: ['i']
    instrument:
      records:
        i:
          id: 'i'
          part: 'p'

  Seq25.Song.loadDefault(@store)
  .then (song)->
    equal song.get('parts.firstObject.instruments.firstObject.id'), 'i'
