class Midi {
  constructor(output){
    this.output = output;
  }

  play(pitch, velocity, channel, start, duration){
    if (start == null) { start = 0; }
    const now = performance.now();
    const noteOnTime = now + (start * 1e3);
    this.sendOnAt(pitch, velocity, channel, noteOnTime);
    const noteOffTime = now + ((start + duration) * 1e3);
    if (duration) { return this.sendOffAt(pitch, channel, noteOffTime); }
  }

  stop(pitch, channel){
    return this.sendOffAt(pitch, channel, 0);
  }

  sendOnAt(pitch, velocity, channel, timeFromNow){
    const ON = 0x90 ^ channel;
    return this.output.send([ON, pitch, Math.floor(velocity * 127)], timeFromNow);
  }

  sendOffAt(pitch, channel, timeFromNow){
    const OFF = 0x80 ^ channel;
    return this.output.send([OFF, pitch, 0x7f], timeFromNow);
  }
}

let connectionPromise = null;
Midi.connect = () => connectionPromise || (connectionPromise = new Em.RSVP.Promise((resolve, reject) => navigator.requestMIDIAccess()
.then(function(access){
  let output;
  if (output = access.outputs.values().next().value) {
    return resolve(new Midi(output));
  } else {
    console.log('connected, but no outputs');
    return reject();
  }}).catch(function() {
  console.log("midi connection failure");
  return reject();
})));

export default Midi;
