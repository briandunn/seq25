const _MAP = {
  8: 'backspace',
  32: 'space',
  37: 'left',
  38: 'up',
  39: 'right',
  40: 'down',
};

const eventChar = function(keyCode) {
  const val = (_MAP[keyCode]) ?
    _MAP[keyCode]
  :
    String.fromCharCode(keyCode).toLowerCase();
  return val;
};

const eventCombo = function(keyCode, isShiftPressed, isCtrlPressed) {
  let char = eventChar(keyCode);
  if (isShiftPressed) { char = `shift+${char}`; }
  if (isCtrlPressed) { char = `ctrl+${char}`; }
  return char;
};
class NumStack {
  static initClass() {
    this.prototype.stack = [];
  }

  push(num) {
    return this.stack.push(num);
  }

  drain() {
    let num;
    if (this.stack.length === 0) {
      num = 1;
    } else {
      num = parseInt(this.stack.join(''));
    }
    this.stack = [];
    return num;
  }
}
NumStack.initClass();

const numStack = new NumStack();

class PartStack {
  static initClass() {
    this.prototype.stack = '';
  }

  push(parkKey) {
    return this.stack = parkKey;
  }

  drain() {
    const part = this.stack.toUpperCase();
    this.stack = '';
    return part;
  }
}
PartStack.initClass();

const partStack = new PartStack();

class Keystrokes {
  static initClass() {
    this.callbacks = {};
    this.keyDownCallbacks = {};
  
    this.handleKeyPress = e => {
      const keyStroke = eventCombo(e.which, e.shiftKey, e.ctrlKey);
      return this.executeCallback(keyStroke);
    };
  
    this.executeCallback = keyStroke => {
      if (/\d/.test(keyStroke)) { numStack.push(keyStroke); }
      if (/[qwerasdf]/.test(keyStroke)) { partStack.push(keyStroke); }
      return (this.callbacks[keyStroke] != null ? this.callbacks[keyStroke].call(null, numStack.drain(), this.getPart()) : undefined);
    };
  
    this.handleKeyDown = e => {
      const keyStroke = eventCombo(e.which, e.shiftKey, e.ctrlKey);
      const result = this.executeKeyDownCallback(keyStroke);
      if (result) { return e.preventDefault(); }
    };
  
    this.executeKeyDownCallback = keyStroke => {
      return (this.keyDownCallbacks[keyStroke] != null ? this.keyDownCallbacks[keyStroke].call(null, numStack.drain(), this.getPart()) : undefined);
    };
  
    this.getPart =  () => this.partfn(partStack.drain());
  
    document.addEventListener('keypress', this.handleKeyPress, false);
    document.addEventListener('keydown', this.handleKeyDown, false);
  }
  static bind(key, callback) {
    return this.callbacks[key] = callback;
  }

  static keyDownBind(key, callback) {
    return this.keyDownCallbacks[key] = callback;
  }

  static trigger(key) {
    return this.executeCallback(key) ||
      this.executeKeyDownCallback(key);
  }

  static registerKeyPressEvents(keyPressEvents) {
    return (() => {
      const result = [];
      for (var k in keyPressEvents) {
        var v = keyPressEvents[k];
        result.push(this.bind(k, v));
      }
      return result;
    })();
  }

  static registerKeyDownEvents(keyDownEvents) {
    return (() => {
      const result = [];
      for (var k in keyDownEvents) {
        var v = keyDownEvents[k];
        result.push(this.keyDownBind(k, v));
      }
      return result;
    })();
  }
}
Keystrokes.initClass();

export default Keystrokes;
