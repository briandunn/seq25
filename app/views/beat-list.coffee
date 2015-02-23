BeatListView = Ember.CollectionView.extend
  classNames: ['measures']
  itemViewClass: Ember.View.extend
    classNames: ['measure']
    didInsertElement: ->
      beats = @get('controller').get('beat_count')
      @$().css(width: "#{100 / beats }%")

`export default BeatListView`
