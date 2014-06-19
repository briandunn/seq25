describe "Seq25.PartsSummaryController", ->
  describe 'pitches', ->
    subject = null
    beforeEach ->
      subject = Seq25.PartsSummaryController.create(notes: [])
      subject.set('bucketCount', 4)

    it 'groups an even count evenly', ->
      notes = [
        {pitchNumber: 1},
        {pitchNumber: 2},
        {pitchNumber: 3},
        {pitchNumber: 4}
      ]
      subject.set 'notes', notes.map((n)-> Ember.Object.create(n))
      pitches = subject.get('pitches')
      expect(pitches.length).toEqual(4)
      pitches.reverse().forEach (notes, i)->
        expect(notes.length).toEqual(1)
        expect(notes[0].get('pitchNumber')).toEqual(i + 1)

    it 'condenses a broader range', ->
      notes = [
        {pitchNumber: 2},
        {pitchNumber: 4},
        {pitchNumber: 6},
        {pitchNumber: 8}
      ]
      subject.set 'notes', notes.map((n)-> Ember.Object.create(n))
      pitches = subject.get('pitches')
      pitches.reverse().forEach (notes, i)->
        expect(notes.length).toEqual(1)
        expect(notes[0].get('pitchNumber')).toEqual((i + 1) * 2)
