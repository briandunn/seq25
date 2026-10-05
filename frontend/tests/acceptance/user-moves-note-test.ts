import { module, test } from 'qunit';
import { setupApplicationTest } from 'seq25/tests/helpers';
import {
  setupBackend,
  setupStorage,
  startPart,
  press,
  left,
} from 'seq25/tests/helpers/seq25';

module('Feature: user moves note', function (hooks) {
  setupApplicationTest(hooks);
  setupStorage(hooks);
  setupBackend(hooks);
  hooks.beforeEach(startPart);

  test('move note when is quant is 0', async function (assert) {
    await press('2, 0, b');
    await press('c');
    await press('0, x');
    assert.dom('input#quant').hasValue('0');
    assert.strictEqual(left(), '0%');
    await press('right');
    assert.strictEqual(left()?.slice(0, 5), '0.052');
  });
});
