import {NotesView, NoteView} from "seq25/views/notes";

const relativePoint = function($el, event){
  const {pageX, pageY} = event;
  const {left, top} = $el.offset();
  return {
    x: (pageX - left) / $el.width(),
    y: (pageY - top) / $el.height()
  };
};

const NoteEditView = NoteView.extend({
  target: Em.computed.alias('controller.controllers.selectionBox'),
  classNameBindings: 'isSelected:selected',
  selectedNotes: Em.computed.alias('controller.selectedNotes'),

  isSelected: Em.computed('selectedNotes.[]', function() {
    return this.get('selectedNotes').contains(this.get('content'));
  }),

  noteOnScreen() {
    const {
      top
    } = this.$().offset();
    return (top > document.documentElement.scrollTop) &&
    (top < (document.documentElement.scrollTop + window.innerHeight));
  },

  scrollNote: (function() {
    return Ember.run.scheduleOnce('afterRender', this, function() {
      if (!this.isDestroying && !this.noteOnScreen()) {
        return scrollTo(10, this.element.offsetTop);
      }
  });
  }).observes("top").on('init'),

  mouseDown(down){
    return down.stopPropagation();
  },

  mouseUp(up){
    return up.stopPropagation();
  },

  click(event) {
    event.stopPropagation();
    return this.send('toggle', [this.get('content')], {isAdditive: event.shiftKey});
  }
});

const distance = (a, b) => Math.sqrt(Math.pow(a.x - b.x, 2), Math.pow(a.y - b.y, 2));

const NotesEditView = NotesView.extend({
  target: Em.computed.alias('controller.controllers.selectionBox'),
  isDragging: false,

  mouseDown(down){
    down.stopPropagation();
    const startCorner = relativePoint(this.$(), down);
    const startPoint = {x: down.clientX, y: down.clientY};
    return this.mouseMove = move=> {
      move.stopPropagation();
      if (!this.get('isDragging') && !(distance(startPoint, {x: move.clientX, y: move.clientY}) > 10)) { return; }
      this.set('isDragging', true);
      return this.send('resize',
        [startCorner, relativePoint(this.$(), move)],
        down.shiftKey);
    };
  },

  mouseUp(up){
    up.stopPropagation();
    delete this.mouseMove;
    if (this.get('isDragging')) {
      this.send('resized');
      return this.set('isDragging', false);
    } else {
      return this.send('addNote', relativePoint(this.$(), up));
    }
  },

  itemViewClass: NoteEditView
});
export default NotesEditView;
