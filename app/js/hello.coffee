noteNames = ['A','A#','B','C','C#','D','D#','E','F','F#','G','G#']
notes = for number in [21..108]
  number: number
  name: noteNames[(number - 21) % 12] + Math.round((number - 17) / 12)

window.hello = ->
  html = JST['app/templates/hello.us'] beats: 16, notes: notes.reverse()
  document.body.innerHTML += html

window.addEventListener('DOMContentLoaded', hello, false)
context = new window.webkitAudioContext
oscilator = context.createOscillator()
oscilator.connect context.destination
# oscilator.start 0
