Seq25.SelectionBoxView = Ember.View.extend
  elementId: 'selection-box'

  attributeBindings: 'style'

  style: Em.computed 'content.corners.@each', ->
    [startCorner, stopCorner] = @get('content.corners')
    if startCorner && stopCorner
      dimensions =
        height: Math.abs startCorner.y - stopCorner.y
        top:    Math.min startCorner.y,  stopCorner.y
        width:  Math.abs startCorner.x - stopCorner.x
        left:   Math.min startCorner.x,  stopCorner.x

      (for key, value of dimensions
        "#{key}: #{value * 100}%"
      ).join(';')
