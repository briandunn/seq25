beats = 8
barDurration = 300
noteNames = ['A','A#','B','C','C#','D','D#','E','F','F#','G','G#']
notes = for number in [21..108]
  number: number
  name: noteNames[(number - 21) % 12] + Math.round((number - 17) / 12)

window.hello = ->
  html = JST['app/templates/hello.us'] beats: beats, notes: notes.reverse()
  document.body.innerHTML += html

window.addEventListener('DOMContentLoaded', hello, false)

currentBeat = 0
beat = ->
  td.classList.remove('playing') for td in document.querySelectorAll('td')
  for td in document.querySelectorAll("tr td:nth-child(#{currentBeat + 2})")
    do ->
      td.classList.add('playing')
  currentBeat = (currentBeat + 1) % beats

beatInterval = null
window.onkeydown = (e)->
  if e.keyCode == 32
    unless beatInterval
      beatInterval = setInterval beat, barDurration
    else
      clearInterval(beatInterval)
      beatInterval = null

context = new window.webkitAudioContext
oscilator = context.createOscillator()
oscilator.connect context.destination
# oscilator.start 0
