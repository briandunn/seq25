import Pitch from "seq25/models/pitch";
//
// Abstract base classes for viewing lists of notes.
// Check out concrete implementations in notes-edit and notes-summary.
//
const NotesView = Ember.CollectionView.extend({
  tagName: 'ul',
  classNames: 'notes'
});

const NoteView = Ember.View.extend({
  attributeBindings: 'style',

  totalTicks: Em.computed.alias('content.part.totalTicks'),

  cssAttributes: 'left width top opacity'.w(),

  left: Em.computed('content.absoluteTicks', 'totalTicks', function() {
    return `${(this.get('content.absoluteTicks') / this.get('totalTicks')) * 100}%`;
  }),

  width: Em.computed('content.duration', 'totalTicks', function() {
    return `${(this.get('content.duration') / this.get('totalTicks')) * 100}%`;
  }),

  top: Em.computed('content.pitch', function() {
    const percentage = Pitch.scaleAtPitch(this.get('content.pitch')) * 100;
    return `calc(${percentage}% + 3px)`;
  }),

  opacity: Em.computed('content.velocity', function() {
    return this.get("content.velocity");
  }),

  style: Em.computed('left', 'width', 'top', 'height', 'opacity', function() {
    return this.get('cssAttributes')
    .map(attribute=> {
      return `${attribute}: ${this.get(attribute)};`;
  }).join(' ').htmlSafe();
  })
});

export {NotesView, NoteView};
