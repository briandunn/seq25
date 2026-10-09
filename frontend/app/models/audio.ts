/** Where models get their AudioContext from; created on first use. */
export interface AudioProvider {
  readonly context: BaseAudioContext;
}
