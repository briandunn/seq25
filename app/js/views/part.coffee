Seq25.PartView = Ember.View.extend

  didInsertElement: ->
    Ember.run.scheduleOnce 'afterRender', this, 'bindKeys'

  bindKeys: ->
    Mousetrap.bind 'backspace', =>
      @get('controller').send('removeNotes')
      return false

    Mousetrap.bind 'right', =>
      @get('controller').send('extendNotes')

    Mousetrap.bind 'left', =>
      @get('controller').send('shortenNotes')

  willDestroyElement: ->
    Mousetrap.unbind 'backspace left right'
