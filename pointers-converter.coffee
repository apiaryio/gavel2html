jsonPointer = require 'json-pointer'
fixtures = require './test/fixtures/gavel2html-pointers.coffee'


for name, fixture of fixtures.testsBody
  if fixture.gavelResult.rawData != undefined
    console.log "-----> #{name} <----"
    out = {}
    out.gavelResult = {}
    out.gavelResult.results = []
    out.gavelResult.validator = fixture.gavelResult.validator
    delete fixture.gavelResult.rawData.length if fixture.gavelResult.rawData != undefined
    for index, error of fixture.gavelResult.rawData
      try
        entry = {}
        entry.messagae = error.message
        entry.severity = 'error'
        entry.pointer = jsonPointer.compile (if error.property != null then error.property else '')
        out.gavelResult.results.push entry
      catch e
        console.log 'Boooboo'

    console.log JSON.stringify out, null, 2

#for name, fixture in fixtures.testsBody




