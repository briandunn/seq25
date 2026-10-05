import Component from '@glimmer/component';
import { service } from '@ember/service';
import { LinkTo } from '@ember/routing';
import NumberInput from 'seq25/components/number-input';
import { TICKS_PER_BEAT } from 'seq25/models/note';
import type Part from 'seq25/models/part';
import type EditorService from 'seq25/services/editor';
import type SongsService from 'seq25/services/songs';

interface Signature {
  Args: { part: Part };
}

/**
 * Beats, quant, and the instruments toggle. Both links render; the stylesheet
 * hides the active one and shows the one after it.
 */
export default class PartControls extends Component<Signature> {
  @service declare editor: EditorService;
  @service declare songs: SongsService;

  maxQuant = TICKS_PER_BEAT;

  setBeats = (beats: number) => {
    if (beats < 1) return;
    this.args.part.beatCount = Math.trunc(beats);
    this.songs.scheduleSave();
  };

  setQuant = (quant: number) => this.editor.setQuant(quant);

  <template>
    <dt><label for="beats">Beats</label></dt>
    <dd>
      <NumberInput
        id="beats"
        @min={{1}}
        @max={{32}}
        @value={{@part.beatCount}}
        @onChange={{this.setBeats}}
      />
    </dd>
    <dt><label for="quant">Quant</label></dt>
    <dd>
      <NumberInput
        id="quant"
        @min={{0}}
        @max={{this.maxQuant}}
        @value={{this.editor.quant}}
        @onChange={{this.setQuant}}
      />
    </dd>
    <dt>
      <LinkTo @route="song.part.instruments" @model={{@part.name}}>
        &darr; &darr; &darr;
      </LinkTo>
      <LinkTo @route="song.part" @model={{@part.name}}>
        &uarr; &uarr; &uarr;
      </LinkTo>
    </dt>
  </template>
}
