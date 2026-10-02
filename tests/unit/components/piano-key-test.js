import { test, moduleForComponent } from 'ember-qunit';

moduleForComponent('piano-key', {
  // Specify the other units that are required for this test
  // needs: ['component:foo', 'helper:bar']
});

test('looks like its pitch', function(assert) {
  assert.expect(4);

  const pitch = {isSharp: true, name: 'C#'};

  // Creates the component instance
  const component = this.subject({pitch});
  assert.equal(component._state, 'preRender');

  // Renders the component to the page
  this.render();
  assert.equal(component._state, 'inDOM');
  assert.ok(component.element.classList.contains('sharp'));
  return assert.equal(component.element.innerText, 'C#');
});

test('plays on click', function(assert) {
  assert.expect(4);

  const pitch = {isSharp: true, name: 'C#'};
  const actions = [];
  const part = {
    stop(p){
      assert.equal(p, pitch);
      return actions.push('stop');
    },
    play(p){
      assert.equal(p, pitch);
      return actions.push('play');
    }
  };

  // Creates the component instance
  const component = this.subject({pitch, part});

  component.mouseDown();
  component.mouseUp();
  component.mouseLeave();

  return assert.deepEqual(actions, ['play', 'stop', 'stop']);
});
