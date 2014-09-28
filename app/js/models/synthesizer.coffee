Seq25.Synthesizer = Seq25.Instrument.extend
  shape:      DS.attr 'string', defaultValue: 'sine'
  attack:     DS.attr 'number', defaultValue: 0
  release:    DS.attr 'number', defaultValue: 0
  filterFreq: DS.attr 'number', defaultValue: 1
  filterQ:    DS.attr 'number', defaultValue: 0
  volume:     Em.computed.alias 'part.volume'
  isMuted:    Em.computed.alias 'part.isMuted'
  context:    Seq25.audioContext

  init: ->
    @set 'oscillators', {}
    context = @get 'context'
    @set('output', context.createGain())
    @get('output').connect context.destination
    @set 'lastVolume', @get('volume')
    @_super()

  mute: (->
    {output, isMuted} = @getProperties 'output', 'isMuted'
    if isMuted
      @set('lastVolume', @get('volume'))
      output.gain.value = 0
    else
      output.gain.value = @get('lastVolume')
  ).observes('isMuted').on('init')

  adjustVolume: (->
    {output, volume} = @getProperties 'output', 'volume'
    output.gain.value = volume
  ).observes('volume').on('init')

  findOrCreateOscillator: (pitch)->
    @get('oscillators')[pitch.get('number')] ||= Seq25.Osc.create
      pitch: pitch
      synthesizer: this

  play: (note, secondsFromNow=0)->
    {pitch, durationSeconds} = note.getProperties 'pitch', 'durationSeconds'
    @findOrCreateOscillator(pitch).play(secondsFromNow, durationSeconds)

  stop: ->
    value.stop() for _, value of @get 'oscillators'
