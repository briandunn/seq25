import { module, test } from 'qunit';
import { setupApplicationTest } from 'seq25/tests/helpers';
import { click, findAll, visit } from '@ember/test-helpers';
import {
  setupBackend,
  setupStorage,
  startPart,
  press,
} from 'seq25/tests/helpers/seq25';

module('Feature: user creates and destroys song spec', function (hooks) {
  setupApplicationTest(hooks);
  setupStorage(hooks);
  setupBackend(hooks);
  hooks.beforeEach(startPart);

  test('create song and then delete song', async function (assert) {
    await press('c');
    await visit('/');
    assert.strictEqual(findAll('li.song').length, 1);
    await click('#songs li.song .actions button:first-child');
    assert.strictEqual(findAll('li.song').length, 0);
  });
});
