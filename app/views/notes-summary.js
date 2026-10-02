import {NotesView, NoteView} from "seq25/views/notes";

const NoteSummaryView = NoteView.extend({
  attributeBindings: 'style',
  classNameBindings: 'class',

  cssAttributes: 'left width top height opacity'.w(),

  class: Em.computed.alias('content.part.name'),

  heightFraction() {
    return 1 / this.get('range');
  },

  height: Em.computed(function() {
    return `${this.heightFraction() * 100}%`;
  }),

  top: Em.computed(function() {
    const adjusted = this.get('content.pitchNumber') - this.get('min');
    return `${ ((1 - (adjusted / this.get('range'))) - this.heightFraction()) * 100 }%`;
  })
});

const NotesSummaryView = NotesView.extend({
  pitchNumbers: Em.computed.mapBy('content', 'pitchNumber'),
  min: Em.computed.min('pitchNumbers'),
  max: Em.computed.max('pitchNumbers'),
  range: Em.computed('min', 'max', function() { return (this.get('max') - this.get('min')) + 1; }),
  itemViewClass: NoteSummaryView,
  createChildView(viewClass, attrs){
    const {min, range} = this.getProperties('min', 'range');
    return this._super(viewClass, Em.merge(attrs, {range, min}));
  }
});

export default NotesSummaryView;
