Seq25.MidiInstrument = DS.Model.extend
  part:    DS.belongsTo 'part'
  channel: DS.attr 'number', defaultValue: 1
  volume:  DS.attr 'number', defaultValue: 0.75
  isMuted: Em.computed.alias 'part.isMuted'

  play: (note, start)->
    return if @get 'isMuted'
    {pitchNumber, durationSeconds} = note.getProperties 'pitchNumber', 'durationSeconds'
    {volume, channel} = @getProperties 'volume', 'channel'
    Seq25.Midi.connect().then (midi)=>
      midi.play pitchNumber, volume, channel, start, durationSeconds
