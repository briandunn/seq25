`import Midi from "seq25/models/midi"`
`import Pitch from "seq25/models/pitch"`

MidiInstrument = DS.Model.extend
  part:    DS.belongsTo 'part'
  channel: DS.attr 'number', defaultValue: 1
  volume:  DS.attr 'number', defaultValue: 0.75
  isMuted: Em.computed.alias 'part.isMuted'

  play: (note, start)->
    return if @get 'isMuted'
    {durationSeconds, velocity} = note.getProperties 'durationSeconds', 'velocity'
    {volume, channel} = @getProperties 'volume', 'channel'
    Midi.connect().then (midi)=>
      midi.play note.get('pitch.number'), velocity * volume, channel, start, durationSeconds

  stop: (note)->
    Midi.connect().then (midi)=>
      channel = @get 'channel'
      if note
        midi.stop note.get('pitch.number'), channel
      else
        for pitch in Pitch.all
          midi.stop pitch, channel

`export default MidiInstrument`
