import { htmlSafe, type SafeString } from '@ember/template';
import Pitch from 'seq25/models/pitch';
import type Note from 'seq25/models/note';

export function percent(fraction: number): string {
  return `${fraction * 100}%`;
}

/** "left: 0%; width: 6.25%; ..." from ordered [property, value] pairs. */
export function style(
  ...declarations: [string, string | number][]
): SafeString {
  return htmlSafe(declarations.map(([k, v]) => `${k}: ${v};`).join(' '));
}

/** Where a note sits on the piano-roll grid. */
export function noteStyle(note: Note): SafeString {
  const { totalTicks } = note;
  return style(
    ['left', percent(note.absoluteTicks / totalTicks)],
    ['width', percent(note.duration / totalTicks)],
    ['top', `calc(${percent(Pitch.scaleAtPitch(note.pitch))} + 3px)`],
    ['opacity', note.velocity],
  );
}
