RangeView = Ember.View.extend
  type: 'range'
  tagName: 'input'
  attributeBindings: ['type', 'min', 'max', 'step', 'value']
  change: ->
    @set 'value', +@$().val()

`export default RangeView`
