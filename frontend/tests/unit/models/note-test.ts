import { module, test } from 'qunit';
import Note, { TICKS_PER_BEAT } from 'seq25/models/note';

module('Note Model', function () {
  test('create record with position and beatCount', function (assert) {
    const note = Note.atPosition(undefined, { x: 0.5, y: 0 }, 16, 0);
    assert.strictEqual(note.beat, 8);
    assert.strictEqual(note.tick, 0);
  });

  test('create record with position, beatCount, and quant', function (assert) {
    const note = Note.atPosition(undefined, { x: 0.75, y: 0 }, 1, 2);
    assert.strictEqual(note.beat, 0);
    assert.strictEqual(note.tick, 48);
  });

  test('set absoluteTicks', function (assert) {
    const note = new Note(undefined);
    note.absoluteTicks = TICKS_PER_BEAT + 20;
    assert.strictEqual(note.beat, 1);
    assert.strictEqual(note.tick, 20);
    note.absoluteTicks = 0;
    assert.strictEqual(note.beat, 0);
    assert.strictEqual(note.tick, 0);
  });

  test('get absoluteTicks', function (assert) {
    const note = new Note(undefined, { beat: 1, tick: 20 });
    assert.strictEqual(note.absoluteTicks, TICKS_PER_BEAT + 20);
  });

  test('nudgeLeft', function (assert) {
    const note = new Note(undefined, { beat: 1, tick: 20 });
    note.nudgeLeft(1);
    assert.strictEqual(note.beat, 1);
    assert.strictEqual(note.tick, 0);
    note.nudgeLeft(1);
    assert.strictEqual(note.beat, 0);
    assert.strictEqual(note.tick, 0);
  });
});
