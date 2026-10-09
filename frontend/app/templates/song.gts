import SongControls from 'seq25/components/song-controls';
import type { TOC } from '@ember/component/template-only';
import type Song from 'seq25/models/song';

export default <template>
  <SongControls @song={{@model}} />
  {{outlet}}
</template> satisfies TOC<{ Args: { model: Song } }>;
