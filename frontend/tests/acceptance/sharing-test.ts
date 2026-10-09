import { module, test } from 'qunit';
import { setupApplicationTest } from 'seq25/tests/helpers';
import { click, currentURL, visit } from '@ember/test-helpers';
import {
  setupBackend,
  setupStorage,
  startPart,
  press,
  storedSongs,
} from 'seq25/tests/helpers/seq25';

interface Stored {
  song: {
    records: Record<string, { remoteId: number | null; parts: unknown[] }>;
  };
}

module('Acceptance: sharing songs', function (hooks) {
  setupApplicationTest(hooks);
  setupStorage(hooks);
  const backend = setupBackend(hooks);

  test('lists shared songs', async function (assert) {
    backend.routes['GET /songs'] = () => [{ id: '4' }, { id: '9' }];
    await visit('/');
    assert.dom('#songs li:not(.song) a').exists({ count: 2 });
    assert.dom('#songs li:not(.song) a').hasText('4');
  });

  test('opening a shared song copies it locally', async function (assert) {
    backend.routes['GET /songs/7'] = () => ({
      tempo: 100,
      parts: [{ name: 'E', notes: [{ pitchNumber: 60 }], synthesizers: [{}] }],
    });
    await visit('/7');
    const records = (storedSongs() as Stored).song.records;
    const [id] = Object.keys(records);
    assert.strictEqual(currentURL(), `/${id}`, 'redirected to the local copy');
    assert.strictEqual(records[id!]!.remoteId, 7);
    assert.dom('#parts li.part').exists({ count: 1 });
    assert.dom('#tempo').hasValue('100');
  });

  test('an unknown song shows an error', async function (assert) {
    await visit('/nope');
    assert.dom('section.controls h2').hasText('Song not found');
  });

  test('sharing posts the song and shows its permalink', async function (assert) {
    backend.routes['POST /songs'] = () => ({ id: '12' });
    await startPart();
    await press('c');
    await click('section.controls > button');
    const post = backend.requests.find((r) => r.method === 'POST');
    assert.strictEqual(
      (post?.body as { parts: { notes: unknown[] }[] }).parts[0]!.notes.length,
      1,
    );
    assert.dom('#permalink').hasValue(`${location.origin}/12`);
    const records = (storedSongs() as Stored).song.records;
    assert.strictEqual(Object.values(records)[0]!.remoteId, 12);
  });
});
