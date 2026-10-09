import { tracked } from '@glimmer/tracking';
import Osc from 'seq25/models/osc';
import generateId from 'seq25/models/id';
import type Note from 'seq25/models/note';
import type Pitch from 'seq25/models/pitch';
import type Part from 'seq25/models/part';
import type { AudioProvider } from 'seq25/models/audio';

export const SHAPES = [
  'sine',
  'square',
  'sawtooth',
  'triangle',
  'noise',
] as const;
export type Shape = (typeof SHAPES)[number];

export interface SynthesizerAttrs {
  id?: string;
  shape?: Shape;
  attack?: number;
  release?: number;
  filterFreq?: number;
  filterQ?: number;
  volume?: number;
}

export default class Synthesizer {
  readonly id: string;
  part: Part;
  private readonly audio: AudioProvider;
  private readonly oscillators = new Map<number, Osc>();
  private _output: GainNode | undefined;

  @tracked attack: number;
  @tracked release: number;
  @tracked private _shape: Shape;
  @tracked private _filterFreq: number;
  @tracked private _filterQ: number;
  @tracked private _volume: number;

  constructor(part: Part, audio: AudioProvider, attrs: SynthesizerAttrs = {}) {
    this.part = part;
    this.audio = audio;
    this.id = attrs.id ?? generateId();
    this._shape = attrs.shape ?? 'sine';
    this.attack = attrs.attack ?? 0;
    this.release = attrs.release ?? 0;
    this._filterFreq = attrs.filterFreq ?? 1;
    this._filterQ = attrs.filterQ ?? 0;
    this._volume = attrs.volume ?? 0.75;
  }

  get context(): BaseAudioContext {
    return this.audio.context;
  }

  get isMuted(): boolean {
    return this.part.isMuted;
  }

  get shape(): Shape {
    return this._shape;
  }
  set shape(shape: Shape) {
    this._shape = shape;
    this.oscillators.forEach((osc) => osc.applyShape());
  }

  get filterFreq(): number {
    return this._filterFreq;
  }
  set filterFreq(value: number) {
    this._filterFreq = value;
    this.oscillators.forEach((osc) => osc.applyFilterFreq());
  }

  get filterQ(): number {
    return this._filterQ;
  }
  set filterQ(value: number) {
    this._filterQ = value;
    this.oscillators.forEach((osc) => osc.applyFilterQ());
  }

  get volume(): number {
    return this._volume;
  }
  set volume(value: number) {
    this._volume = value;
    if (this._output) this._output.gain.value = value;
  }

  /** Reconnects or disconnects the output to follow the part's mute. */
  applyMute(): void {
    const output = this._output;
    if (!output) return;
    if (this.isMuted) {
      output.disconnect();
    } else {
      output.connect(this.context.destination);
    }
  }

  private get output(): GainNode {
    if (!this._output) {
      this._output = this.context.createGain();
      this._output.gain.value = this.volume;
      this.applyMute();
    }
    return this._output;
  }

  private oscillatorFor(pitch: Pitch): Osc {
    let osc = this.oscillators.get(pitch.number);
    if (!osc) {
      osc = new Osc(this, pitch, this.output);
      this.oscillators.set(pitch.number, osc);
    }
    return osc;
  }

  playNote(note: Note, secondsFromNow = 0): void {
    const { pitch } = note;
    if (!pitch) return;
    this.oscillatorFor(pitch).play(
      secondsFromNow,
      note.velocity,
      note.durationSeconds,
    );
  }

  /** Sounds a pitch until stop() (the piano keys). */
  playPitch(pitch: Pitch): void {
    this.oscillatorFor(pitch).play(0);
  }

  stop(pitch?: Pitch): void {
    if (pitch) {
      this.oscillators.get(pitch.number)?.stop();
    } else {
      this.oscillators.forEach((osc) => osc.stop());
    }
  }
}
