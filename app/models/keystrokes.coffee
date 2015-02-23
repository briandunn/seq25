_MAP =
  8: 'backspace',
  32: 'space',
  37: 'left',
  38: 'up',
  39: 'right',
  40: 'down',

eventChar = (keyCode) ->
  val = if (_MAP[keyCode])
    _MAP[keyCode]
  else
    String.fromCharCode(keyCode).toLowerCase()
  return val

eventCombo = (keyCode, isShiftPressed, isCtrlPressed) ->
  char = eventChar(keyCode)
  char = "shift+#{char}" if isShiftPressed
  char = "ctrl+#{char}" if isCtrlPressed
  char
class NumStack
  stack: []

  push: (num) ->
    @stack.push(num)

  drain: () ->
    if @stack.length is 0
      num = 1
    else
      num = parseInt(@stack.join(''))
    @stack = []
    num

numStack = new NumStack()

class PartStack
  stack: ''

  push: (parkKey) ->
    @stack = parkKey

  drain: () ->
    part = @stack.toUpperCase()
    @stack = ''
    part

partStack = new PartStack()

class Keystrokes
  @callbacks = {}
  @keyDownCallbacks = {}
  @bind: (key, callback) ->
    @callbacks[key] = callback

  @keyDownBind: (key, callback) ->
    @keyDownCallbacks[key] = callback

  @trigger: (key) ->
    @executeCallback(key) ||
      @executeKeyDownCallback(key)

  @handleKeyPress = (e) =>
    keyStroke = eventCombo(e.which, e.shiftKey, e.ctrlKey)
    @executeCallback(keyStroke)

  @registerKeyPressEvents = (keyPressEvents) ->
    for k, v of keyPressEvents
      @bind k, v

  @registerKeyDownEvents = (keyDownEvents) ->
    for k, v of keyDownEvents
      @keyDownBind k, v

  @executeCallback = (keyStroke) =>
    numStack.push(keyStroke) if /\d/.test(keyStroke)
    partStack.push(keyStroke) if /[qwerasdf]/.test(keyStroke)
    @callbacks[keyStroke]?.call(null, numStack.drain(), @getPart())

  @handleKeyDown = (e) =>
    keyStroke = eventCombo(e.which, e.shiftKey, e.ctrlKey)
    result = @executeKeyDownCallback(keyStroke)
    e.preventDefault() if result

  @executeKeyDownCallback = (keyStroke) =>
    @keyDownCallbacks[keyStroke]?.call(null, numStack.drain(), @getPart())

  @getPart =  => @partfn(partStack.drain())

  document.addEventListener('keypress', @handleKeyPress, false)
  document.addEventListener('keydown', @handleKeyDown, false)

`export default Keystrokes`
