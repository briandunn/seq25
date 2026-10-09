import { module, test } from 'qunit';
import { setupApplicationTest } from 'seq25/tests/helpers';
import {
  setupBackend,
  setupStorage,
  startPart,
  press,
  clickAt,
  note,
  left,
  width,
  top,
  notesCount,
  selectedCount,
} from 'seq25/tests/helpers/seq25';

module('Feature: user creates part with movement', function (hooks) {
  setupApplicationTest(hooks);
  setupStorage(hooks);
  setupBackend(hooks);
  hooks.beforeEach(startPart);

  test('add new note left from selected note has same length and is placed at end', async function (assert) {
    await press('c, right, right, shift+right');
    assert.strictEqual(notesCount(), 1);
    assert.strictEqual(left(1), '12.5%');
    await press('ctrl+shift+left');
    assert.strictEqual(notesCount(), 2);
    assert.strictEqual(left(1), '12.5%');
    assert.strictEqual(left(2), '0%');
    assert.strictEqual(width(1), '12.5%');
    assert.strictEqual(width(2), '12.5%');
  });

  test('add new note up', async function (assert) {
    await press('c, down, shift+right');
    assert.strictEqual(notesCount(), 1);
    assert.strictEqual(left(1), '0%');
    await press('ctrl+shift+up');
    assert.strictEqual(notesCount(), 2);
    assert.strictEqual(left(1), '0%');
    assert.strictEqual(left(2), '0%');
    assert.notStrictEqual(top(1), top(2));
    assert.strictEqual(width(1), '12.5%');
    assert.strictEqual(width(2), '12.5%');
  });

  test('add new note down', async function (assert) {
    await press('c, shift+right');
    assert.strictEqual(notesCount(), 1);
    assert.strictEqual(left(1), '0%');
    await press('ctrl+shift+down');
    assert.strictEqual(notesCount(), 2);
    assert.strictEqual(left(1), '0%');
    assert.strictEqual(left(2), '0%');
    assert.notStrictEqual(top(1), top(2));
    assert.strictEqual(width(1), '12.5%');
    assert.strictEqual(width(2), '12.5%');
  });

  test('new note right from selected note has same length and is placed at end', async function (assert) {
    await press('c, shift+right');
    assert.strictEqual(notesCount(), 1);
    await press('ctrl+shift+right');
    assert.strictEqual(notesCount(), 2);
    assert.strictEqual(left(1), '0%');
    assert.strictEqual(left(2), '12.5%');
    assert.strictEqual(width(1), '12.5%');
    assert.strictEqual(width(2), '12.5%');
  });

  test('new note right from selected note is x * duration away from note', async function (assert) {
    await press('c, shift+right');
    assert.strictEqual(notesCount(), 1);
    await press('2, ctrl+shift+right');
    assert.strictEqual(notesCount(), 2);
    assert.strictEqual(left(1), '0%');
    assert.strictEqual(left(2), '25%');
    assert.strictEqual(width(1), '12.5%');
    assert.strictEqual(width(2), '12.5%');
  });

  test('add new note left from selected note is x * duration in front of note', async function (assert) {
    await press('c, 4, right, shift+right');
    assert.strictEqual(notesCount(), 1);
    assert.strictEqual(left(1), '25%');
    await press('2, ctrl+shift+left');
    assert.strictEqual(notesCount(), 2);
    assert.strictEqual(left(1), '25%');
    assert.strictEqual(left(2), '0%');
    assert.strictEqual(width(1), '12.5%');
    assert.strictEqual(width(2), '12.5%');
  });

  test('if multiple notes selected are different lengths, move by quant', async function (assert) {
    await press('c, down, shift+right');
    await press('c');
    assert.strictEqual(notesCount(), 2);
    await clickAt(note(1), { shiftKey: true });
    assert.strictEqual(selectedCount(), 2);
    await press('ctrl+shift+right');
    assert.strictEqual(notesCount(), 4);
    assert.strictEqual(left(1), '0%');
    assert.strictEqual(left(2), '0%');
    assert.strictEqual(left(3), '6.25%');
    assert.strictEqual(left(4), '6.25%');
  });

  test('two moves makes two more notes', async function (assert) {
    await press('c, ctrl+shift+right, ctrl+shift+right');
    assert.strictEqual(notesCount(), 3);
  });
});
