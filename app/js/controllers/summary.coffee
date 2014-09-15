Seq25.PartsSummaryController = Ember.ObjectController.extend
  needs: 'transport'
  beat: Em.computed.alias 'controllers.transport.beat'
  isPlaying: Em.computed.alias 'controllers.transport.isPlaying'

  loopCount: (->
    Math.floor(@get('beat') / @get('beat_count'))
  ).property 'beat', 'beat_count'

  isEvenLoop: (-> (@get('loopCount') % 2) == 0 ).property('loopCount')

  progress: (->
    (@get('beat') % @get('beat_count')) / @get('beat_count')
  ).property('beat', 'beat_count')

  toStyleAttribute: (active)->
    {progress, beat_count, secondsPerBeat, isPlaying} =
      @getProperties 'progress', 'beat_count', 'secondsPerBeat', 'isPlaying'

    [left, duration] = if isPlaying and active
      [(progress + 1/beat_count), secondsPerBeat]
    else
      [-0.02, 0]
    "transition-duration: #{duration}s; left: #{left * 100}%"

  playBarOne: (->
    @toStyleAttribute @get('isEvenLoop')
  ).property('secondsPerBeat', 'progress', 'isPlaying')

  playBarTwo: (->
    @toStyleAttribute not @get('isEvenLoop')
  ).property('secondsPerBeat', 'progress', 'isPlaying')

  bucketCount: 10

  pitches: (->
    pitchNumbers = @get('notes').mapBy('pitchNumber').sort()
    [min, max] = [pitchNumbers[0], pitchNumbers[pitchNumbers.length - 1]]
    range = max - min + 1
    scale = @get('bucketCount') / range
    buckets = ([] for _ in [1..@get('bucketCount')])
    @get('notes').forEach (note)->
      bucketNumber = Math.floor((note.get('pitchNumber') - min) * scale)
      buckets[bucketNumber].push note
    buckets.reverse()
  ).property('notes.@each')
