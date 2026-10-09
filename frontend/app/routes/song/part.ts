import Route from '@ember/routing/route';
import { service } from '@ember/service';
import type RouterService from '@ember/routing/router-service';
import type Part from 'seq25/models/part';
import type Song from 'seq25/models/song';
import type EditorService from 'seq25/services/editor';

export default class SongPartRoute extends Route<Part | undefined> {
  @service declare editor: EditorService;
  @service declare router: RouterService;

  model({ name }: { name: string }): Part | undefined {
    const song = this.modelFor('song') as Song;
    const part = song.getPart(name);
    if (!part) this.router.transitionTo('song', song);
    return part;
  }

  setupController(...args: Parameters<Route<Part>['setupController']>): void {
    super.setupController(...args);
    this.editor.editPart(args[1]);
  }

  deactivate(): void {
    this.editor.editPart(undefined);
  }
}
