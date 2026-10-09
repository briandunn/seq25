import PartGrid from 'seq25/components/part-grid';
import type { TOC } from '@ember/component/template-only';
import type Song from 'seq25/models/song';

export default <template>
  <PartGrid @song={{@model}} />
</template> satisfies TOC<{ Args: { model: Song } }>;
