/**
 * Two wire formats, both inherited from the old ember-data app and kept
 * byte-compatible:
 *
 * - localStorage: what DS.LSAdapter wrote under the `seq25` key, songs with
 *   parts, notes and instruments embedded, every record with its id and a
 *   back-reference to its parent. Writing the same shape means no migration
 *   and the old app could still read it.
 * - remote: what the old RemoteSerializer POSTed to the backend. No ids or
 *   back-references, and hasMany keys underscored (`midi_instruments`). The
 *   backend dedupes songs by comparing the JSON text, so key order matters.
 */
import Note from 'seq25/models/note';
import Song from 'seq25/models/song';
import { SHAPES, type Shape } from 'seq25/models/synthesizer';
import type Part from 'seq25/models/part';
import type { AudioProvider } from 'seq25/models/audio';

type Json = Record<string, unknown>;

export interface StoredNote {
  id: string;
  pitchNumber: number;
  beat: number;
  tick: number;
  velocity: number;
  duration: number;
  part: string;
}

export interface StoredSynthesizer {
  id: string;
  shape: string;
  attack: number;
  release: number;
  filterFreq: number;
  filterQ: number;
  volume: number;
  part: string;
}

export interface StoredMidiInstrument {
  id: string;
  channel: number;
  volume: number;
  part: string;
}

export interface StoredPart {
  id: string;
  name: string;
  volume: number;
  beatCount: number;
  isMuted: boolean;
  notes: StoredNote[];
  synthesizers: StoredSynthesizer[];
  midiInstruments: StoredMidiInstrument[];
  song: string;
}

export interface StoredSong {
  id: string;
  remoteId: number | null;
  tempo: number;
  parts: StoredPart[];
}

export interface StoredDatabase {
  song: { records: Record<string, StoredSong> };
}

// ---------------------------------------------------------------- reading

function isObject(value: unknown): value is Json {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

function objects(value: unknown): Json[] {
  return Array.isArray(value) ? value.filter(isObject) : [];
}

function num(value: unknown): number | undefined {
  if (value === null || value === undefined || value === '') return undefined;
  const n = Number(value);
  return Number.isFinite(n) ? n : undefined;
}

function str(value: unknown): string | undefined {
  return typeof value === 'string' && value !== '' ? value : undefined;
}

function bool(value: unknown): boolean | undefined {
  return typeof value === 'boolean' ? value : undefined;
}

function shape(value: unknown): Shape | undefined {
  return SHAPES.find((s) => s === value);
}

interface ReadOptions {
  /** Keep stored ids (localStorage) or mint new ones (remote imports). */
  keepIds: boolean;
}

function readPart(song: Song, json: Json, { keepIds }: ReadOptions): void {
  const name = str(json['name']);
  if (!name) return;
  const id = keepIds ? str(json['id']) : undefined;
  const part = song.addPart({
    id,
    name,
    volume: num(json['volume']),
    // Songs saved before the beatCount rename (3c3d81e) used beat_count.
    beatCount: num(json['beatCount'] ?? json['beat_count']),
    isMuted: bool(json['isMuted']),
  });

  part.notes = objects(json['notes']).map(
    (note) =>
      new Note(part, {
        id: keepIds ? str(note['id']) : undefined,
        pitchNumber: num(note['pitchNumber']),
        beat: num(note['beat']),
        tick: num(note['tick']),
        velocity: num(note['velocity']),
        duration: num(note['duration']),
      }),
  );

  for (const synth of objects(json['synthesizers'])) {
    part.addSynthesizer({
      id: keepIds ? str(synth['id']) : undefined,
      shape: shape(synth['shape']),
      attack: num(synth['attack']),
      release: num(synth['release']),
      filterFreq: num(synth['filterFreq']),
      filterQ: num(synth['filterQ']),
      volume: num(synth['volume']),
    });
  }

  // The remote format underscores this key; the old client looked for the
  // camelCase one and so silently dropped MIDI instruments on import.
  const midi = json['midiInstruments'] ?? json['midi_instruments'];
  for (const instrument of objects(midi)) {
    part.addMidiInstrument({
      id: keepIds ? str(instrument['id']) : undefined,
      channel: num(instrument['channel']),
      volume: num(instrument['volume']),
    });
  }
}

export function readSong(
  json: Json,
  audio: AudioProvider,
  options: ReadOptions,
): Song {
  const song = new Song(audio, {
    id: options.keepIds ? str(json['id']) : undefined,
    remoteId: num(json['remoteId']) ?? null,
    tempo: num(json['tempo']),
  });
  for (const part of objects(json['parts'])) readPart(song, part, options);
  return song;
}

/** Songs from the stored database, in stored order. Bad input yields []. */
export function readDatabase(raw: string | null, audio: AudioProvider): Song[] {
  if (!raw) return [];
  let db: unknown;
  try {
    db = JSON.parse(raw);
  } catch {
    return [];
  }
  const songTable = isObject(db) ? db['song'] : undefined;
  const records = isObject(songTable) ? songTable['records'] : undefined;
  if (!isObject(records)) return [];
  return Object.entries(records)
    .filter((entry): entry is [string, Json] => isObject(entry[1]))
    .map(([id, json]) =>
      readSong({ ...json, id: json['id'] ?? id }, audio, { keepIds: true }),
    );
}

// ---------------------------------------------------------------- writing

function storedPart(part: Part, songId: string): StoredPart {
  return {
    id: part.id,
    name: part.name,
    volume: part.volume,
    beatCount: part.beatCount,
    isMuted: part.isMuted,
    notes: part.notes.map((note) => ({
      id: note.id,
      pitchNumber: note.pitchNumber,
      beat: note.beat,
      tick: note.tick,
      velocity: note.velocity,
      duration: note.duration,
      part: part.id,
    })),
    synthesizers: part.synthesizers.map((synth) => ({
      id: synth.id,
      shape: synth.shape,
      attack: synth.attack,
      release: synth.release,
      filterFreq: synth.filterFreq,
      filterQ: synth.filterQ,
      volume: synth.volume,
      part: part.id,
    })),
    midiInstruments: part.midiInstruments.map((instrument) => ({
      id: instrument.id,
      channel: instrument.channel,
      volume: instrument.volume,
      part: part.id,
    })),
    song: songId,
  };
}

function storedSong(song: Song): StoredSong {
  return {
    id: song.id,
    remoteId: song.remoteId,
    tempo: song.tempo,
    parts: song.parts.map((part) => storedPart(part, song.id)),
  };
}

/**
 * The database with `songs` written into it and `removedIds` deleted. Like
 * the old per-record adapter, records it doesn't know about (another tab's
 * songs, say) are left as they are.
 */
export function writeDatabase(
  songs: Song[],
  existing: string | null = null,
  removedIds: Iterable<string> = [],
): StoredDatabase {
  let records: Record<string, unknown> = {};
  try {
    const db: unknown = existing ? JSON.parse(existing) : null;
    const table = isObject(db) ? db['song'] : undefined;
    if (isObject(table) && isObject(table['records'])) {
      records = { ...table['records'] };
    }
  } catch {
    // Unreadable data is replaced.
  }
  for (const id of removedIds) delete records[id];
  for (const song of songs) records[song.id] = storedSong(song);
  return { song: { records: records as Record<string, StoredSong> } };
}

/** The document POSTed to the backend, in the old serializer's key order. */
export function remotePayload(song: Song): Json {
  return {
    remoteId: song.remoteId,
    tempo: song.tempo,
    parts: song.parts.map((part) => ({
      name: part.name,
      volume: part.volume,
      beatCount: part.beatCount,
      isMuted: part.isMuted,
      notes: part.notes.map((note) => ({
        pitchNumber: note.pitchNumber,
        beat: note.beat,
        tick: note.tick,
        velocity: note.velocity,
        duration: note.duration,
      })),
      synthesizers: part.synthesizers.map((synth) => ({
        shape: synth.shape,
        attack: synth.attack,
        release: synth.release,
        filterFreq: synth.filterFreq,
        filterQ: synth.filterQ,
        volume: synth.volume,
      })),
      midi_instruments: part.midiInstruments.map((instrument) => ({
        channel: instrument.channel,
        volume: instrument.volume,
      })),
    })),
  };
}
