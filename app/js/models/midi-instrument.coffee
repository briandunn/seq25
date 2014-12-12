Seq25.MidiInstrument = DS.Model.extend
  part:    DS.belongsTo 'part'
  channel: DS.attr 'number', defaultValue: 1
  volume:  DS.attr 'number', defaultValue: 0.75
  isMuted: Em.computed.alias 'part.isMuted'

  play: (note, start)->
    return if @get 'isMuted'
    {durationSeconds, velocity} = note.getProperties 'durationSeconds', 'velocity'
    {volume, channel} = @getProperties 'volume', 'channel'
    Seq25.Midi.connect().then (midi)=>
      midi.play note.get('pitch.number'), velocity * volume, channel, start, durationSeconds

  stop: (note)->
    Seq25.Midi.connect().then (midi)=>
      channel = @get 'channel'
      if note
        midi.stop note.get('pitch.number'), channel
      else
        for pitch in Seq25.Pitch.all
          midi.stop pitch, channel
