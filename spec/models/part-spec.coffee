part = store = null
moduleForModel 'part', 'Part', needs: [
  'model:note'
  'model:song'
  'model:synthesizer'
  'model:midiInstrument'
],
setup: ->
  part = @subject()
  store = @store()
  Ember.run ->
    part.set 'song', store.createRecord('song')

test 'schedule: schedules all notes again when the loop repeats', ->
  expect 5
  Ember.run ->
    equal(part.get('duration'), 8)

    note = part.addNoteAtPoint({x: 0, y: 0}, 1)
    instruments = part.get 'synthesizers'
    stub = sinon.stub instruments, 'invoke', -> this

    part.schedule(0, 0, 0.5)
    equal stub.callCount, 1
    ok stub.calledWith 'play', note, 0

    part.schedule(7.6, 8.0, 8.5)

    equal stub.callCount, 2
    equal (stub.lastCall.args[2] * 1e1) << 0, 4

test 'schedule: schedules notes once', ->
  expect 5
  Ember.run ->
    equal(part.get('duration'), 8)

    note = part.addNoteAtPoint({x: 0, y: 0}, 1)
    instruments = part.get 'synthesizers'
    stub = sinon.stub instruments, 'invoke', -> this

    part.schedule(0, 0, 0.5)
    equal stub.callCount, 1
    ok stub.calledWith 'play', note, 0

    part.schedule(7.6, 7.9, 8.4)
    part.schedule(8.1, 8.4, 8.9)

    equal stub.callCount, 2
    equal (stub.lastCall.args[2] * 1e1) << 0, 4

test 'schedule: schedules notes in parts with duration < BUFFER_TIME', ->
  expect 4
  Ember.run =>
    part.set 'beat_count', 1
    part.set('song.tempo', 200)
    equal part.get('duration'), 0.3

    note = part.addNoteAtPoint({x: 0, y: 0}, 1)
    instruments = part.get 'synthesizers'
    stub = sinon.stub instruments, 'invoke', -> this

    part.schedule 0, 0, 0.5
    equal stub.callCount, 2
    if stub.callCount == 2
      equal stub.firstCall.args[2], 0
      equal stub.secondCall.args[2], 0.3

moduleFor 'model:part', 'Part reload', needs: [
  'model:note'
  'model:song'
  'model:synthesizer'
  'model:midiInstrument'
],
setup: (container)->
  stubAudio container
  store = configureTestStore container

test 'when loaded from local storage muting mutes its synthesizers', ->
  localStorage.setItem 'seq25test', JSON.stringify
    part:
      records:
        p:
          id: 'p'
          synthesizers: ['syn']
    synthesizer:
      records:
        syn:
          id: 'syn'
          volume: 0.1
          part: 'p'

  store.find('part', 'p')
  .then (part)->
    output = part.get('synthesizers.firstObject.output')
    stub = sinon.stub output, 'disconnect'
    part.toggle()
    equal output.gain.value, 0.1
    equal stub.callCount, 1
