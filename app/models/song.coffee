Song = DS.Model.extend
  parts:    DS.hasMany 'part'
  remoteId: DS.attr 'number'
  tempo:    DS.attr 'number', defaultValue: 120
  secondsPerBeat: (-> 60 / @get('tempo') ).property('tempo')

  getPart: (name)->
    @get('parts').findBy('name', name)

  schedule: (now, from, to)->
    @get('parts').invoke 'schedule', now, from, to

  stop: ->
    @get('parts').invoke 'stop'

  notes: Em.computed 'parts.@each.notes', ->
    @get('parts')
    .map (part)-> part.get('notes').toArray()
    .reduce ((all, some)-> all.concat(some)), []

  didDelete: ->
    @get('parts').invoke 'destroyRecord'

`export default Song`
