import { module, test } from 'qunit';
import { setupRenderingTest } from 'seq25/tests/helpers';
import { render } from '@ember/test-helpers';
import SeqMeasure from 'seq25/components/seq-measure';

module('component:seq-measure', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function (assert) {
    await render(<template><SeqMeasure @beatCount={{16}} /></template>);
    assert.dom('li.measure').hasAttribute('style', 'width: 6.25%');
  });
});
