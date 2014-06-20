Seq25.TransportController = Ember.ObjectController.extend

  song: Ember.computed.alias 'model'

  empty: (-> @get('parts').length == 0).property('parts.@each')

  loopDuration: (->
    @get('maxBeatCount') * 60 / +@get('tempo')
  ).property('tempo', 'maxBeatCount')

  currentTime: -> Seq25.audioContext.currentTime

  loopHasEnded: -> @progress() >= 1

  startedAt: 0

  isPlaying: false

  elapsed: ->
    @currentTime() - @get('startedAt')

  progress: ->
    @elapsed() / @get('loopDuration')

  play: ->
    @set('startedAt', @currentTime())
    @set('isPlaying', true)
    @get('song').schedule()
    movePlayBar = =>
      $('.play-bar').css left: "#{@progress() * 100}%"
      return unless @get('isPlaying')
      if @loopHasEnded()
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


