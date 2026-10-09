import { tracked } from '@glimmer/tracking';
import Part, { type PartAttrs } from 'seq25/models/part';
import generateId from 'seq25/models/id';
import type Note from 'seq25/models/note';
import type { AudioProvider } from 'seq25/models/audio';

export interface SongAttrs {
  id?: string;
  remoteId?: number | null;
  tempo?: number;
}

export default class Song {
  readonly id: string;
  private readonly audio: AudioProvider;

  @tracked remoteId: number | null;
  @tracked tempo: number;
  @tracked parts: Part[] = [];

  constructor(audio: AudioProvider, attrs: SongAttrs = {}) {
    this.audio = audio;
    this.id = attrs.id ?? generateId();
    this.remoteId = attrs.remoteId ?? null;
    this.tempo = attrs.tempo ?? 120;
  }

  get secondsPerBeat(): number {
    return 60 / this.tempo;
  }

  get notes(): Note[] {
    return this.parts.flatMap((part) => part.notes);
  }

  getPart(name: string): Part | undefined {
    return this.parts.find((part) => part.name === name);
  }

  addPart(attrs: PartAttrs): Part {
    const part = new Part(this, this.audio, attrs);
    this.parts = [...this.parts, part];
    return part;
  }

  removePart(part: Part): void {
    part.stop();
    this.parts = this.parts.filter((p) => p !== part);
  }

  schedule(now: number, from: number, to: number): void {
    this.parts.forEach((part) => part.schedule(now, from, to));
  }

  stop(): void {
    this.parts.forEach((part) => part.stop());
  }
}
