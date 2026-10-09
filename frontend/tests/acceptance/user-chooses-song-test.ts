import { module, test } from 'qunit';
import { setupApplicationTest } from 'seq25/tests/helpers';
import { visit, findAll } from '@ember/test-helpers';
import {
  setupBackend,
  setupStorage,
  storeSongs,
} from 'seq25/tests/helpers/seq25';
import legacySong from 'seq25/tests/fixtures/legacy-beat-count.json';

module('chooses song', function (hooks) {
  setupApplicationTest(hooks);
  setupStorage(hooks);
  setupBackend(hooks);

  test('see song preview', async function (assert) {
    storeSongs(legacySong);
    await visit('/');
    assert.strictEqual(findAll('#songs .song ul.notes li.Q').length, 8);
  });
});
