Seq25.PlayBarComponent = Ember.Component.extend
  beat: Em.computed.alias 'transport.beat'
  isPlaying: Em.computed.alias 'transport.isPlaying'
  beatCount: Em.computed.alias 'part.beat_count'
  secondsPerBeat: Em.computed.alias 'part.secondsPerBeat'

  loopCount: (->
    Math.floor(@get('beat') / @get('beatCount'))
  ).property 'beat', 'beatCount'

  isEvenLoop: (-> (@get('loopCount') % 2) == 0 ).property('loopCount')

  progress: (->
    (@get('beat') % @get('beatCount')) / @get('beatCount')
  ).property('beat', 'beatCount')

  playBarOne: (->
    @toStyleAttribute @get('isEvenLoop')
  ).property('secondsPerBeat', 'progress', 'isPlaying')

  playBarTwo: (->
    @toStyleAttribute not @get('isEvenLoop')
  ).property('secondsPerBeat', 'progress', 'isPlaying')

  toStyleAttribute: (active)->
    {progress, beatCount, secondsPerBeat, isPlaying} =
      @getProperties 'progress', 'beatCount', 'secondsPerBeat', 'isPlaying'

    [left, duration] = if isPlaying and active
      [(progress + 1/beatCount), secondsPerBeat]
    else
      [-0.02, 0]
    "transition-duration: #{duration}s; left: #{left * 100}%"

