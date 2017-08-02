{assert} = require 'chai'

JsonResultConverter = require '../../src/json-result-converter'
arrayFixtures = require '../fixtures/legacy'
pointerFixtures = require '../fixtures/pointers'

describe 'JsonResultConverter', () ->

  describe 'regression test for migration from amandaResults to JSON pointer based results in bodies', () ->
    expectedOutput = [
      {
        "pathArray": [
          "keyWithObjectValueWrongTypeFail",
          "0"
        ],
        "value": 1,
        "state": 1
      },
      {
        "pathArray": [
          "keyWithObjectValueWrongTypeFail",
          "1"
        ],
        "value": 2,
        "state": 1
      },
      {
        "pathArray": [
          "keyWithObjectValueWrongTypeFail",
          "2"
        ],
        "value": 3,
        "state": 1
      },
      {
        "pathArray": [
          "keyWithArrayValueTypeFail",
          "key"
        ],
        "value": "val",
        "state": 1
      },
      {
        "pathArray": [
          "simpleKeyValueOKmiss"
        ],
        "state": -1,
        "message": "The ‘simpleKeyValueOKmiss’ property is required."
      },
      {
        "pathArray": [
          "keyWithObjectValueFail",
          "keyWithObjectValueOKnestedKeyMiss"
        ],
        "state": -1,
        "message": "The ‘keyWithObjectValueFail,keyWithObjectValueOKnestedKeyMiss’ property is required."
      },
      {
        "pathArray": [
          "keyWithObjectValueWrongTypeFail"
        ],
        "state": 2,
        "message": "The keyWithObjectValueWrongTypeFail property must be an object (current value is [1,2,3])."
      },
      {
        "pathArray": [
          "keyWithObjectValueWrongTypeFail",
          "keyWithObjectValueOKnestedKeyMiss"
        ],
        "state": -1,
        "message": "The ‘keyWithObjectValueWrongTypeFail,keyWithObjectValueOKnestedKeyMiss’ property is required."
      },
      {
        "pathArray": [
          "keyWithObjectValueWrongTypeFail",
          "keyWithObjectValueOKnestedKey2"
        ],
        "state": -1,
        "message": "The ‘keyWithObjectValueWrongTypeFail,keyWithObjectValueOKnestedKey2’ property is required."
      },
      {
        "pathArray": [
          "keyWithArrayValueTypeFail"
        ],
        "state": 2,
        "message": "The keyWithArrayValueTypeFail property must be an array (current value is {\"key\":\"val\"})."
      },
      {
        "pathArray": [
          "keyWithArrayValueTypeFail",
          "0"
        ],
        "state": -1,
        "message": "The ‘keyWithArrayValueTypeFail,0’ property is required."
      },
      {
        "pathArray": [
          "keyWithArrayValueTypeFail",
          "1"
        ],
        "state": -1,
        "message": "The ‘keyWithArrayValueTypeFail,1’ property is required."
      },
      {
        "pathArray": [
          "keyWithArrayValueTypeFail",
          "2"
        ],
        "state": -1,
        "message": "The ‘keyWithArrayValueTypeFail,2’ property is required."
      }
    ]

    describe 'getErrors', () ->
      describe 'when called', () ->
        it 'should have proper structure and values', () ->
          jsonResultConverter = new JsonResultConverter {
            dataReal: JSON.parse arrayFixtures.testsBody.bodyComplex.dataReal
            dataExpected: JSON.parse arrayFixtures.testsBody.bodyComplex.dataExpected
            gavelResult: arrayFixtures.testsBody.bodyComplex.gavelResult
          }
          result = jsonResultConverter.getErrors()
          result = JSON.parse JSON.stringify result
          assert.deepEqual result, expectedOutput

    describe 'getErrorsFromResults', () ->
      describe 'when called', () ->
        it 'should have proper structure and values', () ->
          jsonResultConverter = new JsonResultConverter {
            dataReal: JSON.parse pointerFixtures.testsBody.bodyComplex.dataReal
            dataExpected: JSON.parse pointerFixtures.testsBody.bodyComplex.dataExpected
            gavelResult: pointerFixtures.testsBody.bodyComplex.gavelResult
          }
          result = jsonResultConverter.getErrorsFromResults()
          result = JSON.parse JSON.stringify result
          assert.deepEqual result, expectedOutput

  describe 'regression test for migration from amandaResults to JSON pointer based results in bodies with root level primitive type mismatch', () ->
    expectedOutput =  [
      {
        pathArray: [],
        state: 2,
        message: 'The  property must be an object (current value is 1).'
      }
    ]

    describe 'getErrors', () ->
      describe 'when called', () ->
        it 'should have proper structure and values', () ->
          jsonResultConverter = new JsonResultConverter {
            dataReal: JSON.parse arrayFixtures.testsBody.bodyTypeFailObjVsPrimitiveRoot.dataReal
            dataExpected: JSON.parse arrayFixtures.testsBody.bodyTypeFailObjVsPrimitiveRoot.dataExpected
            gavelResult: arrayFixtures.testsBody.bodyTypeFailObjVsPrimitiveRoot.gavelResult
          }
          result = jsonResultConverter.getErrors()
          result = JSON.parse JSON.stringify result
          assert.deepEqual result, expectedOutput

    describe 'getErrorsFromResults', () ->
      describe 'when called', () ->
        it 'should have proper structure and values', () ->
          jsonResultConverter = new JsonResultConverter {
            dataReal: JSON.parse pointerFixtures.testsBody.bodyTypeFailObjVsPrimitiveRoot.dataReal
            dataExpected: JSON.parse pointerFixtures.testsBody.bodyTypeFailObjVsPrimitiveRoot.dataExpected
            gavelResult: pointerFixtures.testsBody.bodyTypeFailObjVsPrimitiveRoot.gavelResult
          }
          result = jsonResultConverter.getErrorsFromResults()
          result = JSON.parse JSON.stringify result
          assert.deepEqual result, expectedOutput
