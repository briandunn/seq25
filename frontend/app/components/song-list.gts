import Component from '@glimmer/component';
import { service } from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import { LinkTo } from '@ember/routing';
import { isTesting } from '@embroider/macros';
import NotesSummary from 'seq25/components/notes-summary';
import { listRemote, type RemoteSongRef } from 'seq25/lib/remote';
import type Owner from '@ember/owner';
import type RouterService from '@ember/routing/router-service';
import type Song from 'seq25/models/song';
import type SongsService from 'seq25/services/songs';

/** Local songs, then the songs shared to the backend. */
export default class SongList extends Component {
  @service declare songs: SongsService;
  @service declare router: RouterService;

  @tracked remoteSongs: RemoteSongRef[] = [];

  constructor(owner: Owner, args: object) {
    super(owner, args);
    void this.refreshRemote();
  }

  async refreshRemote(): Promise<void> {
    try {
      const songs = await listRemote();
      if (!this.isDestroying) this.remoteSongs = songs;
    } catch {
      // The backend being down shouldn't break the local songs.
    }
  }

  addSong = () => {
    void this.router.transitionTo('song', this.songs.create());
  };

  removeSong = (song: Song) => {
    if (isTesting() || confirm('Delete this song?')) this.songs.remove(song);
  };

  share = (song: Song) => {
    this.songs
      .share(song)
      .then(() => this.refreshRemote())
      .catch((error: unknown) => console.error('could not share song', error));
  };

  <template>
    <section id="songs">
      <button type="button" {{on "click" this.addSong}}>+</button>
      <ul>
        {{#each this.songs.all as |song|}}
          <li class="song">
            <header class="actions">
              <button
                type="button"
                {{on "click" (fn this.removeSong song)}}
              >&minus;</button>
              <button
                type="button"
                {{on "click" (fn this.share song)}}
              >&uarr;</button>
            </header>
            <LinkTo @route="song" @model={{song.id}}>
              <NotesSummary @notes={{song.notes}} />
            </LinkTo>
          </li>
        {{/each}}
        {{#each this.remoteSongs as |remote|}}
          <li>
            <LinkTo @route="song" @model={{remote.id}}>{{remote.id}}</LinkTo>
          </li>
        {{/each}}
      </ul>
    </section>
  </template>
}
