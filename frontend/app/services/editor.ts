import Service, { service } from '@ember/service';
import { tracked } from '@glimmer/tracking';
import Note, { TICKS_PER_BEAT, type Position } from 'seq25/models/note';
import SelectionBox from 'seq25/lib/selection-box';
import type Part from 'seq25/models/part';
import type SongsService from 'seq25/services/songs';
import type TransportService from 'seq25/services/transport';

type NoteFields = Pick<Note, 'pitchNumber' | 'absoluteTicks' | 'duration'>;

/** Note editing on the current part: the old part and selection controllers. */
export default class EditorService extends Service {
  @service declare songs: SongsService;
  @service declare transport: TransportService;

  /** Grid divisions per beat; 0 means unquantized. */
  @tracked quant = 1;
  @tracked showHelp = false;
  readonly selection = new SelectionBox<Note>();

  get part(): Part | undefined {
    return this.transport.currentPart;
  }

  get selectedNotes(): Note[] {
    return this.selection.selected;
  }

  /** Ticks per quant step (one tick when unquantized). */
  get editResolution(): number {
    const quant = Math.trunc(this.quant) || TICKS_PER_BEAT;
    return (1 / quant) * TICKS_PER_BEAT;
  }

  /** Starts editing a part with nothing selected. */
  editPart(part: Part | undefined): void {
    this.transport.currentPart = part;
    this.selection.clear();
    this.selection.source = part;
  }

  private edited(): void {
    this.songs.scheduleSave();
  }

  addNote(position: Position): void {
    const { part } = this;
    if (!part) return;
    const note = part.addNoteAtPoint(position, this.quant);
    this.selection.toggle([note]);
    this.edited();
  }

  createNote(): void {
    this.addNote({ x: 0, y: 0 });
  }

  removeNotes(): void {
    const notes = this.selectedNotes;
    notes.forEach((note) => note.part?.removeNote(note));
    this.selection.remove(notes);
    this.edited();
  }

  private addAdjacentNotes(
    count: number,
    place: (note: NoteFields, count: number, distance: number) => NoteFields,
  ): void {
    const { part } = this;
    const notes = this.selectedNotes;
    if (!part || !notes.length) return;
    // Notes of one length step by that length, mixed lengths by the quant.
    const firstLength = notes[0]!.duration;
    const distance = notes.every((n) => n.duration === firstLength)
      ? firstLength
      : this.editResolution;
    const added = notes.map((note) => {
      const { pitchNumber, absoluteTicks, duration } = place(
        note,
        count,
        distance,
      );
      return part.addNote(pitchNumber, absoluteTicks, duration);
    });
    this.selection.toggle(added);
    this.edited();
  }

  addNoteLeft(count: number): void {
    this.addAdjacentNotes(count, (n, c, distance) => ({
      ...fields(n),
      absoluteTicks: n.absoluteTicks - distance * c,
    }));
  }

  addNoteRight(count: number): void {
    this.addAdjacentNotes(count, (n, c, distance) => ({
      ...fields(n),
      absoluteTicks: n.absoluteTicks + distance * c,
    }));
  }

  addNoteUp(count: number): void {
    this.addAdjacentNotes(count, (n, c) => ({
      ...fields(n),
      pitchNumber: n.pitchNumber + c,
    }));
  }

  addNoteDown(count: number): void {
    this.addAdjacentNotes(count, (n, c) => ({
      ...fields(n),
      pitchNumber: n.pitchNumber - c,
    }));
  }

  private each(fn: (note: Note) => void): void {
    this.selectedNotes.forEach(fn);
    this.edited();
  }

  extendNotes(count: number): void {
    this.each((n) => n.changeDuration(this.editResolution * count));
  }

  shortenNotes(count: number): void {
    this.each((n) => n.changeDuration(-this.editResolution * count));
  }

  nudgeLeft(count: number): void {
    for (let i = 0; i < count; i++) this.each((n) => n.nudgeLeft(this.quant));
  }

  nudgeRight(count: number): void {
    for (let i = 0; i < count; i++) this.each((n) => n.nudgeRight(this.quant));
  }

  moveUp(count: number): void {
    this.each((n) => n.moveUp(count));
  }

  moveDown(count: number): void {
    this.each((n) => n.moveDown(count));
  }

  setVelocity(count: number): void {
    this.each((n) => (n.velocity = Math.min(count / 10, 1)));
  }

  incrementQuant(): void {
    this.quant += 1;
  }

  setQuant(quant: number): void {
    this.quant = quant;
  }
}

function fields(note: NoteFields): NoteFields {
  const { pitchNumber, absoluteTicks, duration } = note;
  return { pitchNumber, absoluteTicks, duration };
}

declare module '@ember/service' {
  interface Registry {
    editor: EditorService;
  }
}
