part = store = null
moduleForModel 'part', 'Part', needs: [
  'model:note'
  'model:song'
],
setup: ->
  part = @subject()
  store = @store()
  Ember.run ->
    part.set 'song', store.createRecord('song')

test 'schedule: schedules all notes again when the loop repeats', ->
  expect 5
  Ember.run =>
    equal(part.get('duration'), 8)

    note = part.addNoteAtPoint(0, 0, 1)
    stub = sinon.stub note, 'schedule', -> this

    part.schedule(0, 0, 0.5)
    equal stub.callCount, 1
    ok stub.calledWith 0

    scheduled = part.schedule(7.6, 8.0, 8.5)

    equal stub.callCount, 2
    equal (stub.lastCall.args[0] * 1e1) << 0, 4

test 'schedule: schedules notes in parts with duration < BUFFER_TIME', ->
  expect 4
  Ember.run =>
    part.set 'beat_count', 1
    part.set('song.tempo', 200)
    equal part.get('duration'), 0.3

    note = part.addNoteAtPoint(0, 0, 1)
    stub = sinon.stub note, 'schedule', -> this

    part.schedule 0, 0, 0.5
    equal stub.callCount, 2
    if stub.callCount == 2
      equal stub.firstCall.args[0], 0
      equal stub.secondCall.args[0], 0.3
