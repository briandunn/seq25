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

  addNoteDirection: (num, addNoteCallback) ->
    context = this
    notes = @get('selectedNotes').map( (n) -> addNoteCallback(n, num, context))
    @get('controllers.selectionBox').replaceSelected(notes)

  addNote: (pitch, position, width) ->
    @get('model').addNote(pitch, position, width, @get('quant'))

  addDown: (note, moveNum, context) ->
    pitch = note.get('pitchNumber') - moveNum
    position = note.get('absoluteTicks')
    width = note.get('duration')
    context.addNote(pitch, position, width)

  addUp: (note, moveNum, context) ->
    pitch = note.get('pitchNumber') + moveNum
    position = note.get('absoluteTicks')
    width = note.get('duration')
    context.addNote(pitch, position, width)

  addLeft: (note, moveNum, context) ->
    pitch    = note.get('pitchNumber')
    position = note.get('absoluteTicks') - (note.get('duration') * moveNum)
    width    = note.get('duration')
    context.addNote(pitch, position, width)

  addRight: (note, moveNum, context) ->
    pitch    = note.get('pitchNumber')
    position = note.get('absoluteTicks') + (note.get('duration') * moveNum)
    width    = note.get('duration')
    context.addNote(pitch, position, width)

  actions:
    removeNotes: ->
      selectedNotes = @get 'selectedNotes'
      removeOne = (note)->
        if note
          note.destroyRecord().then ->
            removeOne(selectedNotes.popObject())
      removeOne selectedNotes.popObject()

    addNote: (position)->
      @get('model').addNoteAtPoint position, @get('quant')

    addNoteLeft: (num) ->
      @addNoteDirection(num, @addLeft)

    addNoteRight: (num) ->
      @addNoteDirection(num, @addRight)

    addNoteDown: (num) ->
      @addNoteDirection(num, @addDown)

    addNoteUp: (num) ->
      @addNoteDirection(num, @addUp)

    extendNotes: (num) ->
      @changeNoteDuration(1, num)

    shortenNotes: (num) ->
      @changeNoteDuration(-1, num)

    nudgeLeft: (num) ->
      _.times(num, => @get('selectedNotes').invoke 'nudgeLeft', @get('quant'))

    nudgeRight: (num) ->
      _.times(num, => @get('selectedNotes').invoke 'nudgeRight', @get('quant'))

    createNote: ->
      note = @get('model').addNoteAtPoint({x: 0, y: 0}, @get('quant'))
      @get('controllers.selectionBox').replaceSelected([note])

    moveUp: (num) ->
      @get('selectedNotes').invoke 'moveUp', num

    moveDown: (num) ->
      @get('selectedNotes').invoke 'moveDown', num
