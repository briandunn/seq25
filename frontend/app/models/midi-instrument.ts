import { tracked } from '@glimmer/tracking';
import Midi from 'seq25/lib/midi';
import Pitch from 'seq25/models/pitch';
import generateId from 'seq25/models/id';
import type Note from 'seq25/models/note';
import type Part from 'seq25/models/part';

export interface MidiInstrumentAttrs {
  id?: string;
  channel?: number;
  volume?: number;
}

function logFailure(error: unknown): void {
  console.log('midi connection failure', error);
}

export default class MidiInstrument {
  readonly id: string;
  part: Part;

  @tracked channel: number;
  @tracked volume: number;

  constructor(part: Part, attrs: MidiInstrumentAttrs = {}) {
    this.part = part;
    this.id = attrs.id ?? generateId();
    this.channel = attrs.channel ?? 1;
    this.volume = attrs.volume ?? 0.75;
  }

  get isMuted(): boolean {
    return this.part.isMuted;
  }

  playNote(note: Note, start: number): void {
    if (this.isMuted || !note.pitch) return;
    const pitch = note.pitch.number;
    const { velocity, durationSeconds } = note;
    const { volume, channel } = this;
    Midi.connect()
      .then((midi) =>
        midi.play(pitch, velocity * volume, channel, start, durationSeconds),
      )
      .catch(logFailure);
  }

  playPitch(pitch: Pitch): void {
    if (this.isMuted) return;
    const { volume, channel } = this;
    Midi.connect()
      .then((midi) => midi.play(pitch.number, volume, channel))
      .catch(logFailure);
  }

  stop(pitch?: Pitch): void {
    const { channel } = this;
    Midi.connect()
      .then((midi) => {
        if (pitch) {
          midi.stop(pitch.number, channel);
        } else {
          Pitch.all.forEach((p) => midi.stop(p.number, channel));
        }
      })
      .catch(logFailure);
  }
}
