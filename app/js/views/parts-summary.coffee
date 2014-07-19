Seq25.PartsSummaryView = Ember.View.extend
  didInsertElement: ->
    addEventListener 'keydown', (e)=>
      return unless @get('state') == 'inDOM'
      key = String.fromCharCode(e.keyCode)
      if @get('controller').get('name') == key and not e.metaKey
        @get('controller').send('hotKey')
        e.preventDefault()
