import Route from '@ember/routing/route';
import { service } from '@ember/service';
import type RouterService from '@ember/routing/router-service';
import type Song from 'seq25/models/song';
import type SongsService from 'seq25/services/songs';
import type TransportService from 'seq25/services/transport';

export default class SongRoute extends Route<Song> {
  @service declare songs: SongsService;
  @service declare transport: TransportService;
  @service declare router: RouterService;

  /** A local song id, or the id of a shared song to copy locally. */
  async model({ song_id }: { song_id: string }): Promise<Song> {
    return this.songs.find(song_id) ?? (await this.songs.import(song_id));
  }

  redirect(song: Song): void {
    // A shared song was copied in under a new local id.
    const { song_id } = this.paramsFor('song') as { song_id: string };
    if (song_id !== song.id) {
      // By id: with the model itself the router sees the same object it just
      // resolved and treats this as a no-op, leaving the URL unchanged.
      this.router.replaceWith('song', song.id);
    }
  }

  setupController(...args: Parameters<Route<Song>['setupController']>): void {
    super.setupController(...args);
    this.transport.setSong(args[1]);
  }
}
