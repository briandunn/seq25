moduleForModel 'note', 'Note Model', needs: ['model:part']
test 'set absoluteTicks', ->
	note = @subject absoluteTicks: Seq25.Note.TICKS_PER_BEAT + 20
	equal note.get('beat'), 1
	equal note.get('tick'), 20

	Ember.run ->
		note.set 'absoluteTicks', 0

	equal note.get('beat'), 0
	equal note.get('tick'), 0

test 'get absoluteTicks', ->
	note = @subject beat: 1, tick: 20
	equal note.get('absoluteTicks'), Seq25.Note.TICKS_PER_BEAT + 20

test 'nudgeLeft', ->
	note = @subject beat: 1, tick: 20
	quant = 1
	beatCount = 16

	Ember.run -> note.nudgeLeft(quant)

	equal note.get('beat'), 1
	equal note.get('tick'), 0

	Ember.run -> note.nudgeLeft(quant)

	equal note.get('beat'), 0
	equal note.get('tick'), 0
