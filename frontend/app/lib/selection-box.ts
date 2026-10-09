import { tracked } from '@glimmer/tracking';
import Pitch from 'seq25/models/pitch';
import type { Position } from 'seq25/models/note';

export interface Boxable {
  pitchNumber: number;
  absoluteTicks: number;
  duration: number;
}

const EMPTY_CORNERS: [Position, Position] = [
  { x: 0, y: 0 },
  { x: 0, y: 0 },
];

/** Toggles `items` in `selected` (additive) or replaces it with them. */
function toggleInto<T>(selected: T[], items: T[], isAdditive: boolean): T[] {
  if (!isAdditive) return [...items];
  const result = [...selected];
  for (const item of items) {
    const index = result.indexOf(item);
    if (index === -1) {
      result.push(item);
    } else {
      result.splice(index, 1);
    }
  }
  return result;
}

const ascending = (a: number, b: number) => a - b;

/**
 * Note selection, plus the rubber-band box dragged over the grid. While a
 * box is open, `selected` previews what releasing it would select.
 */
export default class SelectionBox<T extends Boxable = Boxable> {
  /** Where the notes and grid length come from (the current part). */
  source: { notes: T[]; totalTicks: number } | undefined;

  @tracked private committed: T[] = [];
  @tracked boxed: T[] = [];
  @tracked corners: [Position, Position] = EMPTY_CORNERS;
  @tracked isAdditive = false;

  get selected(): T[] {
    if (!this.boxed.length) return this.committed;
    return toggleInto(this.committed, this.boxed, this.isAdditive);
  }

  get boxClosed(): boolean {
    return this.corners.every((corner) => corner.x + corner.y === 0);
  }

  isSelected(item: T): boolean {
    return this.selected.includes(item);
  }

  resize(corners: [Position, Position], isAdditive: boolean): void {
    this.corners = corners;
    this.isAdditive = isAdditive;
    if (!this.boxClosed) this.boxed = this.notesInBox();
  }

  resized(): void {
    this.committed = this.selected;
    this.boxed = [];
    this.corners = EMPTY_CORNERS;
  }

  toggle(items: T[], { isAdditive = false } = {}): void {
    this.committed = toggleInto(this.committed, items, isAdditive);
  }

  /** Drops items from the selection (e.g. deleted notes). */
  remove(items: T[]): void {
    this.committed = this.committed.filter((item) => !items.includes(item));
  }

  clear(): void {
    this.committed = [];
    this.boxed = [];
    this.corners = EMPTY_CORNERS;
  }

  private notesInBox(): T[] {
    const { notes = [], totalTicks = 0 } = this.source ?? {};
    const [lowPitch, highPitch] = this.corners
      .map((corner) => Pitch.numberAtScale(Math.max(corner.y, 0)))
      .sort(ascending) as [number, number];
    const [firstTick, lastTick] = this.corners
      .map((corner) => Math.round(corner.x * totalTicks))
      .sort(ascending) as [number, number];

    return notes.filter(
      ({ pitchNumber, absoluteTicks, duration }) =>
        lowPitch <= pitchNumber &&
        pitchNumber <= highPitch &&
        firstTick <= absoluteTicks + duration &&
        lastTick >= absoluteTicks,
    );
  }
}
