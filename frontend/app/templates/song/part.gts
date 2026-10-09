import PianoRoll from 'seq25/components/piano-roll';
import type { TOC } from '@ember/component/template-only';
import type Part from 'seq25/models/part';

export default <template>
  {{#if @model}}
    <PianoRoll @part={{@model}} />
  {{/if}}
  {{outlet}}
</template> satisfies TOC<{ Args: { model: Part | undefined } }>;
