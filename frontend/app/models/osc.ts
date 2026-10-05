import type Pitch from 'seq25/models/pitch';
import type Synthesizer from 'seq25/models/synthesizer';

const NOISE_SECONDS = 2;

/** One voice of a synthesizer: an always-running source gated by a gain. */
export default class Osc {
  private readonly synthesizer: Synthesizer;
  private readonly context: BaseAudioContext;
  private readonly filter: BiquadFilterNode;
  private readonly gain: AudioParam;
  private readonly oscillator: OscillatorNode;
  private noise: AudioBufferSourceNode | undefined;

  constructor(synthesizer: Synthesizer, pitch: Pitch, output: AudioNode) {
    this.synthesizer = synthesizer;
    const context = (this.context = synthesizer.context);

    this.filter = context.createBiquadFilter();
    const gain = context.createGain();
    gain.gain.value = 0;
    this.filter.connect(gain);
    gain.connect(output);
    this.gain = gain.gain;

    this.oscillator = context.createOscillator();
    this.oscillator.frequency.value = pitch.freq;
    this.oscillator.start(0);

    this.applyShape();
    this.applyFilterQ();
    this.applyFilterFreq();
  }

  applyShape(): void {
    const { shape } = this.synthesizer;
    if (shape === 'noise') {
      this.oscillator.disconnect();
      this.noiseSource().connect(this.filter);
    } else {
      this.noise?.disconnect();
      this.oscillator.type = shape;
      this.oscillator.connect(this.filter);
    }
  }

  applyFilterQ(): void {
    this.filter.Q.value = this.synthesizer.filterQ * 100;
  }

  applyFilterFreq(): void {
    this.filter.frequency.value =
      this.synthesizer.filterFreq * (this.context.sampleRate / 2);
  }

  play(secondsFromNow: number, rampTo = 1, duration?: number): void {
    const time = this.context.currentTime + secondsFromNow;
    this.gain.setValueAtTime(0, time);
    this.gain.linearRampToValueAtTime(rampTo, time + this.synthesizer.attack);
    if (duration) this.stop(secondsFromNow + duration);
  }

  stop(secondsFromNow = 0): void {
    const time = this.context.currentTime + (secondsFromNow - 0.003);
    this.gain.linearRampToValueAtTime(0, time + this.synthesizer.release);
  }

  // The old app generated noise in a ScriptProcessorNode with values in
  // [0, 1); a looping buffer of the same values sounds the same without the
  // deprecated node.
  private noiseSource(): AudioBufferSourceNode {
    if (!this.noise) {
      const { context } = this;
      const length = context.sampleRate * NOISE_SECONDS;
      const buffer = context.createBuffer(2, length, context.sampleRate);
      for (const channel of [0, 1]) {
        const data = buffer.getChannelData(channel);
        for (let i = 0; i < length; i++) data[i] = Math.random();
      }
      this.noise = context.createBufferSource();
      this.noise.buffer = buffer;
      this.noise.loop = true;
      this.noise.start(0);
    }
    return this.noise;
  }
}
