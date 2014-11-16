moduleFor 'controller:selectionBox', 'selection box controller', needs: 'controller:part'

test 'when not additive the boxed notes are the selection', ->
  controller = @subject()
  controller.get('boxed').pushObject 1
  controller.send 'resized'
  deepEqual controller.get('selected'), [1]
  controller.get('boxed').setObjects [2]
  controller.send 'resized'
  deepEqual controller.get('selected'), [2]

test 'when additive the boxed notes are appended to the selection', ->
  controller = @subject isAdditive: true
  controller.get('boxed').setObjects [1]
  controller.send 'resized'
  controller.get('boxed').setObjects [2]
  controller.send 'resized'
  deepEqual controller.get('selected'), [1, 2]

test 'when additive the boxed notes toggle the selection', ->
  controller = @subject isAdditive: true
  controller.get('boxed').setObjects [1]
  controller.send 'resized'
  controller.get('boxed').setObjects [1]
  controller.send 'resized'
  deepEqual controller.get('selected'), []

test 'when additive the boxed notes are toggled durring box resizing', ->
  controller = @subject isAdditive: true
  controller.get('boxed').setObjects [1]
  controller.send 'resized'
  controller.get('boxed').setObjects [1]
  deepEqual controller.get('selected'), []
  controller.get('boxed').setObjects [0]
  controller.send 'resized'
  deepEqual controller.get('selected'), [1,0]

test 'toggle selects only a group', ->
  controller = @subject()
  controller.send 'toggle', [1]
  controller.send 'toggle', [2, 3]
  deepEqual controller.get('selected'), [2, 3]

test 'additive toggle adds a group', ->
  controller = @subject()
  controller.send 'toggle', [1]
  controller.send 'toggle', [2, 3], isAdditive: true
  deepEqual controller.get('selected'), [1, 2, 3]
