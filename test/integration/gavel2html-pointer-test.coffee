{assert}      = require 'chai'

Gavel2Html    = require '../../src/index'
fixtures      = require '../fixtures/gavel2html-pointers'

outputOptions = fixtures.gavel2htmlOutputOptions

runTest = (test, outputOptions) ->
  describe test.testDesc , ->
    gavel2html = undefined
    output = undefined
    before (done) ->
      test.usePointers = true
      gavel2html = new Gavel2Html test
      output = gavel2html.getHtml outputOptions
      done()

    it 'html output should be as expected', ->
      assert.equal output, test.expectedOutput

    it 'used errors should be as expected', ->
      assert.deepEqual gavel2html.usedErrors, test.usedErrors

describe 'Gavel2Html Tests with JSON pointer notation', ->
  describe 'headers tests', ->
    outputOptions.comments = false
    for name, test of fixtures.testsHeaders
      do (test) ->
        runTest test, outputOptions


  describe 'body tests', ->
    outputOptions.comments = true
    for name, test of fixtures.testsBody
      do (test) ->
        runTest test, outputOptions


