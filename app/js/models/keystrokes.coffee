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

eventCombo = (keyCode, isShiftPressed) ->
  char = eventChar(keyCode)
  char = "shift+#{char}" if isShiftPressed
  char

class Seq25.Keystrokes
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
    keyStroke = eventChar(e.which)
    @executeCallback(keyStroke)

  @executeCallback = (keyStroke) =>
    Seq25.numStack.push(keyStroke) if /\d/.test(keyStroke)
    @callbacks[keyStroke]?.call(null, Seq25.numStack.drain())

  @handleKeyDown = (e) =>
    result = @executeKeyDownCallback(eventCombo(e.keyCode, e.shiftKey))
    e.preventDefault() if result

  @executeKeyDownCallback = (keyStroke) =>
    @keyDownCallbacks[keyStroke]?.call(null, Seq25.numStack.drain())

  document.addEventListener('keypress', @handleKeyPress, false)
  document.addEventListener('keydown', @handleKeyDown, false)

class Seq25.NumStack
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

Seq25.numStack = new Seq25.NumStack()
