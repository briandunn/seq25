import Service, { service } from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { registerDestructor } from '@ember/destroyable';
import config from 'seq25/config/environment';
import Song from 'seq25/models/song';
import {
  readDatabase,
  readSong,
  remotePayload,
  writeDatabase,
} from 'seq25/lib/serialization';
import { fetchRemote, sendRemote } from 'seq25/lib/remote';
import type AudioService from 'seq25/services/audio';
import type Owner from '@ember/owner';

const SAVE_DELAY = 1000;

/**
 * The songs in localStorage. Structural changes save right away, edits call
 * scheduleSave(), and everything is saved again when the page is hidden or
 * closed (all the old app ever did).
 */
export default class SongsService extends Service {
  @service declare audio: AudioService;

  @tracked all: Song[] = [];
  private removedIds = new Set<string>();
  private saveTimer: ReturnType<typeof setTimeout> | undefined;

  constructor(owner: Owner) {
    super(owner);
    this.all = readDatabase(
      this.storage?.getItem(this.key) ?? null,
      this.audio,
    );

    const flush = () => this.flush();
    const onVisibility = () => {
      if (document.visibilityState === 'hidden') this.flush();
    };
    window.addEventListener('pagehide', flush);
    window.addEventListener('beforeunload', flush);
    document.addEventListener('visibilitychange', onVisibility);
    registerDestructor(this, () => {
      clearTimeout(this.saveTimer);
      window.removeEventListener('pagehide', flush);
      window.removeEventListener('beforeunload', flush);
      document.removeEventListener('visibilitychange', onVisibility);
    });
  }

  private get key(): string {
    return config.storageKey;
  }

  private get storage(): Storage | undefined {
    try {
      return window.localStorage;
    } catch {
      return undefined;
    }
  }

  find(id: string): Song | undefined {
    return this.all.find((song) => song.id === id);
  }

  create(): Song {
    const song = new Song(this.audio);
    this.all = [...this.all, song];
    this.save();
    return song;
  }

  remove(song: Song): void {
    song.stop();
    this.all = this.all.filter((s) => s !== song);
    this.removedIds.add(song.id);
    this.save();
  }

  /** Copies a shared song into local storage. */
  async import(remoteId: string): Promise<Song> {
    const json = await fetchRemote(remoteId);
    if (typeof json !== 'object' || json === null) {
      throw new Error(`song ${remoteId} not found`);
    }
    const song = readSong(json as Record<string, unknown>, this.audio, {
      keepIds: false,
    });
    // Remember where it came from, so sharing it again records it as a new
    // version of that song.
    song.remoteId = Number(remoteId);
    this.all = [...this.all, song];
    this.save();
    return song;
  }

  async share(song: Song): Promise<number> {
    const id = await sendRemote(remotePayload(song));
    song.remoteId = id;
    this.save();
    return id;
  }

  scheduleSave(): void {
    clearTimeout(this.saveTimer);
    this.saveTimer = setTimeout(() => this.save(), SAVE_DELAY);
  }

  flush(): void {
    this.save();
  }

  save(): void {
    clearTimeout(this.saveTimer);
    this.saveTimer = undefined;
    const { storage } = this;
    if (!storage) return;
    try {
      const db = writeDatabase(
        this.all,
        storage.getItem(this.key),
        this.removedIds,
      );
      storage.setItem(this.key, JSON.stringify(db));
      this.removedIds.clear();
    } catch (error) {
      console.error('could not save songs', error);
    }
  }
}

declare module '@ember/service' {
  interface Registry {
    songs: SongsService;
  }
}
