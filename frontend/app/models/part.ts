import { tracked } from '@glimmer/tracking';
import Note, { TICKS_PER_BEAT, type Position } from 'seq25/models/note';
import Synthesizer, { type SynthesizerAttrs } from 'seq25/models/synthesizer';
import MidiInstrument, {
  type MidiInstrumentAttrs,
} from 'seq25/models/midi-instrument';
import generateId from 'seq25/models/id';
import type Pitch from 'seq25/models/pitch';
import type Song from 'seq25/models/song';
import type { AudioProvider } from 'seq25/models/audio';

export const PART_NAMES = ['Q', 'W', 'E', 'R', 'A', 'S', 'D', 'F'] as const;

export interface PartAttrs {
  id?: string;
  name: string;
  volume?: number;
  beatCount?: number;
  isMuted?: boolean;
}

export default class Part {
  readonly id: string;
  song: Song;
  private readonly audio: AudioProvider;

  @tracked name: string;
  @tracked volume: number;
  @tracked beatCount: number;
  @tracked notes: Note[] = [];
  @tracked synthesizers: Synthesizer[] = [];
  @tracked midiInstruments: MidiInstrument[] = [];
  @tracked private _isMuted: boolean;

  constructor(song: Song, audio: AudioProvider, attrs: PartAttrs) {
    this.song = song;
    this.audio = audio;
    this.id = attrs.id ?? generateId();
    this.name = attrs.name;
    this.volume = attrs.volume ?? 0.75;
    this.beatCount = attrs.beatCount ?? 16;
    this._isMuted = attrs.isMuted ?? false;
  }

  get isMuted(): boolean {
    return this._isMuted;
  }
  set isMuted(value: boolean) {
    this._isMuted = value;
    this.synthesizers.forEach((s) => s.applyMute());
  }

  get secondsPerBeat(): number {
    return this.song.secondsPerBeat;
  }

  get totalTicks(): number {
    return TICKS_PER_BEAT * this.beatCount;
  }

  /** Loop length in seconds. */
  get duration(): number {
    return this.secondsPerBeat * this.beatCount;
  }

  private get instruments(): (Synthesizer | MidiInstrument)[] {
    return [...this.midiInstruments, ...this.synthesizers];
  }

  toggle(): void {
    this.isMuted = !this.isMuted;
  }

  /**
   * Queues every note that starts in [from, to), in transport seconds, with
   * the part looping. `now` is the transport time the offsets are from.
   */
  schedule(now: number, from: number, to: number): void {
    const { duration } = this;
    if (!(duration > 0)) return;
    const loopOffset = Math.floor(from / duration) * duration;
    for (const note of this.notes) {
      for (
        let start = loopOffset + note.absoluteSeconds;
        start < to;
        start += duration
      ) {
        if (start >= from) {
          this.instruments.forEach((i) => i.playNote(note, start - now));
        }
      }
    }
  }

  playPitch(pitch: Pitch): void {
    this.instruments.forEach((i) => i.playPitch(pitch));
  }

  stop(pitch?: Pitch): void {
    this.instruments.forEach((i) => i.stop(pitch));
  }

  addNoteAtPoint(position: Position, quant: number): Note {
    const note = Note.atPosition(this, position, this.beatCount, quant);
    this.notes = [...this.notes, note];
    return note;
  }

  addNote(pitchNumber: number, ticks: number, duration: number): Note {
    const note = new Note(this, { pitchNumber, duration });
    note.absoluteTicks = ticks;
    this.notes = [...this.notes, note];
    return note;
  }

  removeNote(note: Note): void {
    this.notes = this.notes.filter((n) => n !== note);
  }

  restoreNote(note: Note): void {
    note.part = this;
    this.notes = [...this.notes, note];
  }

  addSynthesizer(attrs?: SynthesizerAttrs): Synthesizer {
    const synthesizer = new Synthesizer(this, this.audio, attrs);
    this.synthesizers = [...this.synthesizers, synthesizer];
    return synthesizer;
  }

  addMidiInstrument(attrs?: MidiInstrumentAttrs): MidiInstrument {
    const instrument = new MidiInstrument(this, attrs);
    this.midiInstruments = [...this.midiInstruments, instrument];
    return instrument;
  }

  removeInstrument(instrument: Synthesizer | MidiInstrument): void {
    instrument.stop();
    this.synthesizers = this.synthesizers.filter((i) => i !== instrument);
    this.midiInstruments = this.midiInstruments.filter((i) => i !== instrument);
  }

  bumpVolume(direction: 'up' | 'down', multiplier = 1): void {
    const amount = 0.1 * multiplier;
    this.volume += direction === 'down' ? -amount : amount;
  }
}
