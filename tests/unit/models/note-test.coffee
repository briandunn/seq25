`import { test, moduleForModel } from "ember-qunit"`
`import Note from "seq25/models/note"`

moduleForModel 'note', 'Note Model',
needs: [
  'model:midiInstrument',
  'model:part',
  'model:song',
  'model:synthesizer'
]

test 'create record with position and beatCount', ->
  note = @subject beatCount: 16, position: {x: 0.5, y: 0}
  equal note.get('beat'), 8
  equal note.get('tick'), 0

test 'create record with position, beatCount, and quant', ->
  note = @subject beatCount: 1, position: {x: 0.75, y: 0}, quant: 2
  equal note.get('beat'), 0
  equal note.get('tick'), 48

test 'set absoluteTicks', ->
  note = @subject absoluteTicks: Note.TICKS_PER_BEAT + 20
  equal note.get('beat'), 1
  equal note.get('tick'), 20

  Ember.run ->
    note.set 'absoluteTicks', 0

  equal note.get('beat'), 0
  equal note.get('tick'), 0

test 'get absoluteTicks', ->
  note = @subject beat: 1, tick: 20
  equal note.get('absoluteTicks'), Note.TICKS_PER_BEAT + 20

test 'nudgeLeft', ->
  note = @subject beat: 1, tick: 20
  quant = 1
  beatCount = 16

  Ember.run -> note.nudgeLeft(quant)

  equal note.get('beat'), 1
  equal note.get('tick'), 0

  Ember.run -> note.nudgeLeft(quant)

  equal note.get('beat'), 0
  equal note.get('tick'), 0
