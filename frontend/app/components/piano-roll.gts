import Component from '@glimmer/component';
import { service } from '@ember/service';
import { registerDestructor } from '@ember/destroyable';
import { htmlSafe } from '@ember/template';
import Pitch from 'seq25/models/pitch';
import PlayBar from 'seq25/components/play-bar';
import SeqMeasure from 'seq25/components/seq-measure';
import NotesEdit from 'seq25/components/notes-edit';
import PianoKey from 'seq25/components/piano-key';
import type Owner from '@ember/owner';
import type Part from 'seq25/models/part';
import type EditorService from 'seq25/services/editor';
import type KeyboardService from 'seq25/services/keyboard';

interface Signature {
  Args: { part: Part };
}

/** The part editor: grid, notes, keyboard, and the note commands. */
export default class PianoRoll extends Component<Signature> {
  @service declare editor: EditorService;
  @service declare keyboard: KeyboardService;

  pitches = Pitch.all;

  constructor(owner: Owner, args: Signature['Args']) {
    super(owner, args);
    const e = this.editor;
    const unregister = this.keyboard.register({
      c: () => e.createNote(),
      backspace: () => (e.removeNotes(), true),
      'shift+right': (n) => e.extendNotes(n),
      'shift+left': (n) => e.shortenNotes(n),
      left: (n) => e.nudgeLeft(n),
      right: (n) => e.nudgeRight(n),
      up: (n) => (e.moveUp(n), true),
      down: (n) => (e.moveDown(n), true),
      'ctrl+shift+right': (n) => e.addNoteRight(n),
      'ctrl+shift+left': (n) => e.addNoteLeft(n),
      'ctrl+shift+up': (n) => e.addNoteUp(n),
      'ctrl+shift+down': (n) => e.addNoteDown(n),
      v: (n) => e.setVelocity(n),
    });
    registerDestructor(this, unregister);
  }

  get beats(): number[] {
    return Array.from({ length: this.args.part.beatCount }, (_, i) => i + 1);
  }

  get boxStyle() {
    const [a, b] = this.editor.selection.corners;
    const box = {
      height: Math.abs(a.y - b.y),
      top: Math.min(a.y, b.y),
      width: Math.abs(a.x - b.x),
      left: Math.min(a.x, b.x),
    };
    return htmlSafe(
      Object.entries(box)
        .map(([key, value]) => `${key}: ${value * 100}%`)
        .join(';'),
    );
  }

  <template>
    <section id="piano-roll">
      <section id="grid">
        <PlayBar @part={{@part}} />
        <ul class="measures">
          {{#each this.beats}}
            <SeqMeasure @beatCount={{@part.beatCount}} />
          {{/each}}
        </ul>
        <div id="selection-box" style={{this.boxStyle}}></div>
        <NotesEdit @part={{@part}} />
        <ul>
          {{#each this.pitches as |pitch|}}
            <li class="row {{if pitch.isSharp 'sharp'}}"></li>
          {{/each}}
        </ul>
      </section>
      <ul id="keyboard">
        {{#each this.pitches as |pitch|}}
          <PianoKey @part={{@part}} @pitch={{pitch}} />
        {{/each}}
      </ul>
    </section>
  </template>
}
