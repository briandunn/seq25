import Component from '@glimmer/component';
import { service } from '@ember/service';
import { on } from '@ember/modifier';
import type Pitch from 'seq25/models/pitch';
import type AudioService from 'seq25/services/audio';

/** What a piano key plays: a Part, or anything else with these methods. */
export interface Playable {
  playPitch(pitch: Pitch): void;
  stop(pitch?: Pitch): void;
}

interface Signature {
  Args: { part: Playable; pitch: Pitch };
  Element: HTMLLIElement;
}

export default class PianoKey extends Component<Signature> {
  @service declare audio: AudioService;

  play = () => {
    this.audio.resume();
    this.args.part.playPitch(this.args.pitch);
  };

  stop = () => this.args.part.stop(this.args.pitch);

  <template>
    {{! A key sounds while held, from press to release. }}
    {{! template-lint-disable no-invalid-interactive no-pointer-down-event-binding }}
    <li
      class="row {{if @pitch.isSharp 'sharp'}}"
      {{on "mousedown" this.play}}
      {{on "mouseup" this.stop}}
      {{on "mouseleave" this.stop}}
      ...attributes
    >{{@pitch.name}}</li>
  </template>
}
