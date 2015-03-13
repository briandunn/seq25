`import startApp from '../helpers/start-app'`
`import {stubAudio} from '../helpers/unit'`
`import {test, module} from 'qunit'`
`import {helpers} from '../helpers/helper'`

application = null
module 'Acceptance: chooses song',
  beforeEach: ->
    localStorage.setItem 'seq25', """
{
   "song" : {
      "records" : {
         "18d8i" : {
            "tempo" : 120,
            "id" : "18d8i",
            "remoteId" : null,
            "parts" : [
               {
                  "isMuted" : false,
                  "name" : "Q",
                  "midiInstruments" : [],
                  "notes" : [
                     {
                        "id" : "b0c0n",
                        "velocity" : 0.75,
                        "pitchNumber" : 42,
                        "beat" : 0,
                        "part" : "khc0q",
                        "duration" : 84,
                        "tick" : 0
                     },
                     {
                        "tick" : 0,
                        "part" : "khc0q",
                        "duration" : 96,
                        "beat" : 1,
                        "pitchNumber" : 42,
                        "velocity" : 0.75,
                        "id" : "jbiiv"
                     },
                     {
                        "part" : "khc0q",
                        "tick" : 0,
                        "duration" : 84,
                        "id" : "8ih14",
                        "velocity" : 0.75,
                        "pitchNumber" : 42,
                        "beat" : 4
                     },
                     {
                        "id" : "ugsg0",
                        "beat" : 5,
                        "pitchNumber" : 42,
                        "velocity" : 0.75,
                        "part" : "khc0q",
                        "duration" : 96,
                        "tick" : 0
                     },
                     {
                        "velocity" : 0.75,
                        "beat" : 8,
                        "pitchNumber" : 38,
                        "id" : "j5fgk",
                        "part" : "khc0q",
                        "tick" : 0,
                        "duration" : 84
                     },
                     {
                        "velocity" : 0.75,
                        "pitchNumber" : 38,
                        "beat" : 9,
                        "id" : "4g19d",
                        "part" : "khc0q",
                        "duration" : 96,
                        "tick" : 0
                     },
                     {
                        "pitchNumber" : 35,
                        "beat" : 12,
                        "velocity" : 0.75,
                        "id" : "5s70u",
                        "tick" : 0,
                        "part" : "khc0q",
                        "duration" : 84
                     },
                     {
                        "beat" : 13,
                        "pitchNumber" : 35,
                        "velocity" : 0.75,
                        "id" : "2nmcl",
                        "part" : "khc0q",
                        "duration" : 96,
                        "tick" : 0
                     }
                  ],
                  "synthesizers" : [
                     {
                        "filterQ" : 0,
                        "shape" : "sine",
                        "part" : "khc0q",
                        "volume" : 0.75,
                        "id" : "m2bm1",
                        "attack" : 0,
                        "release" : 0,
                        "filterFreq" : 1
                     }
                  ],
                  "beat_count" : 16,
                  "id" : "khc0q",
                  "song" : "18d8i",
                  "volume" : 0.75
               },
               {
                  "song" : "18d8i",
                  "volume" : 0.75,
                  "id" : "01d7i",
                  "beat_count" : 4,
                  "synthesizers" : [
                     {
                        "id" : "p2q2e",
                        "volume" : 0.75,
                        "filterFreq" : 1,
                        "release" : 0,
                        "attack" : 0,
                        "shape" : "noise",
                        "filterQ" : 0,
                        "part" : "01d7i"
                     }
                  ],
                  "notes" : [
                     {
                        "id" : "12ung",
                        "velocity" : 0.75,
                        "beat" : 2,
                        "pitchNumber" : 87,
                        "part" : "01d7i",
                        "tick" : 0,
                        "duration" : 24
                     },
                     {
                        "duration" : 12,
                        "part" : "01d7i",
                        "tick" : 48,
                        "pitchNumber" : 87,
                        "beat" : 3,
                        "velocity" : 0.75,
                        "id" : "680vj"
                     },
                     {
                        "velocity" : 0.75,
                        "beat" : 3,
                        "pitchNumber" : 87,
                        "id" : "djoi4",
                        "duration" : 12,
                        "part" : "01d7i",
                        "tick" : 72
                     }
                  ],
                  "midiInstruments" : [],
                  "name" : "W",
                  "isMuted" : false
               },
               {
                  "midiInstruments" : [],
                  "notes" : [
                     {
                        "id" : "rju0u",
                        "beat" : 1,
                        "pitchNumber" : 71,
                        "velocity" : 0.75,
                        "part" : "gmaed",
                        "duration" : 36,
                        "tick" : 48
                     },
                     {
                        "pitchNumber" : 83,
                        "beat" : 2,
                        "velocity" : 0.75,
                        "id" : "sd0fq",
                        "tick" : 0,
                        "part" : "gmaed",
                        "duration" : 36
                     },
                     {
                        "id" : "35ad6",
                        "velocity" : 0.75,
                        "pitchNumber" : 71,
                        "beat" : 2,
                        "part" : "gmaed",
                        "tick" : 48,
                        "duration" : 36
                     },
                     {
                        "id" : "2niqn",
                        "beat" : 3,
                        "pitchNumber" : 77,
                        "velocity" : 0.75,
                        "duration" : 48,
                        "part" : "gmaed",
                        "tick" : 0
                     },
                     {
                        "id" : "f000e",
                        "pitchNumber" : 78,
                        "beat" : 3,
                        "velocity" : 0.75,
                        "tick" : 48,
                        "part" : "gmaed",
                        "duration" : 96
                     },
                     {
                        "id" : "rf7ao",
                        "velocity" : 0.75,
                        "beat" : 5,
                        "pitchNumber" : 71,
                        "part" : "gmaed",
                        "duration" : 36,
                        "tick" : 48
                     },
                     {
                        "velocity" : 0.75,
                        "pitchNumber" : 83,
                        "beat" : 6,
                        "id" : "2pjam",
                        "part" : "gmaed",
                        "tick" : 0,
                        "duration" : 48
                     },
                     {
                        "duration" : 36,
                        "part" : "gmaed",
                        "tick" : 48,
                        "beat" : 6,
                        "pitchNumber" : 71,
                        "velocity" : 0.75,
                        "id" : "nbcgr"
                     },
                     {
                        "duration" : 36,
                        "part" : "gmaed",
                        "tick" : 0,
                        "id" : "q57n7",
                        "velocity" : 0.75,
                        "beat" : 7,
                        "pitchNumber" : 85
                     },
                     {
                        "part" : "gmaed",
                        "duration" : 96,
                        "tick" : 48,
                        "id" : "qghd9",
                        "beat" : 7,
                        "pitchNumber" : 83,
                        "velocity" : 0.75
                     }
                  ],
                  "name" : "E",
                  "isMuted" : false,
                  "id" : "gmaed",
                  "volume" : 0.75,
                  "song" : "18d8i",
                  "synthesizers" : [
                     {
                        "part" : "gmaed",
                        "filterQ" : 0,
                        "shape" : "sine",
                        "attack" : 0,
                        "release" : 0,
                        "filterFreq" : 1,
                        "volume" : 0.28,
                        "id" : "06l21"
                     }
                  ],
                  "beat_count" : 16
               },
               {
                  "notes" : [
                     {
                        "beat" : 10,
                        "pitchNumber" : 86,
                        "velocity" : 0.75,
                        "id" : "c9i12",
                        "duration" : 12,
                        "part" : "hqvru",
                        "tick" : 0
                     },
                     {
                        "part" : "hqvru",
                        "duration" : 12,
                        "tick" : 24,
                        "velocity" : 0.75,
                        "pitchNumber" : 86,
                        "beat" : 10,
                        "id" : "4ta5c"
                     },
                     {
                        "part" : "hqvru",
                        "duration" : 24,
                        "tick" : 60,
                        "pitchNumber" : 86,
                        "beat" : 10,
                        "velocity" : 0.75,
                        "id" : "r3ok5"
                     },
                     {
                        "id" : "s0eir",
                        "velocity" : 0.75,
                        "beat" : 14,
                        "pitchNumber" : 85,
                        "tick" : 0,
                        "part" : "hqvru",
                        "duration" : 12
                     },
                     {
                        "beat" : 14,
                        "pitchNumber" : 85,
                        "velocity" : 0.75,
                        "id" : "6r1pg",
                        "tick" : 24,
                        "part" : "hqvru",
                        "duration" : 12
                     },
                     {
                        "part" : "hqvru",
                        "duration" : 24,
                        "tick" : 60,
                        "id" : "85e05",
                        "beat" : 14,
                        "pitchNumber" : 85,
                        "velocity" : 0.75
                     }
                  ],
                  "midiInstruments" : [],
                  "name" : "R",
                  "isMuted" : false,
                  "volume" : 0.75,
                  "song" : "18d8i",
                  "id" : "hqvru",
                  "beat_count" : 16,
                  "synthesizers" : [
                     {
                        "filterQ" : 0,
                        "shape" : "square",
                        "part" : "hqvru",
                        "volume" : 0.34,
                        "id" : "iv2ng",
                        "attack" : 0.06,
                        "release" : 0.02,
                        "filterFreq" : 1
                     }
                  ]
               },
               {
                  "synthesizers" : [
                     {
                        "id" : "3qku9",
                        "volume" : 0.19,
                        "filterFreq" : 1,
                        "release" : 0,
                        "attack" : 0.81,
                        "shape" : "sawtooth",
                        "filterQ" : 0,
                        "part" : "1epvn"
                     }
                  ],
                  "beat_count" : 20,
                  "id" : "1epvn",
                  "song" : "18d8i",
                  "volume" : 0.75,
                  "isMuted" : false,
                  "name" : "A",
                  "midiInstruments" : [],
                  "notes" : [
                     {
                        "velocity" : 0.75,
                        "beat" : 0,
                        "pitchNumber" : 54,
                        "id" : "fgc4h",
                        "duration" : 480,
                        "part" : "1epvn",
                        "tick" : 0
                     },
                     {
                        "part" : "1epvn",
                        "tick" : 0,
                        "duration" : 768,
                        "id" : "ntc0v",
                        "velocity" : 0.75,
                        "beat" : 0,
                        "pitchNumber" : 47
                     },
                     {
                        "velocity" : 1,
                        "beat" : 2,
                        "pitchNumber" : 35,
                        "id" : "3in2b",
                        "part" : "1epvn",
                        "tick" : 0,
                        "duration" : 1152
                     }
                  ]
               }
            ]
         }
      }
   }
}
"""

    application = startApp()
    stubAudio(application)

  afterEach: ->
    window.localStorage.removeItem 'seq25'
    Ember.run application, 'destroy'

test 'see song preview', ->

  visit('/')
  andThen ->
    equal find('#songs .song ul.notes li.Q').length, 8
