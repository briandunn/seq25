`import { test, moduleForComponent } from 'ember-qunit'`

moduleForComponent 'piano-key', {
  # Specify the other units that are required for this test
  # needs: ['component:foo', 'helper:bar']
}

test 'looks like its pitch', (assert) ->
  assert.expect 4

  pitch = isSharp: true, name: 'C#'

  # Creates the component instance
  component = @subject(pitch: pitch)
  assert.equal component._state, 'preRender'

  # Renders the component to the page
  @render()
  assert.equal component._state, 'inDOM'
  assert.ok component.element.classList.contains('sharp')
  assert.equal component.element.innerText, 'C#'

test 'plays on click', (assert) ->
  assert.expect 4

  pitch = isSharp: true, name: 'C#'
  actions = []
  part =
    stop: (p)->
      assert.equal(p, pitch)
      actions.push 'stop'
    play: (p)->
      assert.equal(p, pitch)
      actions.push 'play'

  # Creates the component instance
  component = @subject pitch: pitch, part: part

  component.mouseDown()
  component.mouseUp()
  component.mouseLeave()

  assert.deepEqual actions, ['play', 'stop', 'stop']
