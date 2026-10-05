import { module, test } from 'qunit';
import { setupApplicationTest } from 'seq25/tests/helpers';
import {
  setupBackend,
  setupStorage,
  startPart,
  press,
  styles,
  width,
} from 'seq25/tests/helpers/seq25';

module('Feature: user changes beats', function (hooks) {
  setupApplicationTest(hooks);
  setupStorage(hooks);
  setupBackend(hooks);
  hooks.beforeEach(startPart);

  const measureWidth = () => styles('.measure')['width'];

  test('change beats with keyboard', async function (assert) {
    assert.strictEqual(measureWidth(), '6.25%');
    await press('2, 0, b');
    assert.strictEqual(measureWidth(), '5%');
  });

  test('change beats with keyboard should change note width', async function (assert) {
    await press('c');
    assert.strictEqual(width(), '6.25%');
    await press('2, 0, b');
    assert.strictEqual(width(), '5%');
  });
});
