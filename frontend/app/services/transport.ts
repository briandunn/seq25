import Service, { service } from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { registerDestructor } from '@ember/destroyable';
import type Owner from '@ember/owner';
import type Song from 'seq25/models/song';
import type Part from 'seq25/models/part';
import type AudioService from 'seq25/services/audio';

/** Seconds of notes queued ahead of the play position. */
const BUFFER_TIME = 0.5;
const PROGRESS_INTERVAL = 50;

export default class TransportService extends Service {
  @service declare audio: AudioService;

  @tracked song: Song | undefined;
  /** The part being edited, when on a part's route. */
  @tracked currentPart: Part | undefined;
  @tracked isPlaying = false;
  /** Seconds since play started. */
  @tracked progress = 0;

  private startedAt = 0;
  private scheduledUntil = 0;
  private timer: ReturnType<typeof setTimeout> | undefined;

  constructor(owner: Owner) {
    super(owner);
    registerDestructor(this, () => clearTimeout(this.timer));
  }

  get tempo(): number {
    return this.song?.tempo ?? 120;
  }

  get beat(): number {
    return Math.floor((this.progress * this.tempo) / 60);
  }

  /** Switches songs, stopping playback of the old one. */
  setSong(song: Song | undefined): void {
    if (song !== this.song) {
      this.stop();
      this.song = song;
    }
  }

  toggle(): void {
    if (this.isPlaying) {
      this.stop();
    } else {
      this.play();
    }
  }

  play(): void {
    const { song } = this;
    if (!song) return;
    this.audio.resume();
    this.startedAt = this.audio.currentTime;
    this.isPlaying = true;
    this.scheduledUntil = BUFFER_TIME;
    song.schedule(this.progress, this.progress, this.scheduledUntil);
    this.timer = setTimeout(() => this.advance(), PROGRESS_INTERVAL);
  }

  private advance(): void {
    const { song } = this;
    if (!this.isPlaying || !song) return;
    this.progress = this.audio.currentTime - this.startedAt;
    if (this.progress + BUFFER_TIME > this.scheduledUntil) {
      const end = this.scheduledUntil + BUFFER_TIME;
      song.schedule(this.progress, this.scheduledUntil, end);
      this.scheduledUntil = end;
    }
    this.timer = setTimeout(() => this.advance(), PROGRESS_INTERVAL);
  }

  stop(): void {
    clearTimeout(this.timer);
    this.song?.stop();
    this.scheduledUntil = 0;
    this.startedAt = 0;
    this.progress = 0;
    this.isPlaying = false;
  }

  setMuteForAll(isMuted: boolean): void {
    this.song?.parts.forEach((part) => (part.isMuted = isMuted));
  }
}

declare module '@ember/service' {
  interface Registry {
    transport: TransportService;
  }
}
