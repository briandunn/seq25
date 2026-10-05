import Component from '@glimmer/component';
import { service } from '@ember/service';
import { style, percent } from 'seq25/lib/styles';
import type Part from 'seq25/models/part';
import type TransportService from 'seq25/services/transport';

interface Signature {
  Args: { part: Part };
}

/**
 * The play position, as two bars that take turns gliding across a beat, so
 * one can jump back to the start while the other is mid-glide.
 */
export default class PlayBar extends Component<Signature> {
  @service declare transport: TransportService;

  get beatCount(): number {
    return this.args.part.beatCount;
  }

  get isEvenLoop(): boolean {
    return Math.floor(this.transport.beat / this.beatCount) % 2 === 0;
  }

  get progress(): number {
    return (this.transport.beat % this.beatCount) / this.beatCount;
  }

  barStyle(active: boolean) {
    const playing = this.transport.isPlaying && active;
    const left = playing ? this.progress + 1 / this.beatCount : -0.02;
    const seconds = playing ? this.args.part.secondsPerBeat : 0;
    return style(
      ['transition-duration', `${seconds}s`],
      ['left', percent(left)],
    );
  }

  get barOne() {
    return this.barStyle(this.isEvenLoop);
  }

  get barTwo() {
    return this.barStyle(!this.isEvenLoop);
  }

  <template>
    <div class="play-bar" style={{this.barOne}}></div>
    <div class="play-bar" style={{this.barTwo}}></div>
  </template>
}
