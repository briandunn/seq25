import Pitch from "seq25/models/pitch";

const select = function() {
  const {totalTicks, corners, notes} = this.getProperties('corners', 'totalTicks', 'notes');
  const [lowPitch, highPitch] = Array.from(corners
  .map(corner => Pitch.numberAtScale(Math.max(corner.y, 0))).sort((a, b) => a > b));

  const [firstTick, lastTick] = Array.from(corners
  .map(corner => Math.round(corner.x * totalTicks)).sort((a, b) => a > b));

  const boxed = notes
  .filter(function(note){
    const {pitchNumber, absoluteTicks, duration} = note.getProperties('pitchNumber', 'absoluteTicks', 'duration');
    return (lowPitch  <= pitchNumber && pitchNumber <= highPitch) &&
    (firstTick <= (absoluteTicks + duration)) &&
    (lastTick  >= absoluteTicks);
  });

  return this.set('boxed', boxed);
};

const EMPTY_CORNERS =
  [
    {x: 0, y: 0},
    {x: 0, y: 0}
  ];

const toggle = function(selected, boxed, isAdditive){
  const toggleOne = function(item){
    if (selected.contains(item)) {
      selected.removeObject(item);
    } else {
      selected.pushObject(item);
    }
    return selected;
  };

  if (isAdditive) {
    for (var note of Array.from(boxed)) { toggleOne(note); }
  } else {
    selected.setObjects(boxed);
  }
  return selected;
};

const SelectionBoxController = Ember.Controller.extend({
  needs: 'part',
  notes: Em.computed.alias('controllers.part.notes'),
  totalTicks: Em.computed.alias('controllers.part.totalTicks'),

  init() {
    this.setProperties({
      _selected: [],
      corners: EMPTY_CORNERS,
      boxed: []});
    return this._super();
  },

  selected: Em.computed('_selected.[]', 'boxed.[]', function() {
    const {_selected, boxed, isAdditive} = this.getProperties('_selected', 'boxed', 'isAdditive');
    if (!boxed.length) { return _selected; }
    const selected = _selected.concat([]);
    return toggle(selected, boxed, isAdditive);
  }),

  boxClosed: Em.computed('corners.@each', function() {
    return this.get('corners').reduce(((sum, corner) => sum + corner.x + corner.y), 0) === 0;
  }),

  observeBox: Em.observer('corners.@each', function() {
    if (!this.get('boxClosed')) { return select.apply(this); }
  }),

  actions: {
    resize(corners, isAdditive){
      return this.setProperties({
        corners,
        isAdditive
      });
    },

    resized() {
      const {_selected, selected, boxed} = this.getProperties('_selected', 'selected', 'boxed');
      _selected.setObjects(selected);
      boxed.clear();
      return this.set('corners', EMPTY_CORNERS);
    },

    toggle(notes, param){
      if (param == null) { param = {}; }
      const {isAdditive} = param;
      return toggle(this.get('_selected'), notes, isAdditive);
    }
  }
});

export default SelectionBoxController;
