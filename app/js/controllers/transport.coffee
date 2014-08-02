Seq25.TransportController = Ember.ObjectController.extend

  song: Ember.computed.alias 'model'

  empty: (-> @get('parts').length == 0).property('parts.@each')

  loopDuration: (->
    @get('maxBeatCount') * 60 / +@get('tempo')
  ).property('tempo', 'maxBeatCount')

  currentTime: -> Seq25.audioContext.currentTime

  loopHasEnded: -> @get('progress') >= 1

  startedAt: 0
  progress: 0

  isPlaying: false

  beat: (->
    Math.floor((@elapsed() * @get('tempo')) / 60)
  ).property('progress')

  elapsed: ->
    return 0 unless @get('isPlaying')
    @currentTime() - @get('startedAt')

  play: ->
    @set('startedAt', @currentTime())
    @set('isPlaying', true)
    @get('song').schedule(@get('progress'))
    movePlayBar = =>
      @set('progress', @elapsed() / @get('loopDuration'))
      return unless @get('isPlaying')
      if @loopHasEnded()
        @set('progress', 0)
        @play()
      else
        requestAnimationFrame movePlayBar
    requestAnimationFrame movePlayBar

  stop: ->
    @get('song').stop()
    @set('startedAt', 0)
    @set('isPlaying', false)

  actions:
    play: ->
      return if @get('empty')
      if @get('isPlaying') then @stop() else @play()


