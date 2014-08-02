Seq25.Note = DS.Model.extend
  pitchNumber: DS.attr 'number'
  beat_count: DS.attr 'number'
  position: DS.attr 'number'
  part: DS.belongsTo 'part'

  pitch: (-> Seq25.Pitch.all.findBy('number', @get('pitchNumber'))).property('pitchNumber')
  beatFraction: (-> @get('beat_count') * @get('position') ).property('position', 'beat_count')
  beat: (-> Math.floor @get('beatFraction') ).property('beatFraction')
  tick: (-> Math.floor((@get('beatFraction') - @get('beat')) * 96) ).property('beatFraction', 'beat')

  isPitch: (pitch)->
    @get('pitchNumber') == pitch.number

  schedule: (tempo)->
    beatDuration = 60 / tempo
    start = (@get('beat') * beatDuration) + ((@get('tick') / 96) * beatDuration)
    Seq25.Osc.play(@get('pitch'), start, 0.1)

  stop: ->
    Seq25.Osc.stop @get 'pitch'
