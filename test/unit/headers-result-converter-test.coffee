{assert} = require 'chai'
clone    = require 'clone'

HeadersResultConverter = require '../../src/headers-result-converter'
pointerFixtures = require '../fixtures/gavel2html-pointers'

describe 'HeadersResultConverter', () ->
  describe 'regression test for migration from amandaResults to JSON pointer based results in headers on case mismatch problem', () ->
    expectedOutput = [
      {
        "pathArray": [
          "testHeader1"
        ],
        "state": 2,
        "message": "Value of the ‘testheader1’ must be 'testHeader1Val'.",
        "value": "tEstHeader1Val"
      },
      {
        "pathArray": [
          "testHeader2"
        ],
        "state": 2,
        "message": "Value of the ‘testheader2’ must be 'testHeader2Val'.",
        "value": "testHEader2Val"
      }
    ]

    describe 'getLinesFromResults', () ->
      describe 'when called', () ->
        it 'should have proper structure and values', () ->
          jsonResultConverter = new HeadersResultConverter {
            dataReal: pointerFixtures.testsHeaders.headersRealFailValueCase.fieldResult.values.actual
            dataExpected: pointerFixtures.testsHeaders.headersRealFailValueCase.fieldResult.values.expected
            fieldResult: pointerFixtures.testsHeaders.headersRealFailValueCase.fieldResult
            usePointers: true
          }
          result = jsonResultConverter.getLinesFromResults()
          result = clone result, false
          assert.deepEqual result, expectedOutput

  describe 'regression test for migration from amandaResults to JSON pointer based results in headers on value change', () ->
    expectedOutput = [
      {
        "pathArray": [
          "testHeader1"
        ],
        "state": 0,
        "message": "",
        "value": "testHeader1Val"
      },
      {
        "pathArray": [
          "testHeader2"
        ],
        "state": 2,
        "message": "Value of the ‘testheader2’ must be 'testHeader2Val'.",
        "value": "testHEader2ValChanged"
      }
    ]

    describe 'getLinesFromResults', () ->
      describe 'when called', () ->
        it 'should have proper structure and values', () ->
          jsonResultConverter = new HeadersResultConverter {
            dataReal: pointerFixtures.testsHeaders.headersRealFailChanged.fieldResult.values.actual
            dataExpected: pointerFixtures.testsHeaders.headersRealFailChanged.fieldResult.values.expected
            fieldResult: pointerFixtures.testsHeaders.headersRealFailChanged.fieldResult
            usePointers: true
          }
          result = jsonResultConverter.getLinesFromResults()
          result = clone result, false
          assert.deepEqual result, expectedOutput

  describe 'regression test for migration from amandaResults to JSON pointer based results in headers in key missing', () ->
    expectedOutput = [
      {
        "pathArray": [
          "testHeader1"
        ],
        "state": 0,
        "message": "",
        "value": "testHeader1Val"
      },
      {
        "pathArray": [
          "testHeader2"
        ],
        "state": -1,
        "message": "The ‘testheader2’ property is required. | Value of the ‘testheader2’ must be 'testHeader2Val'.",
        "value": "testHeader2Val"
      }
    ]

    describe 'getLinesFromResults', () ->
      describe 'when called', () ->
        it 'should have proper structure and values', () ->
          jsonResultConverter = new HeadersResultConverter {
            dataReal: pointerFixtures.testsHeaders.headersRealFailMiss.fieldResult.values.actual
            dataExpected: pointerFixtures.testsHeaders.headersRealFailMiss.fieldResult.values.expected
            fieldResult: pointerFixtures.testsHeaders.headersRealFailMiss.fieldResult
            usePointers: true
          }
          result = jsonResultConverter.getLinesFromResults()
          result = clone result, false
          assert.deepEqual result, expectedOutput

