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
      notes = @get('selectedNotes').map (n) =>
        @get('model').addNote(n.get('pitchNumber'), n.get('absoluteTicks') - (Seq25.Note.TICKS_PER_BEAT * num), @get('quant'))
      @set('selectedNotes', notes)

    addNoteRight: (num) ->
      notes = @get('selectedNotes').map (n) =>
        @get('model').addNote(n.get('pitchNumber'), n.get('absoluteTicks') + (Seq25.Note.TICKS_PER_BEAT * num), @get('quant'))
      @set('selectedNotes', notes)

    addNoteDown: (num) ->
      notes = @get('selectedNotes').map (n) =>
        @get('model').addNote(n.get('pitchNumber') - num, n.get('absoluteTicks'), @get('quant'))
      @set('selectedNotes', notes)

    addNoteUp: (num) ->
      notes = @get('selectedNotes').map (n) =>
        @get('model').addNote(n.get('pitchNumber') + num, n.get('absoluteTicks'), @get('quant'))
      @set('selectedNotes', notes)

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
      @set('selectedNotes', [note])

    moveUp: (num) ->
      @get('selectedNotes').invoke 'moveUp', num

    moveDown: (num) ->
      @get('selectedNotes').invoke 'moveDown', num
