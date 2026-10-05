import Component from '@glimmer/component';
import { service } from '@ember/service';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import RangeInput from 'seq25/components/range-input';
import NumberInput from 'seq25/components/number-input';
import { SHAPES, type Shape } from 'seq25/models/synthesizer';
import type Part from 'seq25/models/part';
import type Synthesizer from 'seq25/models/synthesizer';
import type MidiInstrument from 'seq25/models/midi-instrument';
import type SongsService from 'seq25/services/songs';

interface Signature {
  Args: { part: Part };
}

type Instrument = Synthesizer | MidiInstrument;

const eq = (a: unknown, b: unknown) => a === b;

/** The part's synthesizers and MIDI outputs, with their settings. */
export default class Instruments extends Component<Signature> {
  @service declare songs: SongsService;

  shapes = SHAPES;

  setSynth = (
    synth: Synthesizer,
    key: 'volume' | 'attack' | 'release' | 'filterQ' | 'filterFreq',
    value: number,
  ) => {
    synth[key] = value;
    this.songs.scheduleSave();
  };

  setMidi = (
    midi: MidiInstrument,
    key: 'channel' | 'volume',
    value: number,
  ) => {
    midi[key] = value;
    this.songs.scheduleSave();
  };

  setShape = (synth: Synthesizer, event: Event) => {
    synth.shape = (event.target as HTMLSelectElement).value as Shape;
    this.songs.scheduleSave();
  };

  addSynthesizer = () => {
    this.args.part.addSynthesizer();
    this.songs.save();
  };

  addMidiInstrument = () => {
    this.args.part.addMidiInstrument();
    this.songs.save();
  };

  remove = (instrument: Instrument) => {
    this.args.part.removeInstrument(instrument);
    this.songs.save();
  };

  <template>
    {{#each @part.synthesizers as |synth|}}
      <article class="instrument">
        <dl>
          <dt><label>v</label></dt>
          <dd><RangeInput
              @value={{synth.volume}}
              @onChange={{fn this.setSynth synth "volume"}}
            /></dd>
          <dt><label>a</label></dt>
          <dd><RangeInput
              @value={{synth.attack}}
              @onChange={{fn this.setSynth synth "attack"}}
            /></dd>
          <dt><label>r</label></dt>
          <dd><RangeInput
              @value={{synth.release}}
              @onChange={{fn this.setSynth synth "release"}}
            /></dd>
        </dl>
        <dl>
          <dt><label>q</label></dt>
          <dd><RangeInput
              @value={{synth.filterQ}}
              @onChange={{fn this.setSynth synth "filterQ"}}
            /></dd>
          <dt><label>f</label></dt>
          <dd><RangeInput
              @value={{synth.filterFreq}}
              @onChange={{fn this.setSynth synth "filterFreq"}}
            /></dd>
          <dt><label for="shape">shape</label></dt>
          <dd>
            <select id="shape" {{on "change" (fn this.setShape synth)}}>
              {{#each this.shapes as |shape|}}
                <option
                  value={{shape}}
                  selected={{eq shape synth.shape}}
                >{{shape}}</option>
              {{/each}}
            </select>
          </dd>
        </dl>
        <button type="button" {{on "click" (fn this.remove synth)}}>-</button>
      </article>
    {{/each}}
    <button type="button" {{on "click" this.addSynthesizer}}>+ synth</button>
    {{#each @part.midiInstruments as |midi|}}
      <article class="instrument">
        <dl>
          <dt><label for="channel">channel</label></dt>
          <dd>
            <NumberInput
              id="channel"
              @min={{1}}
              @max={{16}}
              @value={{midi.channel}}
              @onChange={{fn this.setMidi midi "channel"}}
            />
          </dd>
          <dt><label for="volume">v</label></dt>
          <dd><RangeInput
              @value={{midi.volume}}
              @onChange={{fn this.setMidi midi "volume"}}
            /></dd>
        </dl>
        <button type="button" {{on "click" (fn this.remove midi)}}>-</button>
      </article>
    {{/each}}
    <button type="button" {{on "click" this.addMidiInstrument}}>+ midi</button>
  </template>
}
