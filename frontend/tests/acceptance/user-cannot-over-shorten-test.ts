import { module, test } from 'qunit';
import { setupApplicationTest } from 'seq25/tests/helpers';
import {
  setupBackend,
  setupStorage,
  startPart,
  press,
  left,
  width,
} from 'seq25/tests/helpers/seq25';

module('Feature: user note actions must be constrained', function (hooks) {
  setupApplicationTest(hooks);
  setupStorage(hooks);
  setupBackend(hooks);
  hooks.beforeEach(startPart);

  test('cannot shorten note to 0', async function (assert) {
    await press('c');
    assert.strictEqual(width(), '6.25%');
    await press('shift+left');
    assert.strictEqual(width(), '6.25%');
  });

  test('cannot move note to < 0', async function (assert) {
    await press('c');
    assert.strictEqual(left(), '0%');
    await press('left');
    assert.strictEqual(left(), '0%');
  });
});
