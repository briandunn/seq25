import Ember from 'ember';

const SeqMeasureComponent = Ember.Component.extend({
  beatCount: null,
  classNames: 'measure',
  tagName: 'li',
  attributeBindings: 'style',
  style: Em.computed('beatCount', function() {
    return new Em.Handlebars.SafeString(`width: ${100 / this.get('beatCount')}%`);
  })
});

export default SeqMeasureComponent;
