import Component from '@glimmer/component';
import { service } from '@ember/service';
import { registerDestructor } from '@ember/destroyable';
import type Owner from '@ember/owner';
import type EditorService from 'seq25/services/editor';
import type KeyboardService from 'seq25/services/keyboard';

/** The keyboard reference, toggled with "?". */
export default class HelpOverlay extends Component {
  @service declare editor: EditorService;
  @service declare keyboard: KeyboardService;

  constructor(owner: Owner, args: object) {
    super(owner, args);
    const unregister = this.keyboard.register({
      'shift+?': () => void (this.editor.showHelp = !this.editor.showHelp),
    });
    registerDestructor(this, unregister);
  }

  <template>
    {{#if this.editor.showHelp}}
      <div class="overlay">
        <div class="modal">
          {{! The part keys are laid out like the keyboard. }}
          {{! template-lint-disable no-whitespace-within-word }}
          <pre>
  HELP
  -----------------------------------------------

  ? - toggle help

  Part Commands
  -------------
  q w e r
  a s d f

  Those are the parts that can be used
  as modifiers to these commands. The
  current part is implied if no part
  is given.

  t - goto summary
  g - goto specific part
  b - change beats for specific part
  x - change quant for specific part
  n - change volume for specific part
  m - toggle mute for specified part
  o - mute every part but the specified part
  M - mute all parts
  O - unmute all parts

  Note Commands
  -------------

  Most of these commands can be prefixed
  with a number.

  c - create note
  backspace - remove selected notes
  left - move selected note left
  right - move selected note right
  up - move selected note up
  down - move selected note down

  shift+left - shorten selected note
  shift+right - extend selected note

  ctrl+shift+left - create new note to the left
  ctrl+shift+right - create new note to the right
  ctrl+shift+up - create new note up
  ctrl+shift+down - create new note down
  v - change velocity of selected notes to number
          </pre>
        </div>
      </div>
    {{/if}}
  </template>
}
