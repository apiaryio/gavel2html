h = {}

gavel2htmlOutputOptions =
  wrapWith: '<wrapStart>##data<wrapEnd>',
  startTag: '<startTag>',
  endTag: '</endTag>',
  missingStartTag: '<missingStartTag>',
  addedStartTag: "<addedStartTag>",
  changedStartTag: '<changedStartTag>',
  comments: true,
  commentStartTag: '<commentStartTag>',
  commentEndTag: '</commentEndTag>'

headersExpected =
  testHeader1: 'testHeader1Val'
  testHeader2: 'testHeader2Val'

headersExpectedEmpty = {}

h.headersRealOK =
  testDesc: 'when expected headers are non empty and real data are the same in real headers'
  dataReal:
    testHeader1: 'testHeader1Val'
    testHeader2: 'testHeader2Val'
  dataExpected: headersExpected
  gavelResult:
    rawData:
      length: 0
  expectedOutput: '<wrapStart><startTag>{&quot;testHeader1&quot;:&quot;testHeader1Val&quot;,&quot;testHeader2&quot;:&quot;testHeader2Val&quot;}</endTag><wrapEnd>'
  usedErrors: []


h.headersRealOKMore =
  testDesc: 'when expected headers are non empty and real data extends it'
  dataReal:
    testHeader1: 'testHeader1Val'
    testHeader2: 'testHeader2Val'
    testHeader3: 'testHEader3Val'
  dataExpected: headersExpected
  gavelResult:{"rawData":{"length":0},"validator":"HeadersJsonExample"}
  expectedOutput: '<wrapStart><startTag>testHeader1: testHeader1Val</endTag><startTag>testHeader2: testHeader2Val</endTag><addedStartTag>testHeader3: testHEader3Val</endTag><wrapEnd>'
  usedErrors: []

h.headersRealOKKeyCase =
  testDesc: 'when expected headers are non empty and real data are the same except cAsE of key'
  dataReal:
    testHEAder1: 'testHeader1Val'
    testHeader2: 'testHeader2Val'
  dataExpected: headersExpected
  gavelResult:{"rawData":{"length":0},"validator":"HeadersJsonExample"}
  expectedOutput: '<wrapStart><startTag>testHEAder1: testHeader1Val</endTag><startTag>testHeader2: testHeader2Val</endTag><wrapEnd>'
  usedErrors: []

h.headersRealFailValueCase =
  testDesc: 'when expected headers are non empty and real data are the same except cAsE of value'
  dataReal:
    testHeader1: 'tEstHeader1Val'
    testHeader2: 'testHEader2Val'
  dataExpected: headersExpected
  gavelResult:{
    "rawData":{
      "0":{"property":["testheader2"],"propertyValue":"'testHEader2Val'","attributeName":"enum","attributeValue":["'testHeader2Val'"],"message":"Value of the ‘testheader2’ must be 'testHeader2Val'.","validator":"enum","validatorName":"enum","validatorValue":["'testHeader2Val'"]},
      "1":{"property":["testheader1"],"propertyValue":"'tEstHeader1Val'","attributeName":"enum","attributeValue":["'testHeader1Val'"],"message":"Value of the ‘testheader1’ must be 'testHeader1Val'.","validator":"enum","validatorName":"enum","validatorValue":["'testHeader1Val'"]},
      "length":2
    },"validator":"HeadersJsonExample"}
  expectedOutput: "<wrapStart><changedStartTag>testHeader1: tEstHeader1Val</endTag> <commentStartTag>Value of the ‘testheader1’ must be 'testHeader1Val'.</commentEndTag><changedStartTag>testHeader2: testHEader2Val</endTag> <commentStartTag>Value of the ‘testheader2’ must be 'testHeader2Val'.</commentEndTag><wrapEnd>"
  usedErrors: []

h.headersRealFailMiss =
  testDesc: 'when expected headers are non empty and key missing in real data'
  dataReal:
    testHeader1: 'testHeader1Val'
  dataExpected: headersExpected
  gavelResult: {
    "rawData":{
      "0":{"property":["testheader2"],"propertyValue":null,"attributeName":"enum","attributeValue":["'testHeader2Val'"],"message":"Value of the ‘testheader2’ must be 'testHeader2Val'.","validator":"enum","validatorName":"enum","validatorValue":["'testHeader2Val'"]},
      "1":{"property":["testheader2"],"propertyValue":null,"attributeName":"required","attributeValue":true,"message":"The ‘testheader2’ property is required.","validator":"required","validatorName":"required","validatorValue":true},
      "length":2
    },"validator":"HeadersJsonExample"}
  expectedOutput: "<wrapStart><startTag>testHeader1: testHeader1Val</endTag><missingStartTag>testHeader2: testHeader2Val</endTag> <commentStartTag>The ‘testheader2’ property is required. | Value of the ‘testheader2’ must be 'testHeader2Val'.</commentEndTag><wrapEnd>"
  usedErrors: []

h.headersRealFailChanged =
  testDesc: 'when expected headers are non empty and data changed in real data'
  dataReal:
    testHeader1: 'testHeader1Val'
    testHeader2: 'testHEader2ValChanged'
  dataExpected: headersExpected
  gavelResult: {
    "rawData":{
      "0":{"property":["testheader2"],"propertyValue":"'testHEader2ValChanged'","attributeName":"enum","attributeValue":["'testHeader2Val'"],"message":"Value of the ‘testheader2’ must be 'testHeader2Val'.","validator":"enum","validatorName":"enum","validatorValue":["'testHeader2Val'"]},
      "length":1
    },"validator":"HeadersJsonExample"}
  expectedOutput: "<wrapStart><startTag>testHeader1: testHeader1Val</endTag><changedStartTag>testHeader2: testHEader2ValChanged</endTag> <commentStartTag>Value of the ‘testheader2’ must be 'testHeader2Val'.</commentEndTag><wrapEnd>"

  usedErrors: []

h.headersRealFailEmpty =
  testDesc: 'when expected headers are non empty and real data are empty'
  dataReal: {}
  dataExpected:
    testHeader2: 'testHeader2Val'
  gavelResult: {
    "rawData":{
      "0":{"property":["testheader2"],"propertyValue":null,"attributeName":"enum","attributeValue":["'testHeader2Val'"],"message":"Value of the ‘testheader2’ must be 'testHeader2Val'.","validator":"enum","validatorName":"enum","validatorValue":["'testHeader2Val'"]},
      "1":{"property":["testheader2"],"propertyValue":null,"attributeName":"required","attributeValue":true,"message":"The ‘testheader2’ property is required.","validator":"required","validatorName":"required","validatorValue":true},
      "length":2
    },"validator":"HeadersJsonExample"}
  expectedOutput: "<wrapStart><missingStartTag>testHeader2: testHeader2Val</endTag> <commentStartTag>The ‘testheader2’ property is required. | Value of the ‘testheader2’ must be 'testHeader2Val'.</commentEndTag><wrapEnd>"
  usedErrors: []

h.headersRealOKNoEmpty =
  testDesc: 'when expected headers are empty and real data are not empty'
  dataReal:
    testHeader1: 'testHeader1Val'
    testHeader2: 'testHeader2Val'
  dataExpected: {}
  gavelResult: {"rawData":{"length":0},"validator":"HeadersJsonExample"}
  expectedOutput: '<wrapStart><addedStartTag>testHeader1: testHeader1Val</endTag><addedStartTag>testHeader2: testHeader2Val</endTag><wrapEnd>'
  usedErrors: []


#
# Body
#

b  = {}

b.bodyTypeFailFailIntVsStringRoot =
  testDesc: 'when expected body is integer and real is string'
  dataReal: '1'
  dataExpected: 1
  schema: {
    "type":"number",
    "$schema": "http://json-schema.org/draft-03/schema",
    "required":true
  }
  gavelResult: {
    "rawData":{
      "0":{"property":null,"propertyValue":"1","attributeName":"type","attributeValue":"number","message":"The undefined property must be a number (current value is \"1\").","validator":"type","validatorName":"type","validatorValue":"number"},
      "length":1
    },"validator":"JsonSchema"}
  expectedOutput: '<wrapStart><changedStartTag>1</endTag> <commentStartTag>The property must be a number (current value is "1").</commentEndTag><wrapEnd>'
  usedErrors: ['']


b.bodyTypeFailStringVsIntRoot =
  testDesc: 'when expected body is string and real is integer'
  dataReal: 1
  dataExpected: "1"
  schema: {
    "type":"string",
    "$schema": "http://json-schema.org/draft-03/schema",
    "required":true
  }
  gavelResult: {
    "rawData":{
      "0":{"property":null,"propertyValue":1,"attributeName":"type","attributeValue":"string","message":"The undefined property must be a string (current value is 1).","validator":"type","validatorName":"type","validatorValue":"string"},
      "length":1
    },"validator":"JsonSchema"}
  expectedOutput: '<wrapStart><changedStartTag>1</endTag> <commentStartTag>The property must be a string (current value is 1).</commentEndTag><wrapEnd>'
  usedErrors: ['']


b.bodyTypeFailPrimitiveVsObjRoot =
  testDesc: 'when expected body is primitive and real is object'
  dataReal: JSON.stringify {'key': 'val'}
  dataExpected: "1"
  schema: {
    "type":"string",
    "$schema": "http://json-schema.org/draft-03/schema",
    "required":true
  }
  gavelResult: {
    "rawData":{
      "0":{"property":null,"propertyValue":{"key":"val"},"attributeName":"type","attributeValue":"string","message":"The undefined property must be a string (current value is {\"key\":\"val\"}).","validator":"type","validatorName":"type","validatorValue":"string"},
      "length":1
    },"validator":"JsonSchema"}
  expectedOutput: '''
         <wrapStart>{
         <addedStartTag>&quot;key&quot;: &quot;val&quot;</endTag>
         }
         <wrapEnd>
  '''
  usedErrors: []


b.bodyTypeFailObjVsPrimitiveRoot =
  testDesc: 'when expected body is object and real is primitive'
  dataReal:  "1"
  dataExpected: JSON.stringify {"key": "val"}
  schema: {
    "type":"object",
    "$schema": "http://json-schema.org/draft-03/schema",
    "required":true
  }
  gavelResult: {
    "rawData":{
      "0":{"property":[],"propertyValue":1,"attributeName":"type","attributeValue":"object","message":"The  property must be an object (current value is 1).","validator":"type","validatorName":"type","validatorValue":"object"},
      "length":1
    },"validator":"JsonSchema"}
  expectedOutput: '<wrapStart><changedStartTag>1</endTag> <commentStartTag>The  property must be an object (current value is 1).</commentEndTag><wrapEnd>'
  usedErrors: [""]



b.bodyTypeFailObjVsArrayRoot =
  testDesc: 'when expected body is object and real is array'
  dataReal:  JSON.stringify [1,2,3]
  dataExpected: JSON.stringify {"key": "val"}
  schema: {
    "type":"object",
    "$schema": "http://json-schema.org/draft-03/schema",
    "required":true
  }
  gavelResult: {"rawData":{"0":{"property":[],"propertyValue":[1,2,3],"attributeName":"type","attributeValue":"object","message":"The  property must be an object (current value is [1,2,3]).","validator":"type","validatorName":"type","validatorValue":"object"},"length":1},"validator":"JsonSchema"}
  expectedOutput: '''
                  <wrapStart>[
                  <addedStartTag>1</endTag>,
                  <addedStartTag>2</endTag>,
                  <addedStartTag>3</endTag>
                  ]
                  <wrapEnd>
                  '''
  usedErrors: []

b.bodyTypeFailObjVsArrayRootNoSchema =
  testDesc: 'when expected body is object and real is array  (no schema)'
  dataReal:  JSON.stringify [1,2,3]
  dataExpected: JSON.stringify {"key": "val"}
  gavelResult: {
    "rawData":{
      "0":{"property":[],"propertyValue":[1,2,3],"attributeName":"type","attributeValue":"object","message":"The  property must be an object (current value is [1,2,3]).","validator":"type","validatorName":"type","validatorValue":"object"},
      "1":{"property":["key"],"propertyValue":null,"attributeName":"required","attributeValue":true,"message":"The ‘key’ property is required.","validator":"required","validatorName":"required","validatorValue":true},
      "length":2
    },"validator":"JsonExample","expectedType":"application/json","realType":"application/json","results":[{"message":"The  property must be an object (current value is [1,2,3]).","severity":"error","pointer":"/"},{"message":"The ‘key’ property is required.","severity":"error","pointer":"/key"}]}
  expectedOutput: '''
                  <wrapStart>[
                  <addedStartTag>1</endTag>,
                  <addedStartTag>2</endTag>,
                  <addedStartTag>3</endTag>
                  ]
                  <wrapEnd>
                  '''
  usedErrors: []

b.bodyTypeFailArrayVsObjRoot =
  testDesc: 'when expected body is array and real is object'
  dataReal:  JSON.stringify {"key": "val"}
  dataExpected: JSON.stringify [1,2,3]
  schema: {
    "type":"array",
    "$schema": "http://json-schema.org/draft-03/schema",
    "required":true
  }
  gavelResult: {"rawData":{"0":{"property":[],"propertyValue":{"key":"val"},"attributeName":"type","attributeValue":"array","message":"The  property must be an array (current value is {\"key\":\"val\"}).","validator":"type","validatorName":"type","validatorValue":"array"},"length":1},"validator":"JsonSchema"}
  expectedOutput: '''
                  <wrapStart>{
                  <addedStartTag>&quot;key&quot;: &quot;val&quot;</endTag>
                  }
                  <wrapEnd>
                  '''
  usedErrors: []

b.bodyTypeFailArrayVsObjRootNoSchema =
  testDesc: 'when expected body is array and real is object (no schema)'
  dataReal:  JSON.stringify {"key": "val"}
  dataExpected: JSON.stringify [1,2,3]
  gavelResult: {
    "rawData":{
      "0":{"property":[],"propertyValue":{"key":"val"},"attributeName":"type","attributeValue":"array","message":"The  property must be an array (current value is {\"key\":\"val\"}).","validator":"type","validatorName":"type","validatorValue":"array"},
      "1":{"property":["0"],"propertyValue":null,"attributeName":"required","attributeValue":true,"message":"The ‘0’ property is required.","validator":"required","validatorName":"required","validatorValue":true},
      "2":{"property":["1"],"propertyValue":null,"attributeName":"required","attributeValue":true,"message":"The ‘1’ property is required.","validator":"required","validatorName":"required","validatorValue":true},
      "3":{"property":["2"],"propertyValue":null,"attributeName":"required","attributeValue":true,"message":"The ‘2’ property is required.","validator":"required","validatorName":"required","validatorValue":true},
      "length":4
    },"validator":"JsonExample","expectedType":"application/json","realType":"application/json","results":[{"message":"The  property must be an array (current value is {\"key\":\"val\"}).","severity":"error","pointer":"/"},{"message":"The ‘0’ property is required.","severity":"error","pointer":"/0"},{"message":"The ‘1’ property is required.","severity":"error","pointer":"/1"},{"message":"The ‘2’ property is required.","severity":"error","pointer":"/2"}]}
  expectedOutput: '''
                  <wrapStart>{
                  <addedStartTag>&quot;key&quot;: &quot;val&quot;</endTag>
                  }
                  <wrapEnd>
                  '''
  usedErrors: []

bodyComplexExpected = {
  "simpleKeyValueOK": "simpleKeyValueOK",
  "simpleKeyValueNumberOK": 1,
  "simpleKeyValueOKmiss": "simpleKeyValueOKmiss",
  "keyWithObjectValueOK": {
    "keyWithObjectValueOKnestedKey": "keyWithObjectValueOKnestedKey",
    "keyWithObjectValueOKnestedKey2": "keyWithObjectValueOKnestedKey2"
  },
  "keyWithObjectValueFail": {
    "keyWithObjectValueOKnestedKeyMiss": "keyWithObjectValueOKnestedKeyMiss",
    "keyWithObjectValueOKnestedKey2": "keyWithObjectValueOKnestedKey2"
  },
  "keyWithObjectValueWrongTypeFail": {
    "keyWithObjectValueOKnestedKeyMiss": "keyWithObjectValueOKnestedKeyMiss",
    "keyWithObjectValueOKnestedKey2": "keyWithObjectValueOKnestedKey2"
  },
  "keyWithArrayValueOK": [1,2,3],
  "keyWithArrayValueOK2": [1,2,3],
  "keyWithArrayValueTypeFail": [1,2,3]
}


bodyComplexReal = {
  "simpleKeyValueOK": "simpleKeyValueOK",
  "simpleKeyValueNumberOK": 1,
  "keyWithObjectValueOK": {
    "keyWithObjectValueOKnestedKey": "keyWithObjectValueOKnestedKey",
    "keyWithObjectValueOKnestedKey2": "keyWithObjectValueOKnestedKey2",
  },
  "keyWithObjectValueFail": {
    "keyWithObjectValueOKnestedKey2": "keyWithObjectValueOKnestedKey2"
  },
  "keyWithObjectValueWrongTypeFail": [1,2,3],
  "keyWithArrayValueOK": [1,2,3],
  "keyWithArrayValueOK2": [4,5,6],
  "keyWithArrayValueTypeFail": {"key": "val"}
}

b.bodyComplex =
  testDesc: 'complex body test'
  dataReal:  JSON.stringify bodyComplexReal
  dataExpected: JSON.stringify bodyComplexExpected
  gavelResult:{
    "rawData":{
      "0":{"property":["simpleKeyValueOKmiss"],"propertyValue":null,"attributeName":"required","attributeValue":true,"message":"The ‘simpleKeyValueOKmiss’ property is required.","validator":"required","validatorName":"required","validatorValue":true},
      "1":{"property":["keyWithObjectValueFail","keyWithObjectValueOKnestedKeyMiss"],"propertyValue":null,"attributeName":"required","attributeValue":true,"message":"The ‘keyWithObjectValueFail,keyWithObjectValueOKnestedKeyMiss’ property is required.","validator":"required","validatorName":"required","validatorValue":true},
      "2":{"property":["keyWithObjectValueWrongTypeFail"],"propertyValue":[1,2,3],"attributeName":"type","attributeValue":"object","message":"The keyWithObjectValueWrongTypeFail property must be an object (current value is [1,2,3]).","validator":"type","validatorName":"type","validatorValue":"object"},
      "3":{"property":["keyWithObjectValueWrongTypeFail","keyWithObjectValueOKnestedKeyMiss"],"propertyValue":null,"attributeName":"required","attributeValue":true,"message":"The ‘keyWithObjectValueWrongTypeFail,keyWithObjectValueOKnestedKeyMiss’ property is required.","validator":"required","validatorName":"required","validatorValue":true},
      "4":{"property":["keyWithObjectValueWrongTypeFail","keyWithObjectValueOKnestedKey2"],"propertyValue":null,"attributeName":"required","attributeValue":true,"message":"The ‘keyWithObjectValueWrongTypeFail,keyWithObjectValueOKnestedKey2’ property is required.","validator":"required","validatorName":"required","validatorValue":true},
      "5":{"property":["keyWithArrayValueTypeFail"],"propertyValue":{"key":"val"},"attributeName":"type","attributeValue":"array","message":"The keyWithArrayValueTypeFail property must be an array (current value is {\"key\":\"val\"}).","validator":"type","validatorName":"type","validatorValue":"array"},
      "6":{"property":["keyWithArrayValueTypeFail","0"],"propertyValue":null,"attributeName":"required","attributeValue":true,"message":"The ‘keyWithArrayValueTypeFail,0’ property is required.","validator":"required","validatorName":"required","validatorValue":true},
      "7":{"property":["keyWithArrayValueTypeFail","1"],"propertyValue":null,"attributeName":"required","attributeValue":true,"message":"The ‘keyWithArrayValueTypeFail,1’ property is required.","validator":"required","validatorName":"required","validatorValue":true},
      "8":{"property":["keyWithArrayValueTypeFail","2"],"propertyValue":null,"attributeName":"required","attributeValue":true,"message":"The ‘keyWithArrayValueTypeFail,2’ property is required.","validator":"required","validatorName":"required","validatorValue":true},
      "length":9
    },"validator":"JsonExample"}
  expectedOutput: '''
                  <wrapStart>{
                  <startTag>&quot;simpleKeyValueOK&quot;: &quot;simpleKeyValueOK&quot;</endTag>
                  <startTag>&quot;simpleKeyValueNumberOK&quot;: 1</endTag>
                  <startTag>&quot;keyWithObjectValueOK&quot;: {</endTag>
                  <startTag>  &quot;keyWithObjectValueOKnestedKey&quot;: &quot;keyWithObjectValueOKnestedKey&quot;</endTag>
                  <startTag>  &quot;keyWithObjectValueOKnestedKey2&quot;: &quot;keyWithObjectValueOKnestedKey2&quot;</endTag>
                    }
                  <startTag>&quot;keyWithObjectValueFail&quot;: {</endTag>
                  <startTag>  &quot;keyWithObjectValueOKnestedKey2&quot;: &quot;keyWithObjectValueOKnestedKey2&quot;</endTag>
                    }
                  <changedStartTag>&quot;keyWithObjectValueWrongTypeFail&quot;: [</endTag> <commentStartTag>The keyWithObjectValueWrongTypeFail property must be an object (current value is [1,2,3]).</commentEndTag>
                  <addedStartTag>  1</endTag>,
                  <addedStartTag>  2</endTag>,
                  <addedStartTag>  3</endTag>
                    ],
                  <startTag>&quot;keyWithArrayValueOK&quot;: [</endTag>
                  <startTag>  1</endTag>,
                  <startTag>  2</endTag>,
                  <startTag>  3</endTag>
                    ],
                  <startTag>&quot;keyWithArrayValueOK2&quot;: [</endTag>
                  <startTag>  4</endTag>,
                  <startTag>  5</endTag>,
                  <startTag>  6</endTag>
                    ],
                  <changedStartTag>&quot;keyWithArrayValueTypeFail&quot;: {</endTag> <commentStartTag>The keyWithArrayValueTypeFail property must be an array (current value is {"key":"val"}).</commentEndTag>
                  <addedStartTag>  &quot;key&quot;: &quot;val&quot;</endTag>
                    }
                  }
                  <wrapEnd>
                  '''
  usedErrors: [
    "/keyWithObjectValueWrongTypeFail",
    "/keyWithArrayValueTypeFail"
    ]

b.bodyOkWithNestedObjectsInArrays =
  testDesc: 'when expected and real body are the same and contains array of objects'
  dataReal: JSON.stringify {
    "login": "true"
    "results": [
      {"otrkey": "20_jahre_feste", "key2": "value2"}
      {"otrkey": "30_jahre_feste", "key2": "value2"}
      {"otrkey": "40_jahre_feste", "key2": "value2"}
    ]
  }
  dataExpected: JSON.stringify {
    "login": "true"
    "results": [
      {"otrkey": "20_jahre_feste", "key2": "value2"}
      {"otrkey": "30_jahre_feste", "key2": "value2"}
      {"otrkey": "40_jahre_feste", "key2": "value2"}
    ]
  }
  gavelResult: {
    "rawData":{
      "length":0
    },"validator":"JsonExample"}
  expectedOutput: """
<wrapStart>{
<startTag>&quot;login&quot;: &quot;true&quot;</endTag>
<startTag>&quot;results&quot;: [</endTag>
<startTag>    {</endTag>
<startTag>    &quot;otrkey&quot;: &quot;20_jahre_feste&quot;</endTag>
<startTag>    &quot;key2&quot;: &quot;value2&quot;</endTag>
  },
<startTag>    {</endTag>
<startTag>    &quot;otrkey&quot;: &quot;30_jahre_feste&quot;</endTag>
<startTag>    &quot;key2&quot;: &quot;value2&quot;</endTag>
  },
<startTag>    {</endTag>
<startTag>    &quot;otrkey&quot;: &quot;40_jahre_feste&quot;</endTag>
<startTag>    &quot;key2&quot;: &quot;value2&quot;</endTag>
    }
  ]
}
<wrapEnd>
  """
  usedErrors: []

b.bodyOkWithNestedStringsInArrays =
  testDesc: 'when expected and real body are the same and contains array of strings'
  dataReal: JSON.stringify {
    "login": "true"
    "results": [
      "BooBoo"
      "MrauMrau"
      "BauBau"
    ]
  }
  dataExpected: JSON.stringify {
    "login": "true"
    "results": [
      "BooBoo"
      "MrauMrau"
      "BauBau"
    ]
  }
  gavelResult: {
    "rawData":{
      "length":0
    },"validator":"JsonExample"}
  expectedOutput: """
  <wrapStart>{
  <startTag>&quot;login&quot;: &quot;true&quot;</endTag>
  <startTag>&quot;results&quot;: [</endTag>
  <startTag>  &quot;BooBoo&quot;</endTag>,
  <startTag>  &quot;MrauMrau&quot;</endTag>,
  <startTag>  &quot;BauBau&quot;</endTag>
    ]
  }
  <wrapEnd>
  """
  usedErrors: []

b.bodyOkWithNestedArraysInArrays =
  testDesc: 'when expected and real body are the same and contains array of arrays'
  dataReal: JSON.stringify {
    "login": "true"
    "results": [
      [1,2,3]
      [1,2,3]
      [1,2,3]
    ]
  }
  dataExpected: JSON.stringify {
    "login": "true"
    "results": [
      [1,2,3]
      [1,2,3]
      [1,2,3]
    ]
  }
  gavelResult: {
    "rawData":{
      "length":0
    },"validator":"JsonExample"}
  expectedOutput: """
<wrapStart>{
<startTag>&quot;login&quot;: &quot;true&quot;</endTag>
<startTag>&quot;results&quot;: [</endTag>
<startTag>    [</endTag>
<startTag>    1</endTag>,
<startTag>    2</endTag>,
<startTag>    3</endTag>
  ],
<startTag>    [</endTag>
<startTag>    1</endTag>,
<startTag>    2</endTag>,
<startTag>    3</endTag>
  ],
<startTag>    [</endTag>
<startTag>    1</endTag>,
<startTag>    2</endTag>,
<startTag>    3</endTag>
    ]
  ]
}
<wrapEnd>
  """
  usedErrors: []

module.exports = {
  gavel2htmlOutputOptions
  testsHeaders: h
  testsBody: b
}




