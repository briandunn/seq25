Seq25.PartsSummaryController = Ember.ObjectController.extend
  needs: 'transport'
  transport: Em.computed.alias 'controllers.transport'
  bucketCount: 10

  pitches: (->
    {notes, bucketCount} = @getProperties 'notes', 'bucketCount'
    pitchNumbers = notes.mapBy('pitchNumber').sort()
    [min, max] = [pitchNumbers[0], pitchNumbers[pitchNumbers.length - 1]]
    range = max - min + 1
    scale = bucketCount / range
    buckets = ([] for _ in [1..bucketCount])
    notes.forEach (note)->
      bucketNumber = Math.floor((note.get('pitchNumber') - min) * scale)
      buckets[bucketNumber].push note
    buckets.reverse()
  ).property('notes.[]', 'beat_count')
