import { module, test } from 'qunit';
import { setupApplicationTest } from 'seq25/tests/helpers';
import {
  setupBackend,
  setupStorage,
  startPart,
  press,
  left,
} from 'seq25/tests/helpers/seq25';

module('Feature: User changes quant', function (hooks) {
  setupApplicationTest(hooks);
  setupStorage(hooks);
  setupBackend(hooks);
  hooks.beforeEach(startPart);

  test('change quant with keyboard', async function (assert) {
    await press('2, x');
    await press('c');
    assert.strictEqual(left(), '0%');
    await press('2, 0, b');
    assert.strictEqual(left(), '0%');
    await press('right');
    assert.strictEqual(left(), '2.5%');
  });
});
