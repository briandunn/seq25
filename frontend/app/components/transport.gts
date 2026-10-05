import Component from '@glimmer/component';
import { service } from '@ember/service';
import { on } from '@ember/modifier';
import { registerDestructor } from '@ember/destroyable';
import type Owner from '@ember/owner';
import type RouterService from '@ember/routing/router-service';
import type Part from 'seq25/models/part';
import type Song from 'seq25/models/song';
import type EditorService from 'seq25/services/editor';
import type KeyboardService from 'seq25/services/keyboard';
import type SongsService from 'seq25/services/songs';
import type TransportService from 'seq25/services/transport';

interface Signature {
  Args: { song: Song };
}

/** Play/stop and the beat counter, plus the song-wide keyboard commands. */
export default class Transport extends Component<Signature> {
  @service declare transport: TransportService;
  @service declare editor: EditorService;
  @service declare keyboard: KeyboardService;
  @service declare songs: SongsService;
  @service declare router: RouterService;

  constructor(owner: Owner, args: Signature['Args']) {
    super(owner, args);
    const t = this.transport;
    const unregister = this.keyboard.register({
      t: () => void this.router.transitionTo('song.index'),
      g: (_, key) => this.gotoPart(key),
      m: (_, key) => this.edit(() => this.mutePart(this.partFor(key))),
      o: (_, key) => this.edit(() => this.soloPart(this.partFor(key))),
      b: (n, key) => this.edit(() => this.changeBeats(this.partFor(key), n)),
      x: (n) => this.changeQuant(n),
      n: (n, key) => this.edit(() => this.partFor(key)?.bumpVolume('up', n)),
      'shift+n': (n, key) =>
        this.edit(() => this.partFor(key)?.bumpVolume('down', n)),
      'shift+o': () => this.edit(() => t.setMuteForAll(false)),
      'shift+m': () => this.edit(() => t.setMuteForAll(true)),
      space: () => (t.toggle(), true),
    });
    registerDestructor(this, unregister);
  }

  /** The part a typed part letter names, else the part being edited. */
  partFor(key: string): Part | undefined {
    return key ? this.args.song.getPart(key) : this.transport.currentPart;
  }

  private edit(change: () => void): void {
    change();
    this.songs.scheduleSave();
  }

  gotoPart(key: string): void {
    const { song } = this.args;
    if (!key) return;
    if (!song.getPart(key)) {
      song.addPart({ name: key }).addSynthesizer();
      this.songs.save();
    }
    void this.router.transitionTo('song.part', key);
  }

  mutePart(part: Part | undefined): void {
    if (part) {
      part.toggle();
    } else {
      this.transport.setMuteForAll(true);
    }
  }

  soloPart(part: Part | undefined): void {
    if (part) {
      this.transport.setMuteForAll(true);
      part.toggle();
    } else {
      this.transport.setMuteForAll(false);
    }
  }

  changeBeats(part: Part | undefined, count: number): void {
    if (!part || count < 1) return;
    part.beatCount = count === 1 ? part.beatCount + 1 : count;
  }

  changeQuant(count: number): void {
    if (count === 1) {
      this.editor.incrementQuant();
    } else {
      this.editor.setQuant(count);
    }
  }

  toggle = () => this.transport.toggle();

  <template>
    <section>
      <div id="transport">
        <button type="button" {{on "click" this.toggle}}>
          {{#if this.transport.isPlaying}}❙&nbsp;❙{{else}}▶{{/if}}
        </button>
        <h3>{{this.transport.beat}}</h3>
      </div>
    </section>
  </template>
}
