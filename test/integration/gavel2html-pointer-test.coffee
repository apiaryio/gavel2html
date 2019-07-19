{assert}      = require 'chai'
clone         = require 'clone'

Gavel2Html    = require '../../src/index'
fixtures      = require '../fixtures/gavel2html-pointers'

outputOptions = fixtures.gavel2htmlOutputOptions

runTest = (test, gavelOptions) ->
  describe test.testDesc, ->
    gavel2html = undefined
    output = undefined
    before (done) ->
      test.usePointers = true
      gavel2html = new Gavel2Html test
      output = gavel2html.getHtml gavelOptions
      done()

    it 'html output should be as expected', ->
      assert.equal output, test.expectedOutput

    it 'used errors should be as expected', ->
      assert.deepEqual gavel2html.usedErrors, test.usedErrors

describe 'Gavel2Html Tests with JSON pointer notation', ->
  describe 'headers tests', ->
    for name, test of fixtures.testsHeaders
      do (test) ->
        outputOpts = clone outputOptions
        outputOpts.comments = false
        runTest clone(test), (test.outputOptions or outputOpts)


  describe 'body tests', ->
    for name, test of fixtures.testsBody
      do (test) ->
        outputOpts = clone outputOptions
        outputOpts.comments = true
        runTest clone(test), (test.outputOptions or outputOpts)


