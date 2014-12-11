Seq25.PartController = Ember.ObjectController.extend
  pitches: (-> Seq25.Pitch.all).property('model')
  needs: ['transport', 'selectionBox']
  transport: Em.computed.alias('controllers.transport')
  quant: 1

  selectedNotes: Em.computed.alias 'controllers.selectionBox.selected'

  beats: (-> [1..@get('beat_count')] ).property('beat_count')

  partSaver: ( ->
    @get('model').save()
  ).observes('beat_count', 'volume', 'isMuted', 'notes.[]')

  noteSaver: ( ->
    @get('notes').invoke 'save'
  ).observes('notes.[]')

  positionSaver: ( ->
    Ember.run.cancel @_positionSaver
    @_positionSaver = Ember.run.later(this, (->
      @get('selectedNotes').invoke('save')
    ), 250)
  ).observes('notes.@each.duration',
             'notes.@each.tick',
             'notes.@each.beat',
             'notes.@each.pitchNumber')

  editResolution: (->
    q = parseInt(@get('quant')) || Seq25.Note.TICKS_PER_BEAT
    beatSlice = 1 / q
    beatSlice * Seq25.Note.TICKS_PER_BEAT
  ).property('quant')

  changeNoteDuration: (direction, num)->
    @get('selectedNotes').invoke 'changeDuration', @get('editResolution') * num * direction

  addAdjacentNotes: (num, addNoteCallback) ->
    {selectedNotes, editResolution, quant, model} = @getProperties 'selectedNotes', 'editResolution', 'quant', 'model'
    selectionBox =  @get 'controllers.selectionBox'
    firstLength = selectedNotes.get 'firstObject.duration'
    firstLength = editResolution unless selectedNotes.every((n) -> n.get("duration") == firstLength)
    newNotes = selectedNotes
    .map (note)->
      {pitchNumber, absoluteTicks, duration} = addNoteCallback(
        note.getProperties('pitchNumber', 'absoluteTicks', 'duration'), num, firstLength
      )
      newNote = model.addNote pitchNumber, absoluteTicks, duration, quant
    selectionBox.send 'toggle', newNotes

  actions:
    removeNotes: ->
      selectedNotes = @get 'selectedNotes'
      removeOne = (note)->
        if note
          note.destroyRecord().then ->
            removeOne(selectedNotes.popObject())
      removeOne selectedNotes.popObject()

    addNote: (position)->
      note = @get('model').addNoteAtPoint position, @get('quant')
      @get('controllers.selectionBox').send 'toggle', [note]

    addNoteLeft: (num) ->
      @addAdjacentNotes num, (attributes, moveNum, moveDistance) ->
        absoluteTicks = attributes.absoluteTicks - ((moveDistance || attributes.duration) * moveNum)
        Em.merge attributes, absoluteTicks: absoluteTicks

    addNoteRight: (num) ->
      @addAdjacentNotes num, (attributes, moveNum, moveDistance) ->
        absoluteTicks = attributes.absoluteTicks + ((moveDistance || attributes.duration) * moveNum)
        Em.merge attributes, absoluteTicks: absoluteTicks

    addNoteDown: (num) ->
      @addAdjacentNotes num, (attributes, moveNum) ->
        Em.merge attributes, pitchNumber: attributes.pitchNumber - moveNum

    addNoteUp: (num) ->
      @addAdjacentNotes num, (attributes, moveNum) ->
        Em.merge attributes, pitchNumber: attributes.pitchNumber + moveNum

    extendNotes: (num) ->
      @changeNoteDuration(1, num)

    shortenNotes: (num) ->
      @changeNoteDuration(-1, num)

    nudgeLeft: (num) ->
      _.times(num, => @get('selectedNotes').invoke 'nudgeLeft', @get('quant'))

    nudgeRight: (num) ->
      _.times(num, => @get('selectedNotes').invoke 'nudgeRight', @get('quant'))

    createNote: ->
      @send 'addNote', x: 0, y: 0

    moveUp: (num) ->
      @get('selectedNotes').invoke 'moveUp', num

    moveDown: (num) ->
      @get('selectedNotes').invoke 'moveDown', num

    setVelocity: (num) ->
      @get('selectedNotes').invoke 'set', 'velocity', Math.min (num / 10), 1.0
