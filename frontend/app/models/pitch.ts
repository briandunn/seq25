const NOTE_NAMES = [
  'A',
  'A#',
  'B',
  'C',
  'C#',
  'D',
  'D#',
  'E',
  'F',
  'F#',
  'G',
  'G#',
];
const A0_FREQ = 27.5;

export default class Pitch {
  readonly number: number;
  readonly name: string;
  readonly freq: number;
  readonly isSharp: boolean;

  constructor(number: number) {
    this.number = number;
    this.name =
      NOTE_NAMES[(number - 21) % 12]! + String(Math.round((number - 17) / 12));
    this.freq = A0_FREQ * Math.pow(2, (number - 21) / 12);
    this.isSharp = this.name.includes('#');
  }

  /** The 88 piano keys, highest first (the order they're drawn in). */
  static readonly all: readonly Pitch[] = Array.from(
    { length: 88 },
    (_, i) => new Pitch(108 - i),
  );

  static byNumber(number: number): Pitch | undefined {
    return Pitch.all[108 - number];
  }

  /** The pitch number at a vertical position, 0 (top) to 1 (bottom). */
  static numberAtScale(scale: number): number {
    const index = Math.floor(Pitch.all.length * scale);
    const clamped = Math.min(Math.max(index, 0), Pitch.all.length - 1);
    return Pitch.all[clamped]!.number;
  }

  static scaleAtPitch(pitch: Pitch | undefined): number {
    return (pitch ? Pitch.all.indexOf(pitch) : -1) / Pitch.all.length;
  }

  static highest(num: number): number {
    return Math.min(Pitch.all[0]!.number, num);
  }

  static lowest(num: number): number {
    return Math.max(Pitch.all[Pitch.all.length - 1]!.number, num);
  }
}
