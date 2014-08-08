Seq25.PartsSummaryController = Ember.ObjectController.extend
  needs: 'transport'
  progress: Em.computed.alias('controllers.transport.progress')

  playBarStyle: (->
    "left: #{@get('progress') * 100}%"
  ).property('progress')

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
