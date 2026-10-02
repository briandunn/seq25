const SelectionBoxView = Ember.View.extend({
  elementId: 'selection-box',

  attributeBindings: 'style',

  style: Em.computed('controller.corners.@each', function() {
    const [startCorner, stopCorner] = Array.from(this.get('controller.corners'));
    if (startCorner && stopCorner) {
      const dimensions = {
        height: Math.abs(startCorner.y - stopCorner.y),
        top:    Math.min(startCorner.y,  stopCorner.y),
        width:  Math.abs(startCorner.x - stopCorner.x),
        left:   Math.min(startCorner.x,  stopCorner.x)
      };

      return ((() => {
        const result = [];
        for (var key in dimensions) {
          var value = dimensions[key];
          result.push(`${key}: ${value * 100}%`);
        }
      
        return result;
      })()).join(';').htmlSafe();
    }
  })
});

export default SelectionBoxView;
