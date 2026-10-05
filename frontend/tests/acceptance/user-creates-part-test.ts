import { module, test } from 'qunit';
import { setupApplicationTest } from 'seq25/tests/helpers';
import { find } from '@ember/test-helpers';
import {
  setupBackend,
  setupStorage,
  startPart,
  press,
  left,
  width,
  notesCount,
} from 'seq25/tests/helpers/seq25';

module('Acceptance: user creates part', function (hooks) {
  setupApplicationTest(hooks);
  setupStorage(hooks);
  setupBackend(hooks);
  hooks.beforeEach(startPart);

  test('add new part', function (assert) {
    assert.strictEqual(
      find('section#piano-roll #keyboard li')?.textContent?.trim(),
      'C8',
    );
  });

  test('add new note', async function (assert) {
    await press('c');
    assert.strictEqual(notesCount(), 1);
  });

  test('move note', async function (assert) {
    await press('c');
    assert.strictEqual(left(), '0%');
    await press('right');
    assert.strictEqual(left(), '6.25%');
  });

  test('extend note', async function (assert) {
    await press('c');
    assert.strictEqual(width(), '6.25%');
    await press('shift+right');
    assert.strictEqual(width(), '12.5%');
  });
});
