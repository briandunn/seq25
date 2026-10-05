import { module, test } from 'qunit';
import { setupRenderingTest } from 'seq25/tests/helpers';
import { render, triggerEvent } from '@ember/test-helpers';
import PianoKey from 'seq25/components/piano-key';
import Pitch from 'seq25/models/pitch';

module('component:piano-key', function (hooks) {
  setupRenderingTest(hooks);

  const sharp = Pitch.byNumber(61)!; // C#4

  test('looks like its pitch', async function (assert) {
    const part = { playPitch() {}, stop() {} };
    await render(
      <template><PianoKey @part={{part}} @pitch={{sharp}} /></template>,
    );
    assert.dom('li').hasClass('sharp');
    assert.dom('li').hasText('C#4');
  });

  test('plays on click', async function (assert) {
    const actions: string[] = [];
    const part = {
      playPitch(p: Pitch) {
        assert.strictEqual(p, sharp);
        actions.push('play');
      },
      stop(p?: Pitch) {
        assert.strictEqual(p, sharp);
        actions.push('stop');
      },
    };
    await render(
      <template><PianoKey @part={{part}} @pitch={{sharp}} /></template>,
    );
    await triggerEvent('li', 'mousedown');
    await triggerEvent('li', 'mouseup');
    await triggerEvent('li', 'mouseleave');
    assert.deepEqual(actions, ['play', 'stop', 'stop']);
  });
});
