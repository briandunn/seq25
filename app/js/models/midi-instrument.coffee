Seq25.MidiInstrument = Seq25.Instrument.extend
  channel: DS.attr 'number', default: 1
  play: (note, start)->
    {pitchNumber, durationSeconds} = note.getProperties 'pitchNumber', 'durationSeconds'
    Seq25.Midi.connect().then (midi)=>
      midi.play pitchNumber, @get('channel'), start, durationSeconds
