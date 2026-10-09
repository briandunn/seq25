import { module, test } from 'qunit';
import { setupApplicationTest } from 'seq25/tests/helpers';
import { find } from '@ember/test-helpers';
import {
  setupBackend,
  setupStorage,
  startPart,
  clickAt,
  note,
  notesCount,
  selectedCount,
} from 'seq25/tests/helpers/seq25';

module('Feature: selects notes', function (hooks) {
  setupApplicationTest(hooks);
  setupStorage(hooks);
  setupBackend(hooks);
  hooks.beforeEach(startPart);

  const isSelected = (n: number) =>
    find(note(n))?.classList.contains('selected');

  test('selected note changes color', async function (assert) {
    await clickAt('#grid .notes');
    assert.strictEqual(selectedCount(), 1);
    await clickAt(note(1));
    assert.strictEqual(
      selectedCount(),
      1,
      'clicking the only selected note keeps it selected',
    );
    await clickAt(note(1));
    assert.strictEqual(selectedCount(), 1);
  });

  test('clicking the next note selects it only', async function (assert) {
    await clickAt('#grid .notes');
    await clickAt('#grid .notes', { x: 100, y: 100 });
    assert.strictEqual(notesCount(), 2);
    await clickAt(note(1));
    assert.true(isSelected(1));
    assert.false(isSelected(2));
    await clickAt(note(2));
    assert.false(isSelected(1));
    assert.true(isSelected(2));
  });

  test('shift+clicking the next note selects it too', async function (assert) {
    await clickAt('#grid .notes');
    await clickAt('#grid .notes', { x: 100, y: 100 });
    await clickAt(note(1), { shiftKey: true });
    assert.strictEqual(notesCount(), 2);
    assert.true(isSelected(1));
    assert.true(isSelected(2));
  });
});
