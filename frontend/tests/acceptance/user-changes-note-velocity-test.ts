import { module, test } from 'qunit';
import { setupApplicationTest } from 'seq25/tests/helpers';
import {
  setupBackend,
  setupStorage,
  startPart,
  press,
  clickAt,
  styles,
} from 'seq25/tests/helpers/seq25';

module('user changes note velocity', function (hooks) {
  setupApplicationTest(hooks);
  setupStorage(hooks);
  setupBackend(hooks);
  hooks.beforeEach(startPart);

  test('user increases velocity of selected note', async function (assert) {
    await clickAt('#grid .notes');
    assert.strictEqual(styles('#grid .notes li.selected')['opacity'], '0.75');
    await press('1, 0, v');
    assert.strictEqual(styles('#grid .notes li.selected')['opacity'], '1');
  });
});
