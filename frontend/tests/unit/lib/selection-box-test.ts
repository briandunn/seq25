import { module, test } from 'qunit';
import SelectionBox, { type Boxable } from 'seq25/lib/selection-box';

// The old controller tests used plain numbers as stand-in notes.
const box = () => new SelectionBox<Boxable & number>();
const n = (x: number) => x as Boxable & number;

module('selection box controller', function () {
  test('when not additive the boxed notes are the selection', function (assert) {
    const selection = box();
    selection.boxed = [n(1)];
    selection.resized();
    assert.deepEqual(selection.selected, [1]);
    selection.boxed = [n(2)];
    selection.resized();
    assert.deepEqual(selection.selected, [2]);
  });

  test('when additive the boxed notes are appended to the selection', function (assert) {
    const selection = box();
    selection.isAdditive = true;
    selection.boxed = [n(1)];
    selection.resized();
    selection.boxed = [n(2)];
    selection.resized();
    assert.deepEqual(selection.selected, [1, 2]);
  });

  test('when additive the boxed notes toggle the selection', function (assert) {
    const selection = box();
    selection.isAdditive = true;
    selection.boxed = [n(1)];
    selection.resized();
    selection.boxed = [n(1)];
    selection.resized();
    assert.deepEqual(selection.selected, []);
  });

  test('when additive the boxed notes are toggled durring box resizing', function (assert) {
    const selection = box();
    selection.isAdditive = true;
    selection.boxed = [n(1)];
    selection.resized();
    selection.boxed = [n(1)];
    assert.deepEqual(selection.selected, []);
    selection.boxed = [n(0)];
    selection.resized();
    assert.deepEqual(selection.selected, [1, 0]);
  });

  test('toggle selects only a group', function (assert) {
    const selection = box();
    selection.toggle([n(1)]);
    selection.toggle([n(2), n(3)]);
    assert.deepEqual(selection.selected, [2, 3]);
  });

  test('additive toggle adds a group', function (assert) {
    const selection = box();
    selection.toggle([n(1)]);
    selection.toggle([n(2), n(3)], { isAdditive: true });
    assert.deepEqual(selection.selected, [1, 2, 3]);
  });

  test('a dragged box selects the notes it touches', function (assert) {
    const low = { pitchNumber: 21, absoluteTicks: 0, duration: 96 };
    const high = { pitchNumber: 108, absoluteTicks: 0, duration: 96 };
    const selection = new SelectionBox();
    selection.source = { notes: [low, high], totalTicks: 1536 };
    // From the bottom-left corner upward, and the other way round.
    selection.resize(
      [
        { x: 0.01, y: 0.999 },
        { x: 0.05, y: 0.5 },
      ],
      false,
    );
    assert.deepEqual(selection.selected, [low]);
    selection.resize(
      [
        { x: 0.05, y: 0.5 },
        { x: 0.01, y: 0.999 },
      ],
      false,
    );
    assert.deepEqual(selection.selected, [low]);
  });
});
