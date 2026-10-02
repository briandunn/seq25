import { test, moduleForModel } from "ember-qunit";
import Note from "seq25/models/note";

moduleForModel('note', 'Note Model', {
needs: [
  'model:midiInstrument',
  'model:part',
  'model:song',
  'model:synthesizer'
]
});

test('create record with position and beatCount', function() {
  const note = this.subject({beatCount: 16, position: {x: 0.5, y: 0}});
  equal(note.get('beat'), 8);
  return equal(note.get('tick'), 0);
});

test('create record with position, beatCount, and quant', function() {
  const note = this.subject({beatCount: 1, position: {x: 0.75, y: 0}, quant: 2});
  equal(note.get('beat'), 0);
  return equal(note.get('tick'), 48);
});

test('set absoluteTicks', function() {
  const note = this.subject({absoluteTicks: Note.TICKS_PER_BEAT + 20});
  equal(note.get('beat'), 1);
  equal(note.get('tick'), 20);

  Ember.run(() => note.set('absoluteTicks', 0));

  equal(note.get('beat'), 0);
  return equal(note.get('tick'), 0);
});

test('get absoluteTicks', function() {
  const note = this.subject({beat: 1, tick: 20});
  return equal(note.get('absoluteTicks'), Note.TICKS_PER_BEAT + 20);
});

test('nudgeLeft', function() {
  const note = this.subject({beat: 1, tick: 20});
  const quant = 1;
  const beatCount = 16;

  Ember.run(() => note.nudgeLeft(quant));

  equal(note.get('beat'), 1);
  equal(note.get('tick'), 0);

  Ember.run(() => note.nudgeLeft(quant));

  equal(note.get('beat'), 0);
  return equal(note.get('tick'), 0);
});
