moduleForModel 'part', 'Part', needs: [
  'model:note'
  'model:song'
]

test 'schedules all notes again when the loop repeats', ->
  expect 5
  part = @subject()
  store = @store()

  Ember.run =>
    part.set 'song', store.createRecord('song')
    equal(part.get('duration'), 8)

    note = part.addNoteAtPoint(0, 0, 1)
    sinon.stub note, 'schedule', -> this

    scheduled = part.schedule(0, 0, 0.5)

    equal scheduled.length, 1
    equal scheduled.get('firstObject'), note

    scheduled = part.schedule(7.6, 8.0, 8.5)

    equal scheduled.length, 1
    equal scheduled.get('firstObject'), note
