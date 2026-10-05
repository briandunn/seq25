import { tracked } from '@glimmer/tracking';
import Pitch from 'seq25/models/pitch';
import generateId from 'seq25/models/id';
import type Part from 'seq25/models/part';

export const TICKS_PER_BEAT = 96;

export interface NoteAttrs {
  id?: string;
  pitchNumber?: number;
  beat?: number;
  tick?: number;
  velocity?: number;
  duration?: number;
}

export interface Position {
  x: number;
  y: number;
}

type Round = (n: number) => number;

export default class Note {
  readonly id: string;
  part: Part | undefined;

  @tracked pitchNumber: number;
  @tracked beat: number;
  @tracked tick: number;
  @tracked velocity: number;
  @tracked duration: number;

  constructor(part: Part | undefined, attrs: NoteAttrs = {}) {
    this.part = part;
    this.id = attrs.id ?? generateId();
    this.pitchNumber = attrs.pitchNumber ?? 0;
    this.beat = attrs.beat ?? 0;
    this.tick = attrs.tick ?? 0;
    this.velocity = attrs.velocity ?? 0.75;
    this.duration = attrs.duration ?? TICKS_PER_BEAT;
  }

  /**
   * A note at a point on the grid (x and y from 0 to 1), snapped down to
   * the quant grid.
   */
  static atPosition(
    part: Part | undefined,
    position: Position,
    beatCount: number,
    quant: number,
  ): Note {
    const note = new Note(part, {
      pitchNumber: Pitch.numberAtScale(position.y),
    });
    note.absoluteTicks = Math.round(beatCount * TICKS_PER_BEAT * position.x);
    note.snap(quant, Math.floor);
    return note;
  }

  get absoluteTicks(): number {
    return this.beat * TICKS_PER_BEAT + this.tick;
  }

  set absoluteTicks(ticks: number) {
    this.beat = Math.floor(ticks / TICKS_PER_BEAT);
    this.tick = ticks % TICKS_PER_BEAT;
  }

  get pitch(): Pitch | undefined {
    return Pitch.byNumber(this.pitchNumber);
  }

  get secondsPerBeat(): number {
    return this.part?.secondsPerBeat ?? 0;
  }

  get totalTicks(): number {
    return this.part?.totalTicks ?? 0;
  }

  get absoluteSeconds(): number {
    return this.ticksToTime(this.absoluteTicks);
  }

  get durationSeconds(): number {
    return this.ticksToTime(this.duration);
  }

  ticksToTime(ticks: number): number {
    return (ticks / TICKS_PER_BEAT) * this.secondsPerBeat;
  }

  /** Moves the note onto the quant grid. Returns true if it moved. */
  snap(quant: number, round: Round): boolean {
    if (!(quant > 0)) return false;
    const ticksPerGrid = (1 / quant) * TICKS_PER_BEAT;
    const snapped = round(this.absoluteTicks / ticksPerGrid) * ticksPerGrid;
    if (snapped !== this.absoluteTicks) {
      this.absoluteTicks = snapped;
      return true;
    }
    return false;
  }

  nudge(quant: number, round: Round, direction: 1 | -1): void {
    if (this.snap(quant, round)) return;
    const ticksPerGrid = (1 / (quant || TICKS_PER_BEAT)) * TICKS_PER_BEAT;
    const newTicks = this.absoluteTicks + ticksPerGrid * direction;
    if (this.totalTicks >= newTicks && newTicks >= 0) {
      this.absoluteTicks = newTicks;
    }
  }

  nudgeLeft(quant: number): void {
    this.nudge(quant, Math.floor, -1);
  }

  nudgeRight(quant: number): void {
    this.nudge(quant, Math.ceil, 1);
  }

  moveUp(num: number): void {
    this.pitchNumber = Pitch.highest(this.pitchNumber + num);
  }

  moveDown(num: number): void {
    this.pitchNumber = Pitch.lowest(this.pitchNumber - num);
  }

  changeDuration(editResolution: number): void {
    if (this.duration + editResolution > 0) {
      this.duration += editResolution;
    }
  }
}
