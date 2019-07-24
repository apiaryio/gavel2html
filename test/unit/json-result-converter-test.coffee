{assert} = require 'chai'

JsonResultConverter = require '../../src/json-result-converter'
pointerFixtures = require '../fixtures/gavel2html-pointers'

describe 'JsonResultConverter', () ->
  describe 'regression test for migration from amandaResults to JSON pointer based results in bodies with root level primitive type mismatch', () ->
    expectedOutput =  [
      {
        pathArray: [],
        state: 2,
        message: 'The  property must be an object (current value is 1).'
      }
    ]

    describe 'getErrorsFromResults', () ->
      describe 'when called', () ->
        it 'should have proper structure and values', () ->
          jsonResultConverter = new JsonResultConverter {
            dataReal: JSON.parse pointerFixtures.testsBody.bodyTypeFailObjVsPrimitiveRoot.fieldResult.values.actual
            dataExpected: JSON.parse pointerFixtures.testsBody.bodyTypeFailObjVsPrimitiveRoot.fieldResult.values.expected
            fieldResult: pointerFixtures.testsBody.bodyTypeFailObjVsPrimitiveRoot.fieldResult
          }
          errors = jsonResultConverter.getErrorsFromResults()
          errors = JSON.parse JSON.stringify errors
          assert.deepEqual errors, expectedOutput