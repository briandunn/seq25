`import Ember from 'ember'`

SeqMeasureComponent = Ember.Component.extend
  beatCount: null
  classNames: 'measure'
  tagName: 'li'
  attributeBindings: 'style'
  style: Em.computed 'beatCount', ->
    new Em.Handlebars.SafeString "width: #{100 / @get('beatCount')}%"

`export default SeqMeasureComponent`
