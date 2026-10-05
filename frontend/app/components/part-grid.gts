import Component from '@glimmer/component';
import { service } from '@ember/service';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import { LinkTo } from '@ember/routing';
import PlayBar from 'seq25/components/play-bar';
import NotesSummary from 'seq25/components/notes-summary';
import { PART_NAMES } from 'seq25/models/part';
import type RouterService from '@ember/routing/router-service';
import type Part from 'seq25/models/part';
import type Song from 'seq25/models/song';
import type SongsService from 'seq25/services/songs';

interface Signature {
  Args: { song: Song };
}

/** The song's eight part slots, Q W E R / A S D F. */
export default class PartGrid extends Component<Signature> {
  @service declare songs: SongsService;
  @service declare router: RouterService;

  get slots(): { name: string; part: Part | undefined }[] {
    return PART_NAMES.map((name) => ({
      name,
      part: this.args.song.getPart(name),
    }));
  }

  addPart = (name: string) => {
    this.args.song.addPart({ name }).addSynthesizer();
    this.songs.save();
    void this.router.transitionTo('song.part', name);
  };

  removePart = (part: Part) => {
    this.args.song.removePart(part);
    this.songs.save();
  };

  <template>
    <section id="parts">
      <ul>
        {{#each this.slots as |slot|}}
          {{#if slot.part}}
            <li class="part {{if slot.part.isMuted 'mute'}}">
              <header class="actions">
                <button
                  type="button"
                  {{on "click" (fn this.removePart slot.part)}}
                >&minus;</button>
              </header>
              <LinkTo @route="song.part" @model={{slot.name}}>
                <PlayBar @part={{slot.part}} />
                <NotesSummary @notes={{slot.part.notes}} />
              </LinkTo>
            </li>
          {{else}}
            {{! template-lint-disable no-invalid-interactive }}
            <li class="empty" {{on "click" (fn this.addPart slot.name)}}></li>
          {{/if}}
        {{/each}}
      </ul>
    </section>
  </template>
}
