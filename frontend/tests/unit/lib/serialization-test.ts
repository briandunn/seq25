import { module, test } from 'qunit';
import Song from 'seq25/models/song';
import {
  readDatabase,
  readSong,
  remotePayload,
  writeDatabase,
} from 'seq25/lib/serialization';
import savedByOldApp from 'seq25/tests/fixtures/localstorage-seq25.json';
import legacyBeatCount from 'seq25/tests/fixtures/legacy-beat-count.json';
import type { AudioProvider } from 'seq25/models/audio';

const audio = { context: undefined } as unknown as AudioProvider;

module('serializer:remote', function () {
  test('creates a nested document', function (assert) {
    const song = new Song(audio, { tempo: 100 });
    const part = song.addPart({ name: 'Q' });
    part.addNote(74, 0, 96);
    part.addMidiInstrument({ channel: 2 });
    part.addSynthesizer({ attack: 0.5 });

    const payload = remotePayload(song) as {
      parts: { notes: { pitchNumber: number }[] }[];
    };
    assert.strictEqual(payload.parts[0]!.notes[0]!.pitchNumber, 74);
  });

  test('matches the old serializer byte for byte', function (assert) {
    // The backend dedupes on the JSON text, so key order and names matter.
    const [song] = readDatabase(JSON.stringify(savedByOldApp), audio);
    song!.parts[0]!.addMidiInstrument({ channel: 3, volume: 0.5 });
    assert.strictEqual(
      JSON.stringify(remotePayload(song!)),
      '{"remoteId":null,"tempo":120,"parts":[{"name":"Q","volume":0.75,' +
        '"beatCount":20,"isMuted":false,"notes":[' +
        '{"pitchNumber":108,"beat":1,"tick":0,"velocity":0.75,"duration":96},' +
        '{"pitchNumber":108,"beat":0,"tick":0,"velocity":1,"duration":192}],' +
        '"synthesizers":[{"shape":"sine","attack":0,"release":0,' +
        '"filterFreq":1,"filterQ":0,"volume":0.75}],' +
        '"midi_instruments":[{"channel":3,"volume":0.5}]}]}',
    );
  });

  test('reads a shared song, including its MIDI instruments', function (assert) {
    const song = readSong(
      {
        tempo: 90,
        parts: [
          {
            name: 'W',
            beatCount: 8,
            notes: [{ pitchNumber: 60, beat: 2, tick: 0, duration: 48 }],
            synthesizers: [{ shape: 'square' }],
            midi_instruments: [{ channel: 5, volume: 1 }],
          },
        ],
      },
      audio,
      { keepIds: false },
    );
    const part = song.getPart('W')!;
    assert.strictEqual(song.tempo, 90);
    assert.strictEqual(part.beatCount, 8);
    assert.strictEqual(part.notes[0]!.absoluteTicks, 192);
    assert.strictEqual(part.synthesizers[0]!.shape, 'square');
    assert.strictEqual(part.midiInstruments[0]!.channel, 5);
  });
});

module('Unit | localStorage format', function () {
  test('reads what the old app saved and writes it back unchanged', function (assert) {
    const songs = readDatabase(JSON.stringify(savedByOldApp), audio);
    assert.strictEqual(songs.length, 1);
    const part = songs[0]!.getPart('Q')!;
    assert.strictEqual(part.beatCount, 20);
    assert.deepEqual(
      part.notes.map((n) => [n.absoluteTicks, n.duration, n.velocity]),
      [
        [96, 96, 0.75],
        [0, 192, 1],
      ],
    );
    assert.deepEqual(writeDatabase(songs), savedByOldApp);
  });

  test('reads beat_count from songs saved before the rename', function (assert) {
    const [song] = readDatabase(JSON.stringify(legacyBeatCount), audio);
    assert.deepEqual(
      song!.parts.map((p) => [p.name, p.beatCount]),
      [
        ['Q', 16],
        ['W', 4],
        ['E', 16],
        ['R', 16],
        ['A', 20],
      ],
    );
  });

  test('leaves other records alone and deletes removed ones', function (assert) {
    const existing = JSON.stringify({
      song: { records: { other: { id: 'other' }, gone: { id: 'gone' } } },
    });
    const song = new Song(audio, { id: 'mine' });
    const db = writeDatabase([song], existing, ['gone']);
    assert.deepEqual(Object.keys(db.song.records).sort(), ['mine', 'other']);
  });

  test('treats missing or corrupt data as no songs', function (assert) {
    assert.deepEqual(readDatabase(null, audio), []);
    assert.deepEqual(readDatabase('{not json', audio), []);
    assert.deepEqual(readDatabase('{"song": 5}', audio), []);
  });
});
