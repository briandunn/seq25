Seq25.MidiInstrument = DS.Model.extend
  part:    DS.belongsTo 'part'
  channel: DS.attr 'number', default: 1
  isMuted: Em.computed.alias 'part.isMuted'
  play: (note, start)->
    return if @get 'isMuted'
    {pitchNumber, durationSeconds} = note.getProperties 'pitchNumber', 'durationSeconds'
    Seq25.Midi.connect().then (midi)=>
      midi.play pitchNumber, @get('channel'), start, durationSeconds
