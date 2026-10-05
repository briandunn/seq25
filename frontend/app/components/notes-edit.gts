import Component from '@glimmer/component';
import { service } from '@ember/service';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import { noteStyle } from 'seq25/lib/styles';
import scrollIntoView from 'seq25/modifiers/scroll-into-view';
import type Note from 'seq25/models/note';
import type { Position } from 'seq25/models/note';
import type Part from 'seq25/models/part';
import type EditorService from 'seq25/services/editor';

/** Pixels the mouse must move before a press becomes a box drag. */
const DRAG_THRESHOLD = 10;

function relativePoint(element: Element, event: MouseEvent): Position {
  const rect = element.getBoundingClientRect();
  return {
    x: (event.clientX - rect.left) / rect.width,
    y: (event.clientY - rect.top) / rect.height,
  };
}

interface Signature {
  Args: { part: Part };
}

/**
 * The editable notes. Click empty grid to add a note, drag to box-select
 * (shift to toggle into the selection), click a note to select it.
 */
export default class NotesEdit extends Component<Signature> {
  @service declare editor: EditorService;

  private press:
    { corner: Position; x: number; y: number; shift: boolean } | undefined;
  private isDragging = false;

  get selection() {
    return this.editor.selection;
  }

  down = (event: MouseEvent) => {
    event.stopPropagation();
    this.press = {
      corner: relativePoint(event.currentTarget as Element, event),
      x: event.clientX,
      y: event.clientY,
      shift: event.shiftKey,
    };
  };

  move = (event: MouseEvent) => {
    const { press } = this;
    if (!press) return;
    event.stopPropagation();
    const distance = Math.hypot(
      event.clientX - press.x,
      event.clientY - press.y,
    );
    if (!this.isDragging && distance <= DRAG_THRESHOLD) return;
    this.isDragging = true;
    this.selection.resize(
      [press.corner, relativePoint(event.currentTarget as Element, event)],
      press.shift,
    );
  };

  up = (event: MouseEvent) => {
    event.stopPropagation();
    this.press = undefined;
    if (this.isDragging) {
      this.selection.resized();
      this.isDragging = false;
    } else {
      this.editor.addNote(relativePoint(event.currentTarget as Element, event));
    }
  };

  stop = (event: Event) => event.stopPropagation();

  select = (note: Note, event: MouseEvent) => {
    event.stopPropagation();
    this.selection.toggle([note], { isAdditive: event.shiftKey });
  };

  isSelected = (note: Note) => this.selection.isSelected(note);

  <template>
    {{! A drag starts on press, so these need mousedown. }}
    {{! template-lint-disable no-invalid-interactive no-pointer-down-event-binding }}
    <ul
      class="notes"
      {{on "mousedown" this.down}}
      {{on "mousemove" this.move}}
      {{on "mouseup" this.up}}
    >
      {{#each @part.notes as |note|}}
        <li
          class={{if (this.isSelected note) "selected"}}
          style={{noteStyle note}}
          {{scrollIntoView note.pitchNumber}}
          {{on "mousedown" this.stop}}
          {{on "mouseup" this.stop}}
          {{on "click" (fn this.select note)}}
        ></li>
      {{/each}}
    </ul>
  </template>
}
