import Component from '@glimmer/component';
import { style, percent } from 'seq25/lib/styles';
import type Note from 'seq25/models/note';

interface Signature {
  Args: { notes: Note[] };
}

/** A thumbnail of notes, scaled to fill the box with their pitch range. */
export default class NotesSummary extends Component<Signature> {
  get min(): number {
    return Math.min(...this.args.notes.map((n) => n.pitchNumber));
  }

  get range(): number {
    const max = Math.max(...this.args.notes.map((n) => n.pitchNumber));
    return max - this.min + 1;
  }

  noteStyle = (note: Note) => {
    const { range } = this;
    const height = 1 / range;
    const adjusted = note.pitchNumber - this.min;
    return style(
      ['left', percent(note.absoluteTicks / note.totalTicks)],
      ['width', percent(note.duration / note.totalTicks)],
      ['top', percent(1 - adjusted / range - height)],
      ['height', percent(height)],
      ['opacity', note.velocity],
    );
  };

  <template>
    <ul class="notes">
      {{#each @notes as |note|}}
        <li class={{note.part.name}} style={{this.noteStyle note}}></li>
      {{/each}}
    </ul>
  </template>
}
