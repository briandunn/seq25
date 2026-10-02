import Keystrokes from "seq25/models/keystrokes";

const TransportView = Ember.View.extend({
  target: Em.computed.alias('controller'),
  didInsertElement() {
    Keystrokes.partfn = n => this.partForKey.call(this, n);

    Keystrokes.registerKeyPressEvents({
      "t": () => this.gotoSummary.call(this),
      "g": (n, p) => this.gotoPart(p),
      "m": (n, p) => this.mutePart(p),
      "o": (n, p) => this.muteAllPartsExcept(p),
      "b": (n, p) => this.changeBeatsForPart(p, "up", n),
      "x": (n, p) => this.changeQuantForPart(p, n),
      "n": (n, p) => this.bumpVolumeForPart(p, "up", n),
      "shift+o": () => this.unmuteAll(),
      "shift+m": () => this.muteAll()
    });

    return Keystrokes.registerKeyDownEvents({
      "shift+n": (n, p) => this.bumpVolumeForPart(p, "down", n),
      "space":   () => {
        this.send('play');
        return true;
      }
    });
  },

  tagName: 'section',

  partForKey(name) {
    if (name) {
      return this.get('controller.song').getPart(name);
    } else {
      return this.currentPart();
    }
  },

  gotoPart(nameOrPart) {
    if (/^[QWERASDF]$/i.test(nameOrPart)) {
      return this.send('addAndGotoPart', nameOrPart.capitalize());
    } else {
      return this.send('gotoPart', nameOrPart);
    }
  },

  bumpVolumeForPart(part, direction, num) {
    if (direction == null) { direction = "up"; }
    return (typeof part.bumpVolume === 'function' ? part.bumpVolume(direction, num) : undefined);
  },

  changeBeatsForPart(part, direction, num) {
    if (direction == null) { direction = "up"; }
    if (num === 1) {
      return part.incrementProperty("beatCount", num);
    } else {
      return part.set("beatCount", num);
    }
  },

  changeQuantForPart(part, num) {
    if (num === 1) {
      return this.send('incrementQuant');
    } else {
      return this.send('setQuant', num);
    }
  },

  gotoSummary() {
    return this.get('controller').transitionToRoute('song');
  },

  currentPart() {
    return this.get('controller.currentPart');
  },

  mutePart(part) {
    if (part) {
      return (typeof part.toggle === 'function' ? part.toggle() : undefined);
    } else {
      return this.muteAll();
    }
  },

  muteAllPartsExcept(part) {
    if (part) {
      this.muteAll();
      return this.mutePart(part);
    } else {
      return this.unmuteAll();
    }
  },

  unmuteAll() {
    return this.get('controller').unmuteAll();
  },

  muteAll() {
    return this.get('controller').muteAll();
  }
});

export default TransportView;
