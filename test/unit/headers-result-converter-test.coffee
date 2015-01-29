{assert} = require 'chai'

HeadersResultConverter = require '../../src/headers-result-converter'
arrayFixtures = require '../fixtures/gavel2html-legacy'
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

    describe 'getLinesFromAmandaResults', () ->
      describe 'when called', () ->
        it 'should have proper structure and values', () ->
          jsonResultConverter = new HeadersResultConverter {
            dataReal: arrayFixtures.testsHeaders.headersRealFailValueCase.dataReal
            dataExpected: arrayFixtures.testsHeaders.headersRealFailValueCase.dataExpected
            gavelResult: arrayFixtures.testsHeaders.headersRealFailValueCase.gavelResult
          }
          result = jsonResultConverter.getLinesFromAmandaResults()
          result = JSON.parse JSON.stringify result
          assert.deepEqual result, expectedOutput

    describe.skip 'getLinesFromResults', () ->
      describe 'when called', () ->
        it 'should have proper structure and values', () ->
          jsonResultConverter = new HeadersResultConverter {
            dataReal: pointerFixtures.testsHeaders.headersRealFailValueCase.dataReal
            dataExpected: pointerFixtures.testsHeaders.headersRealFailValueCase.dataExpected
            gavelResult: pointerFixtures.testsHeaders.headersRealFailValueCase.gavelResult
          }
          result = jsonResultConverter.getLinesFromResults()
          result = JSON.parse JSON.stringify result
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

    describe 'getLinesFromAmandaResults', () ->
      describe 'when called', () ->
        it 'should have proper structure and values', () ->
          jsonResultConverter = new HeadersResultConverter {
            dataReal: arrayFixtures.testsHeaders.headersRealFailChanged.dataReal
            dataExpected: arrayFixtures.testsHeaders.headersRealFailChanged.dataExpected
            gavelResult: arrayFixtures.testsHeaders.headersRealFailChanged.gavelResult
          }
          result = jsonResultConverter.getLinesFromAmandaResults()
          result = JSON.parse JSON.stringify result
          assert.deepEqual result, expectedOutput

    describe.skip 'getLinesFromResults', () ->
      describe 'when called', () ->
        it 'should have proper structure and values', () ->
          jsonResultConverter = new HeadersResultConverter {
            dataReal: pointerFixtures.testsHeaders.headersRealFailChanged.dataReal
            dataExpected: pointerFixtures.testsHeaders.headersRealFailChanged.dataExpected
            gavelResult: pointerFixtures.testsHeaders.headersRealFailChanged.gavelResult
          }
          result = jsonResultConverter.getLinesFromResults()
          result = JSON.parse JSON.stringify result
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

    describe 'getLinesFromAmandaResults', () ->
      describe 'when called', () ->
        it 'should have proper structure and values', () ->
          jsonResultConverter = new HeadersResultConverter {
            dataReal: arrayFixtures.testsHeaders.headersRealFailMiss.dataReal
            dataExpected: arrayFixtures.testsHeaders.headersRealFailMiss.dataExpected
            gavelResult: arrayFixtures.testsHeaders.headersRealFailMiss.gavelResult
          }
          result = jsonResultConverter.getLinesFromAmandaResults()
          result = JSON.parse JSON.stringify result
          assert.deepEqual result, expectedOutput

    describe.skip 'getLinesFromResults', () ->
      describe 'when called', () ->
        it 'should have proper structure and values', () ->
          jsonResultConverter = new HeadersResultConverter {
            dataReal: pointerFixtures.testsHeaders.headersRealFailMiss.dataReal
            dataExpected: pointerFixtures.testsHeaders.headersRealFailMiss.dataExpected
            gavelResult: pointerFixtures.testsHeaders.headersRealFailMiss.gavelResult
          }
          result = jsonResultConverter.getLinesFromResults()
          result = JSON.parse JSON.stringify result
          assert.deepEqual result, expectedOutput

