import Service from '@ember/service';
import config from 'seq25/config/environment';
import type { AudioProvider } from 'seq25/models/audio';

/** Inert audio nodes for tests, where nothing should make sound. */
function silentContext(): BaseAudioContext {
  const param = () => ({
    value: 0,
    setValueAtTime() {},
    linearRampToValueAtTime() {},
  });
  const node = () => ({
    connect() {},
    disconnect() {},
    start() {},
    gain: param(),
    Q: param(),
    frequency: param(),
    type: 'sine',
  });
  return {
    currentTime: 0,
    sampleRate: 44100,
    state: 'running',
    destination: node(),
    createGain: node,
    createOscillator: node,
    createBiquadFilter: node,
    createBufferSource: node,
    createBuffer: () => ({ getChannelData: () => new Float32Array(0) }),
    resume: () => Promise.resolve(),
  } as unknown as BaseAudioContext;
}

/**
 * The AudioContext, created on first use rather than at boot: browsers
 * start a context created before any user gesture suspended.
 */
export default class AudioService extends Service implements AudioProvider {
  private _context: BaseAudioContext | undefined;

  get context(): BaseAudioContext {
    // Creating the context on first use is the point of this getter.
    // eslint-disable-next-line ember/no-side-effects
    return (this._context ??= config.skipAudioContext
      ? silentContext()
      : new AudioContext());
  }

  /** Call from a user gesture before making sound. */
  resume(): void {
    const { context } = this;
    if (context instanceof AudioContext && context.state === 'suspended') {
      void context.resume();
    }
  }

  get currentTime(): number {
    return this.context.currentTime;
  }
}

declare module '@ember/service' {
  interface Registry {
    audio: AudioService;
  }
}
