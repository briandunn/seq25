import Component from '@glimmer/component';
import { service } from '@ember/service';
import { on } from '@ember/modifier';
import { LinkTo } from '@ember/routing';
import NumberInput from 'seq25/components/number-input';
import PartControls from 'seq25/components/part-controls';
import Transport from 'seq25/components/transport';
import Instruments from 'seq25/components/instruments';
import type RouterService from '@ember/routing/router-service';
import type Song from 'seq25/models/song';
import type SongsService from 'seq25/services/songs';
import type TransportService from 'seq25/services/transport';

interface Signature {
  Args: { song: Song };
}

export default class SongControls extends Component<Signature> {
  @service declare songs: SongsService;
  @service declare transport: TransportService;
  @service declare router: RouterService;

  get showInstruments(): boolean {
    return this.router.currentRouteName === 'song.part.instruments';
  }

  get permalink(): string | undefined {
    const { remoteId } = this.args.song;
    if (remoteId === null) return undefined;
    return `${location.origin}${this.router.urlFor('song', String(remoteId))}`;
  }

  setTempo = (tempo: number) => {
    if (tempo < 1) return;
    this.args.song.tempo = tempo;
    this.songs.scheduleSave();
  };

  share = () => {
    this.songs.share(this.args.song).catch((error: unknown) => {
      console.error('could not share song', error);
    });
  };

  <template>
    <section class="controls">
      <h2>Sequence</h2>
      <LinkTo @route="song.index" class="parts">Parts</LinkTo>
      <LinkTo @route="index" class="songs">Songs</LinkTo>
      <button type="button" {{on "click" this.share}}>&uarr;</button>
      {{#if this.permalink}}
        <dl>
          <dt><label for="permalink">Permalink</label></dt>
          <dd><input id="permalink" readonly value={{this.permalink}} /></dd>
        </dl>
      {{/if}}
      <article>
        <dl>
          <dt><label for="tempo">Tempo</label></dt>
          <dd>
            <NumberInput
              id="tempo"
              @min={{1}}
              @max={{480}}
              @value={{@song.tempo}}
              @onChange={{this.setTempo}}
            />
          </dd>
          {{#if this.transport.currentPart}}
            <PartControls @part={{this.transport.currentPart}} />
          {{/if}}
        </dl>
        <Transport @song={{@song}} />
      </article>
      {{#if this.showInstruments}}
        {{#if this.transport.currentPart}}
          <Instruments @part={{this.transport.currentPart}} />
        {{/if}}
      {{/if}}
    </section>
  </template>
}
