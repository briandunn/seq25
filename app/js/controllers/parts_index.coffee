Seq25.PartsIndexController = Ember.ArrayController.extend
  rowSize: 4
  rows: (->
    [0,1].map (x)=>
      @slice @get('rowSize') * x, @get('rowSize') + (@get('rowSize') * x)
  ).property()
  actions:
    hotKey: (key)->
      @forEach (part)=>
        if part.get('name') == key
          @transitionToRoute('part', part)
