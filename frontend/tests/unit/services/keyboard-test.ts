import { module, test } from 'qunit';
import { setupTest } from 'seq25/tests/helpers';
import { keyCombo } from 'seq25/services/keyboard';

const key = (key: string, mods: KeyboardEventInit = {}) =>
  new KeyboardEvent('keydown', { key, ...mods });

module('Unit | Service | keyboard', function (hooks) {
  setupTest(hooks);

  test('names key combos the way the bindings do', function (assert) {
    assert.strictEqual(keyCombo(key('c')), 'c');
    assert.strictEqual(keyCombo(key('C', { shiftKey: true })), 'shift+c');
    assert.strictEqual(keyCombo(key('?', { shiftKey: true })), 'shift+?');
    assert.strictEqual(
      keyCombo(key('ArrowLeft', { shiftKey: true, ctrlKey: true })),
      'ctrl+shift+left',
    );
    assert.strictEqual(keyCombo(key(' ')), 'space');
    assert.strictEqual(keyCombo(key('Shift', { shiftKey: true })), undefined);
  });

  test('passes the typed count and part letter to the handler', function (assert) {
    const keyboard = this.owner.lookup('service:keyboard');
    const calls: [number, string][] = [];
    const unregister = keyboard.register({
      b: (count, part) => void calls.push([count, part]),
    });
    for (const k of ['2', '0', 'w', 'b', 'b']) keyboard.handle(key(k));
    unregister();
    keyboard.handle(key('b'));
    assert.deepEqual(calls, [
      [20, 'W'],
      [1, ''],
    ]);
  });

  test('ignores typing in form fields', function (assert) {
    const keyboard = this.owner.lookup('service:keyboard');
    let called = false;
    const unregister = keyboard.register({ c: () => void (called = true) });
    const input = document.createElement('input');
    document.body.append(input);
    input.dispatchEvent(
      new KeyboardEvent('keydown', { key: 'c', bubbles: true }),
    );
    input.remove();
    unregister();
    assert.false(called);
  });
});
