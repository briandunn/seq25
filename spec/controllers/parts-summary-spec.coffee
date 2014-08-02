subject = null

moduleFor "controller:parts_summary", "Parts Summary Controller",
  needs: ['controller:transport'],
  setup: ->
    subject = @subject notes: []
    subject.set('bucketCount', 4)

test 'groups an even count evenly', ->
  notes = [
    {pitchNumber: 1},
    {pitchNumber: 2},
    {pitchNumber: 3},
    {pitchNumber: 4}
  ]
  subject.set 'notes', notes.map((n)-> Ember.Object.create(n))
  pitches = subject.get('pitches')
  equal pitches.length, 4
  pitches.reverse().forEach (notes, i)->
    equal notes.length, 1
    equal notes[0].get('pitchNumber'), i + 1

test 'condenses a broader range', ->
  notes = [
    {pitchNumber: 2},
    {pitchNumber: 4},
    {pitchNumber: 6},
    {pitchNumber: 8}
  ]
  subject.set 'notes', notes.map((n)-> Ember.Object.create(n))
  pitches = subject.get('pitches')
  pitches.reverse().forEach (notes, i)->
    equal notes.length, 1
    equal notes[0].get('pitchNumber'), (i + 1) * 2
