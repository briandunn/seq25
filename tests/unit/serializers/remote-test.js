import { test, moduleFor } from "ember-qunit";
import {configureTestStore, stubAudio} from "../../helpers/unit";

moduleFor('serializer:remote', {
  needs: [
    'model:midiInstrument',
    'model:note',
    'model:part',
    'model:song',
    'model:synthesizer'
  ]
});

test('creates a nested document', function() {
  return Em.run(() => {
    configureTestStore(this.container);
    stubAudio(this.container);

    const store = this.container.lookup('store:main');

    const song = store.createRecord('song', {tempo: 100});
    const part = song.get('parts').createRecord({name: 'Q'});
    part.get('notes').createRecord({pitchNumber: 74});
    part.get('midiInstruments').createRecord({channel: 2});
    part.get('synthesizers').createRecord({attack: 0.5});

    const payload = this.subject().serialize(new DS.Snapshot(song._internalModel));
    const array = payload.parts, obj = array[0], [{pitchNumber: pitch}] = Array.from(obj.notes);
    return equal(pitch, 74);
  });
});
