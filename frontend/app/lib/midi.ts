export default class Midi {
  private readonly output: MIDIOutput;

  constructor(output: MIDIOutput) {
    this.output = output;
  }

  play(
    pitch: number,
    velocity: number,
    channel: number,
    start = 0,
    duration?: number,
  ): void {
    const now = performance.now();
    this.sendOnAt(pitch, velocity, channel, now + start * 1e3);
    if (duration) {
      this.sendOffAt(pitch, channel, now + (start + duration) * 1e3);
    }
  }

  stop(pitch: number, channel: number): void {
    this.sendOffAt(pitch, channel, 0);
  }

  private sendOnAt(
    pitch: number,
    velocity: number,
    channel: number,
    timestamp: number,
  ): void {
    this.output.send(
      [0x90 ^ channel, pitch, Math.floor(velocity * 127)],
      timestamp,
    );
  }

  private sendOffAt(pitch: number, channel: number, timestamp: number): void {
    this.output.send([0x80 ^ channel, pitch, 0x7f], timestamp);
  }

  private static connection: Promise<Midi> | undefined;

  /** The first MIDI output, requested once and shared. */
  static connect(): Promise<Midi> {
    return (Midi.connection ??= navigator.requestMIDIAccess().then((access) => {
      const output = access.outputs.values().next().value;
      if (!output) throw new Error('connected, but no MIDI outputs');
      return new Midi(output);
    }));
  }
}
