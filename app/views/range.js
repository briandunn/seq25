const RangeView = Ember.View.extend({
  type: 'range',
  tagName: 'input',
  attributeBindings: ['type', 'min', 'max', 'step', 'value'],
  change() {
    return this.set('value', +this.$().val());
  }
});

export default RangeView;
