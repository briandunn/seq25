Seq25.Synthesizer = DS.Model.extend
  part:       DS.belongsTo 'part'
  shape:      DS.attr 'string', defaultValue: 'sine'
  attack:     DS.attr 'number', defaultValue: 0
  release:    DS.attr 'number', defaultValue: 0
  filterFreq: DS.attr 'number', defaultValue: 1
  filterQ:    DS.attr 'number', defaultValue: 0
  volume:     DS.attr 'number', defaultValue: 0.75
  isMuted:    Em.computed.alias 'part.isMuted'
  context:    Em.computed -> @container.resolve 'audioContext:main'

  init: ->
    @_super()
    @set 'oscillators', {}
    context = @get 'context'
    @set('output', context.createGain())
    @get('output').connect context.destination

  adjustVolume: (->
    {output, volume} = @getProperties 'output', 'volume'
    output.gain.value = volume
  ).observes('volume').on 'init'

  mute: (->
    {output, isMuted} = @getProperties 'output', 'isMuted'
    if isMuted
      output.disconnect()
    else
      output.connect @get('context').destination
  ).observes('isMuted').on 'init'

  findOrCreateOscillator: (pitch)->
    @get('oscillators')[pitch.get('number')] ||= Seq25.Osc.create
      pitch: pitch
      synthesizer: this

  play: (note, secondsFromNow=0)->
    {pitch, durationSeconds, velocity} = note.getProperties 'pitch', 'durationSeconds', 'velocity'
    @findOrCreateOscillator(pitch).play(secondsFromNow, velocity, durationSeconds)

  stop: (pitch)->
    oscillators = @get 'oscillators'
    if pitch
      oscillators[pitch.get('number')]?.stop()
    else
      value.stop() for _, value of oscillators
