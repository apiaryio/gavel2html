{assert}      = require 'chai'

Gavel2Html    = require '../src/index'
fixtures      = require './fixtures/gavel2html'

outputOptions = fixtures.gavel2htmlOutputOptions

runTest = (test, outputOptions) ->
  describe test.testDesc , ->
    gavel2html = undefined
    output = undefined
    before (done) ->
      gavel2html = new Gavel2Html test
      output = gavel2html.getHtml outputOptions
      done()

    it 'html output should be as expected', ->
      assert.equal output, test.expectedOutput

    it 'used errors  should be as expected', ->
      assert.deepEqual gavel2html.usedErrors, test.usedErrors



describe 'Gavel2Html Tests', ->
  describe 'headers tests', ->
    outputOptions.comments = false
    for test in fixtures.testsHeaders
      do (test) ->
        runTest test, outputOptions


  describe 'body tests', ->
    outputOptions.comments = true
    for test in fixtures.testsBody
      do (test) ->
        runTest test, outputOptions

