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
  # dataReal:
  #   testHeader1: 'testHeader1Val'
  #   testHeader2: 'testHeader2Val'
  # dataExpected: headersExpected
  # fieldName: 'headers'
  fieldResult: {
    "kind": "json"
    "values": {
      "expected": headersExpected
      "actual": {
        testHeader1: 'testHeader1Val'
        testHeader2: 'testHeader2Val'
      }
    }
    "errors": []
  }
  expectedOutput: '<wrapStart><startTag>{&quot;testHeader1&quot;:&quot;testHeader1Val&quot;,&quot;testHeader2&quot;:&quot;testHeader2Val&quot;}</endTag><wrapEnd>'
  usedErrors: []


h.headersRealOKMore =
  testDesc: 'when expected headers are non empty and real data extends it'
  # dataReal:
  #   testHeader1: 'testHeader1Val'
  #   testHeader2: 'testHeader2Val'
  #   testHeader3: 'testHEader3Val'
  # dataExpected: headersExpected
  fieldName: 'headers'
  fieldResult:{
    "kind": "json",
    "values": {
      "expected": headersExpected
      "actual": {
        "testHeader1": 'testHeader1Val'
        "testHeader2": 'testHeader2Val'
        "testHeader3": 'testHEader3Val'
      }
    }
    "errors": [],
  }
  expectedOutput: '<wrapStart><startTag>testHeader1: testHeader1Val</endTag><startTag>testHeader2: testHeader2Val</endTag><addedStartTag>testHeader3: testHEader3Val</endTag><wrapEnd>'
  usedErrors: []

h.headersRealOKKeyCase =
  testDesc: 'when expected headers are non empty and real data are the same except cAsE of key'
  # dataReal:
  #   testHEAder1: 'testHeader1Val'
  #   testHeader2: 'testHeader2Val'
  # dataExpected: headersExpected
  fieldName: 'headers',
  fieldResult: {
    "kind": "json",
    "values": {
      "expected": headersExpected
      "actual": {
        "testHEAder1": 'testHeader1Val'
        "testHeader2": 'testHeader2Val'
      },
    },
    "errors": [],
  }
  expectedOutput: '<wrapStart><startTag>testHEAder1: testHeader1Val</endTag><startTag>testHeader2: testHeader2Val</endTag><wrapEnd>'
  usedErrors: []

h.headersRealFailValueCase =
  testDesc: 'when expected headers are non empty and real data are the same except cAsE of value'
  # dataReal:
  # dataExpected: headersExpected
  fieldName: 'headers'
  fieldResult: {
    "values": {
      "expected": headersExpected
      "actual": {
        "testHeader1": 'tEstHeader1Val'
        "testHeader2": 'testHEader2Val'
      }
    },
    "errors": [
      {
        "message": "Value of the ‘testheader2’ must be 'testHeader2Val'.",
        "location": {
          "pointer": "/testheader2"
        }
      },
      {
        "message": "Value of the ‘testheader1’ must be 'testHeader1Val'.",
        "location": {
          "pointer": "/testheader1"
        }
      }
    ],
    "kind": "json"
  }
  expectedOutput: "<wrapStart><changedStartTag>testHeader1: tEstHeader1Val</endTag><changedStartTag>testHeader2: testHEader2Val</endTag><wrapEnd>"
  usedErrors: []

h.headersRealFailMiss =
  testDesc: 'when expected headers are non empty and key missing in real data'
  # dataReal:
  #   testHeader1: 'testHeader1Val'
  # dataExpected: headersExpected
  fieldName: 'headers'
  fieldResult: {
    "values": {
      "expected": headersExpected
      "actual": {
        "testHeader1": 'testHeader1Val'
      }
    }
    "errors": [
      {
        "message": "Value of the ‘testheader2’ must be 'testHeader2Val'.",
        "location": {
          "pointer": "/testheader2"
        }
      },
      {
        "message": "The ‘testheader2’ property is required.",
        "location": {
          "pointer": "/testheader2"
        }
      }
    ],
    "kind": "json"
  }
  expectedOutput: "<wrapStart><startTag>testHeader1: testHeader1Val</endTag><missingStartTag>testHeader2: testHeader2Val</endTag><wrapEnd>"
  usedErrors: []

h.headersRealFailChanged =
  testDesc: 'when expected headers are non empty and data changed in real data'
  # dataReal:
  #   testHeader1: 'testHeader1Val'
  #   testHeader2: 'testHEader2ValChanged'
  # dataExpected: headersExpected
  fieldName: 'headers'
  fieldResult: {
    "values": {
      "expected": headersExpected
      "actual": {
        "testHeader1": 'testHeader1Val'
        "testHeader2": 'testHEader2ValChanged'
      }
    }
    "errors": [
      {
        "message": "Value of the ‘testheader2’ must be 'testHeader2Val'.",
        "location": {
          "pointer": "/testheader2"
        }
      }
    ],
    "kind": "json"
  }
  expectedOutput: "<wrapStart><startTag>testHeader1: testHeader1Val</endTag><changedStartTag>testHeader2: testHEader2ValChanged</endTag><wrapEnd>"

  usedErrors: []

h.headersRealFailEmpty =
  testDesc: 'when expected headers are non empty and real data are empty'
  # dataReal: {}
  # dataExpected:
  #   testHeader2: 'testHeader2Val'
  fieldName: 'headers'
  fieldResult: {
    "values": {
      "expected": {
        "testHeader2": 'testHeader2Val'
      }
      "actual": {}
    },
    "errors": [
      {
        "message": "Value of the ‘testheader2’ must be 'testHeader2Val'.",
        "location": {
          "pointer": "/testheader2"
        }
      },
      {
        "message": "The ‘testheader2’ property is required.",
        "location": {
          "pointer": "/testheader2"
        }
      }
    ],
    "kind": "json"
  }
  expectedOutput: "<wrapStart><missingStartTag>testHeader2: testHeader2Val</endTag><wrapEnd>"
  usedErrors: []

h.headersRealOKNoEmpty =
  testDesc: 'when expected headers are empty and real data are not empty'
  # dataReal:
  #   testHeader1: 'testHeader1Val'
  #   testHeader2: 'testHeader2Val'
  # dataExpected: {}
  fieldName: 'headers'
  fieldResult: {
    "values": {
      "expected": {}
      "actual": {
        testHeader1: 'testHeader1Val'
        testHeader2: 'testHeader2Val'
      }
    },
    "errors": [],
    "kind": "json"
  }
  expectedOutput: '<wrapStart><addedStartTag>testHeader1: testHeader1Val</endTag><addedStartTag>testHeader2: testHeader2Val</endTag><wrapEnd>'
  usedErrors: []

headersWrapHeaderKeys =
  testHeader1: '<b>testHeader1Val</b>'
  testHeader2: '<i>testHeader2Val</i>'

h.headersWrapKeys =
  outputOptions:
    wrapWith: '<wrapStart>##data<wrapEnd>'
    startTag: '<startTag>'
    endTag: '</endTag>'
    jsonKeyStartTag: '<keyStart>'
    jsonKeyEndTag: '</keyEnd>'
    missingStartTag: '<missingStartTag>'
    addedStartTag: "<addedStartTag>"
    changedStartTag: '<changedStartTag>'
    comments: false

  testDesc: 'when expected headers are non empty and real data are the same in real headers and I want to wrap header keys'
  # dataReal: headersWrapHeaderKeys
  # dataExpected: headersWrapHeaderKeys
  fieldName: 'headers'
  fieldResult: {
    "values": {
      "expected": headersWrapHeaderKeys,
      "actual": headersWrapHeaderKeys
    }
    "errors": []
    "kind": "json"
  }
  expectedOutput: """
  <wrapStart>\
  <startTag><keyStart>testHeader1</keyEnd>: &lt;b&gt;testHeader1Val&lt;/b&gt;</endTag>\
  <startTag><keyStart>testHeader2</keyEnd>: &lt;i&gt;testHeader2Val&lt;/i&gt;</endTag>\
  <wrapEnd>"""
  usedErrors: []


#
# Body
#

b  = {}

b.bodyTypeFailFailIntVsStringRoot =
  testDesc: 'when expected body is integer and real is string'
  # dataReal: '1'
  # dataExpected: 1
  schema: {
    "type":"number",
    "$schema": "http://json-schema.org/draft-03/schema",
    "required":true
  }
  fieldName: "body"
  fieldResult: {
    "values": {
      "expected": 1
      "actual": '1'
    }
    "errors": [
      {
        "message": "The undefined property must be a number (current value is \"1\").",
        "location": {
          "pointer": ""
        }
      }
    ],
    "kind": "json"
  }
  expectedOutput: '<wrapStart><changedStartTag>1</endTag> <commentStartTag>The property must be a number (current value is "1").</commentEndTag><wrapEnd>'
  usedErrors: ['']


b.bodyTypeFailStringVsIntRoot =
  testDesc: 'when expected body is string and real is integer'
  # dataReal: 1
  # dataExpected: "1"
  schema: {
    "type":"string",
    "$schema": "http://json-schema.org/draft-03/schema",
    "required":true
  }
  fieldName: "body"
  fieldResult: {
    "values": {
      "expected": '1'
      "actual": 1
    }
    "errors": [
      {
        "message": "The undefined property must be a string (current value is 1).",
        "location": {
          "pointer": ""
        }
      }
    ],
    "kind": "json"
  }
  expectedOutput: '<wrapStart><changedStartTag>1</endTag> <commentStartTag>The property must be a string (current value is 1).</commentEndTag><wrapEnd>'
  usedErrors: ['']


b.bodyTypeFailPrimitiveVsObjRoot =
  testDesc: 'when expected body is primitive and real is object'
  # dataReal: JSON.stringify {'key': 'val'}
  # dataExpected: "1"
  schema: {
    "type":"string",
    "$schema": "http://json-schema.org/draft-03/schema",
    "required":true
  }
  fieldName: "body"
  fieldResult: {
    "values": {
      "expected": "1"
      "actual": JSON.stringify {'key': 'val'}
    }
    "errors": [
      {
        "message": "The undefined property must be a string (current value is {\"key\":\"val\"}).",
        "location": {
          "pointer": ""
        }
      }
    ],
    "kind": "json"
  }
  expectedOutput: '''
         <wrapStart><startTag>{</endTag>
         <addedStartTag>  &quot;key&quot;: &quot;val&quot;</endTag>
         <startTag>}</endTag><wrapEnd>
         '''
  usedErrors: []


b.bodyTypeFailObjVsPrimitiveRoot =
  testDesc: 'when expected body is object and real is primitive'
  # dataReal:  "1"
  # dataExpected: JSON.stringify {"key": "val"}
  schema: {
    "type":"object",
    "$schema": "http://json-schema.org/draft-03/schema",
    "required":true
  }
  fieldName: "body"
  fieldResult: {
    "values": { 
      "expected": JSON.stringify {"key": "val"}
      "actual": "1"
    },
    "errors": [
      {
        "message": "The  property must be an object (current value is 1).",
        "location": {
          "pointer": ""
        }
      }
    ],
    "kind": "json"
  }
  expectedOutput: '<wrapStart><changedStartTag>1</endTag> <commentStartTag>The  property must be an object (current value is 1).</commentEndTag><wrapEnd>'
  usedErrors: [""]



b.bodyTypeFailObjVsArrayRoot =
  testDesc: 'when expected body is object and real is array'
  # dataReal:  JSON.stringify [1,2,3]
  # dataExpected: JSON.stringify {"key": "val"}
  schema: {
    "type":"object",
    "$schema": "http://json-schema.org/draft-03/schema",
    "required":true
  }
  fieldName: "body"
  fieldResult: {
    "values": {
      "expected":  JSON.stringify {"key": "val"}
      "actual":  JSON.stringify [1,2,3]
    }
    "errors": [
      {
        "message": "The  property must be an object (current value is [1,2,3]).",
        "location": {
          "pointer": ""
        }
      }
    ],
    "kind": "json"
  }
  expectedOutput: '''
                  <wrapStart><startTag>[</endTag>
                  <addedStartTag>  1,</endTag>
                  <addedStartTag>  2,</endTag>
                  <addedStartTag>  3</endTag>
                  <startTag>]</endTag><wrapEnd>
                  '''
  usedErrors: []

b.bodyTypeFailObjVsArrayRootNoSchema =
  testDesc: 'when expected body is object and real is array  (no schema)'
  # dataReal:  JSON.stringify [1,2,3]
  # dataExpected: JSON.stringify {"key": "val"}
  fieldName: "body"
  fieldResult: {
    "values": {
      "expected": JSON.stringify {"key": "val"}
      "actual": JSON.stringify [1,2,3]
    }
    "errors": [
      {
        "message": "The  property must be an object (current value is [1,2,3]).",
        "location": {
          "pointer": ""
        }
      },
      {
        "message": "The ‘key’ property is required.",
        "location": {
          "pointer": "/key"
        }
      }
    ],
    "kind": "json"
  }
  expectedOutput: '''
                  <wrapStart><startTag>[</endTag>
                  <addedStartTag>  1,</endTag>
                  <addedStartTag>  2,</endTag>
                  <addedStartTag>  3</endTag>
                  <startTag>]</endTag><wrapEnd>
                  '''
  usedErrors: []

b.bodyTypeFailArrayVsObjRoot =
  testDesc: 'when expected body is array and real is object'
  # dataReal:  JSON.stringify {"key": "val"}
  # dataExpected: JSON.stringify [1,2,3]
  schema: {
    "type":"array",
    "$schema": "http://json-schema.org/draft-03/schema",
    "required":true
  }
  fieldName: "body"
  fieldResult: {
    "values": {
      "expected": JSON.stringify [1,2,3]
      "actual": JSON.stringify {"key": "val"}
    },
    "errors": [
      {
        "message": "The  property must be an array (current value is {\"key\":\"val\"}).",
        "location": {
          "pointer": ""
        }
      }
    ],
    "kind": "json"
  }
  expectedOutput: '''
                  <wrapStart><startTag>{</endTag>
                  <addedStartTag>  &quot;key&quot;: &quot;val&quot;</endTag>
                  <startTag>}</endTag><wrapEnd>
                  '''
  usedErrors: []

bodyTypeFailArrayVsObjRootNoSchema =
  testDesc: 'when expected body is array and real is object (no schema)'
  # dataReal:  JSON.stringify {"key": "val"}
  # dataExpected: JSON.stringify [1,2,3]
  fieldName: "body"
  fieldResult: {
    "values": {
      "expected": JSON.stringify [1,2,3]
      "actual": JSON.stringify {"key": "val"}
    }
    "errors": [
      {
        "message": "The  property must be an array (current value is {\"key\":\"val\"}).",
        "location": {
          "pointer": ""
        }
      },
      {
        "message": "The ‘0’ property is required.",
        "location": {
          "pointer": "/0"
        }
      },
      {
        "message": "The ‘1’ property is required.",
        "location": {
          "pointer": "/1"
        }
      },
      {
        "message": "The ‘2’ property is required.",
        "location": {
          "pointer": "/2"
        }
      }
    ],
    "kind": "json"
  }
  expectedOutput: '''
                  <wrapStart><startTag>{</endTag>
                  <addedStartTag>  &quot;key&quot;: &quot;val&quot;</endTag>
                  <startTag>}</endTag><wrapEnd>
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
  # dataReal:  JSON.stringify bodyComplexReal
  # dataExpected: JSON.stringify bodyComplexExpected
  fieldName: "body"
  fieldResult: {
    "values": {
      "expected": JSON.stringify bodyComplexExpected
      "actual": JSON.stringify bodyComplexReal
    }
    "errors": [
      {
        "message": "The ‘simpleKeyValueOKmiss’ property is required.",
        "location": {
          "pointer": "/simpleKeyValueOKmiss"
        }
      },
      {
        "message": "The ‘keyWithObjectValueFail,keyWithObjectValueOKnestedKeyMiss’ property is required.",
        "location": {
          "pointer": "/keyWithObjectValueFail/keyWithObjectValueOKnestedKeyMiss"
        }
      },
      {
        "message": "The keyWithObjectValueWrongTypeFail property must be an object (current value is [1,2,3]).",
        "location": {
          "pointer": "/keyWithObjectValueWrongTypeFail"
        }
      },
      {
        "message": "The ‘keyWithObjectValueWrongTypeFail,keyWithObjectValueOKnestedKeyMiss’ property is required.",
        "location": {
          "pointer": "/keyWithObjectValueWrongTypeFail/keyWithObjectValueOKnestedKeyMiss"
        }
      },
      {
        "message": "The ‘keyWithObjectValueWrongTypeFail,keyWithObjectValueOKnestedKey2’ property is required.",
        "location": {
          "pointer": "/keyWithObjectValueWrongTypeFail/keyWithObjectValueOKnestedKey2"
        }
      },
      {
        "message": "The keyWithArrayValueTypeFail property must be an array (current value is {\"key\":\"val\"}).",
        "location": {
          "pointer": "/keyWithArrayValueTypeFail"
        }
      },
      {
        "message": "The ‘keyWithArrayValueTypeFail,0’ property is required.",
        "location": {
          "pointer": "/keyWithArrayValueTypeFail/0"
        }
      },
      {
        "message": "The ‘keyWithArrayValueTypeFail,1’ property is required.",
        "location": {
          "pointer": "/keyWithArrayValueTypeFail/1"
        }
      },
      {
        "message": "The ‘keyWithArrayValueTypeFail,2’ property is required.",
        "location": {
          "pointer": "/keyWithArrayValueTypeFail/2"
        }
      }
    ],
    "kind": "json"
  }
  expectedOutput: '''
                  <wrapStart><startTag>{</endTag>
                  <startTag>  &quot;simpleKeyValueOK&quot;: &quot;simpleKeyValueOK&quot;,</endTag>
                  <startTag>  &quot;simpleKeyValueNumberOK&quot;: 1,</endTag>
                  <startTag>  &quot;keyWithObjectValueOK&quot;: {</endTag>
                  <startTag>    &quot;keyWithObjectValueOKnestedKey&quot;: &quot;keyWithObjectValueOKnestedKey&quot;,</endTag>
                  <startTag>    &quot;keyWithObjectValueOKnestedKey2&quot;: &quot;keyWithObjectValueOKnestedKey2&quot;</endTag>
                  <startTag>  },</endTag>
                  <startTag>  &quot;keyWithObjectValueFail&quot;: {</endTag>
                  <startTag>    &quot;keyWithObjectValueOKnestedKey2&quot;: &quot;keyWithObjectValueOKnestedKey2&quot;</endTag>
                  <startTag>  },</endTag>
                  <changedStartTag>  &quot;keyWithObjectValueWrongTypeFail&quot;: [</endTag> <commentStartTag>The keyWithObjectValueWrongTypeFail property must be an object (current value is [1,2,3]).</commentEndTag>
                  <addedStartTag>    1,</endTag>
                  <addedStartTag>    2,</endTag>
                  <addedStartTag>    3</endTag>
                  <startTag>  ],</endTag>
                  <startTag>  &quot;keyWithArrayValueOK&quot;: [</endTag>
                  <startTag>    1,</endTag>
                  <startTag>    2,</endTag>
                  <startTag>    3</endTag>
                  <startTag>  ],</endTag>
                  <startTag>  &quot;keyWithArrayValueOK2&quot;: [</endTag>
                  <startTag>    4,</endTag>
                  <startTag>    5,</endTag>
                  <startTag>    6</endTag>
                  <startTag>  ],</endTag>
                  <changedStartTag>  &quot;keyWithArrayValueTypeFail&quot;: {</endTag> <commentStartTag>The keyWithArrayValueTypeFail property must be an array (current value is {"key":"val"}).</commentEndTag>
                  <addedStartTag>    &quot;key&quot;: &quot;val&quot;</endTag>
                  <startTag>  }</endTag>
                  <startTag>}</endTag><wrapEnd>
                  '''
  usedErrors: [
    "/keyWithObjectValueWrongTypeFail",
    "/keyWithArrayValueTypeFail"
    ]

b.bodyComplexWithNonPointerError =
  testDesc: 'complex body test with non pointer error in gavel results'
  # dataReal:  JSON.stringify bodyComplexReal
  # dataExpected: JSON.stringify bodyComplexExpected
  fieldName: 'body'
  fieldResult: {
    "values": {
      "expected": JSON.stringify bodyComplexExpected
      "actual": JSON.stringify bodyComplexReal
    },
    "errors": [
      {
        "message": "Your mamma can't swim up the hill."
      },
      {
        "message": "The ‘simpleKeyValueOKmiss’ property is required.",
        "location": {
          "pointer": "/simpleKeyValueOKmiss"
        }
      },
      {
        "message": "The ‘keyWithObjectValueFail,keyWithObjectValueOKnestedKeyMiss’ property is required.",
        "location": {
          "pointer": "/keyWithObjectValueFail/keyWithObjectValueOKnestedKeyMiss"
        }
      },
      {
        "message": "The keyWithObjectValueWrongTypeFail property must be an object (current value is [1,2,3]).",
        "location": {
          "pointer": "/keyWithObjectValueWrongTypeFail"
        }
      },
      {
        "message": "The ‘keyWithObjectValueWrongTypeFail,keyWithObjectValueOKnestedKeyMiss’ property is required.",
        "location": {
          "pointer": "/keyWithObjectValueWrongTypeFail/keyWithObjectValueOKnestedKeyMiss"
        }
      },
      {
        "message": "The ‘keyWithObjectValueWrongTypeFail,keyWithObjectValueOKnestedKey2’ property is required.",
        "location": {
          "pointer": "/keyWithObjectValueWrongTypeFail/keyWithObjectValueOKnestedKey2"
        }
      },
      {
        "message": "The keyWithArrayValueTypeFail property must be an array (current value is {\"key\":\"val\"}).",
        "location": {
          "pointer": "/keyWithArrayValueTypeFail"
        }
      },
      {
        "message": "The ‘keyWithArrayValueTypeFail,0’ property is required.",
        "location": {
          "pointer": "/keyWithArrayValueTypeFail/0"
        }
      },
      {
        "message": "The ‘keyWithArrayValueTypeFail,1’ property is required.",
        "location": {
          "pointer": "/keyWithArrayValueTypeFail/1"
        }
      },
      {
        "message": "The ‘keyWithArrayValueTypeFail,2’ property is required.",
        "location": {
          "pointer": "/keyWithArrayValueTypeFail/2"
        }
      }
    ],
    "kind": "json"
  }
  expectedOutput: '''
                  <wrapStart><startTag>{</endTag>
                  <startTag>  &quot;simpleKeyValueOK&quot;: &quot;simpleKeyValueOK&quot;,</endTag>
                  <startTag>  &quot;simpleKeyValueNumberOK&quot;: 1,</endTag>
                  <startTag>  &quot;keyWithObjectValueOK&quot;: {</endTag>
                  <startTag>    &quot;keyWithObjectValueOKnestedKey&quot;: &quot;keyWithObjectValueOKnestedKey&quot;,</endTag>
                  <startTag>    &quot;keyWithObjectValueOKnestedKey2&quot;: &quot;keyWithObjectValueOKnestedKey2&quot;</endTag>
                  <startTag>  },</endTag>
                  <startTag>  &quot;keyWithObjectValueFail&quot;: {</endTag>
                  <startTag>    &quot;keyWithObjectValueOKnestedKey2&quot;: &quot;keyWithObjectValueOKnestedKey2&quot;</endTag>
                  <startTag>  },</endTag>
                  <changedStartTag>  &quot;keyWithObjectValueWrongTypeFail&quot;: [</endTag> <commentStartTag>The keyWithObjectValueWrongTypeFail property must be an object (current value is [1,2,3]).</commentEndTag>
                  <addedStartTag>    1,</endTag>
                  <addedStartTag>    2,</endTag>
                  <addedStartTag>    3</endTag>
                  <startTag>  ],</endTag>
                  <startTag>  &quot;keyWithArrayValueOK&quot;: [</endTag>
                  <startTag>    1,</endTag>
                  <startTag>    2,</endTag>
                  <startTag>    3</endTag>
                  <startTag>  ],</endTag>
                  <startTag>  &quot;keyWithArrayValueOK2&quot;: [</endTag>
                  <startTag>    4,</endTag>
                  <startTag>    5,</endTag>
                  <startTag>    6</endTag>
                  <startTag>  ],</endTag>
                  <changedStartTag>  &quot;keyWithArrayValueTypeFail&quot;: {</endTag> <commentStartTag>The keyWithArrayValueTypeFail property must be an array (current value is {"key":"val"}).</commentEndTag>
                  <addedStartTag>    &quot;key&quot;: &quot;val&quot;</endTag>
                  <startTag>  }</endTag>
                  <startTag>}</endTag><wrapEnd>
                  '''
  usedErrors: [
    "/keyWithObjectValueWrongTypeFail",
    "/keyWithArrayValueTypeFail"
  ]


b.bodyOkWithNestedObjectsInArrays =
  testDesc: 'when expected and real body are the same and contains array of objects'
  # dataReal: JSON.stringify {
  #   "login": "true"
  #   "results": [
  #     {"otrkey": "20_jahre_feste", "key2": "value2"}
  #     {"otrkey": "30_jahre_feste", "key2": "value2"}
  #     {"otrkey": "40_jahre_feste", "key2": "value2"}
  #   ]
  # }
  # dataExpected: JSON.stringify {
  #   "login": "true"
  #   "results": [
  #     {"otrkey": "20_jahre_feste", "key2": "value2"}
  #     {"otrkey": "30_jahre_feste", "key2": "value2"}
  #     {"otrkey": "40_jahre_feste", "key2": "value2"}
  #   ]
  # }
  fieldName: 'body'
  fieldResult: {
    "values": {
      "expected": JSON.stringify {
        "login": "true"
        "results": [
          {"otrkey": "20_jahre_feste", "key2": "value2"}
          {"otrkey": "30_jahre_feste", "key2": "value2"}
          {"otrkey": "40_jahre_feste", "key2": "value2"}
        ]
      }
      "actual": JSON.stringify {
        "login": "true"
        "results": [
          {"otrkey": "20_jahre_feste", "key2": "value2"}
          {"otrkey": "30_jahre_feste", "key2": "value2"}
          {"otrkey": "40_jahre_feste", "key2": "value2"}
        ]
      }
    },
    "errors": [],
    "kind": "json"
  }
  expectedOutput: """
<wrapStart><startTag>{</endTag>
<startTag>  &quot;login&quot;: &quot;true&quot;,</endTag>
<startTag>  &quot;results&quot;: [</endTag>
<startTag>    {</endTag>
<startTag>      &quot;otrkey&quot;: &quot;20_jahre_feste&quot;,</endTag>
<startTag>      &quot;key2&quot;: &quot;value2&quot;</endTag>
<startTag>    },</endTag>
<startTag>    {</endTag>
<startTag>      &quot;otrkey&quot;: &quot;30_jahre_feste&quot;,</endTag>
<startTag>      &quot;key2&quot;: &quot;value2&quot;</endTag>
<startTag>    },</endTag>
<startTag>    {</endTag>
<startTag>      &quot;otrkey&quot;: &quot;40_jahre_feste&quot;,</endTag>
<startTag>      &quot;key2&quot;: &quot;value2&quot;</endTag>
<startTag>    }</endTag>
<startTag>  ]</endTag>
<startTag>}</endTag><wrapEnd>
  """
  usedErrors: []

b.bodyOkWithNestedStringsInArrays =
  testDesc: 'when expected and real body are the same and contains array of strings'
  # dataReal: JSON.stringify {
  #   "login": "true"
  #   "results": [
  #     "BooBoo"
  #     "MrauMrau"
  #     "BauBau"
  #   ]
  # }
  # dataExpected: JSON.stringify {
  #   "login": "true"
  #   "results": [
  #     "BooBoo"
  #     "MrauMrau"
  #     "BauBau"
  #   ]
  # }
  fieldName: 'body'
  fieldResult: {
    "values": {
      "expected": JSON.stringify {
        "login": "true"
        "results": [
          "BooBoo"
          "MrauMrau"
          "BauBau"
        ]
      }
      "actual": JSON.stringify {
        "login": "true"
        "results": [
          "BooBoo"
          "MrauMrau"
          "BauBau"
        ]
      }
    }
    "errors": [],
    "kind": "json"
  }
  expectedOutput: """
  <wrapStart><startTag>{</endTag>
  <startTag>  &quot;login&quot;: &quot;true&quot;,</endTag>
  <startTag>  &quot;results&quot;: [</endTag>
  <startTag>    &quot;BooBoo&quot;,</endTag>
  <startTag>    &quot;MrauMrau&quot;,</endTag>
  <startTag>    &quot;BauBau&quot;</endTag>
  <startTag>  ]</endTag>
  <startTag>}</endTag><wrapEnd>
  """
  usedErrors: []

b.bodyOkWithNestedArraysInArrays =
  testDesc: 'when expected and real body are the same and contains array of arrays'
  # dataReal: JSON.stringify {
  #   "login": "true"
  #   "results": [
  #     [1,2,3]
  #     [1,2,3]
  #     [1,2,3]
  #   ]
  # }
  # dataExpected: JSON.stringify {
  #   "login": "true"
  #   "results": [
  #     [1,2,3]
  #     [1,2,3]
  #     [1,2,3]
  #   ]
  # }
  fieldName: 'body'
  fieldResult: {
    "values": {
      "expected": JSON.stringify {
        "login": "true"
        "results": [
          [1,2,3]
          [1,2,3]
          [1,2,3]
        ]
      }
      "actual": JSON.stringify {
        "login": "true"
        "results": [
          [1,2,3]
          [1,2,3]
          [1,2,3]
        ]
      }
    },
    "errors": [],
    "kind": "json"
  }
  expectedOutput: """
<wrapStart><startTag>{</endTag>
<startTag>  &quot;login&quot;: &quot;true&quot;,</endTag>
<startTag>  &quot;results&quot;: [</endTag>
<startTag>    [</endTag>
<startTag>      1,</endTag>
<startTag>      2,</endTag>
<startTag>      3</endTag>
<startTag>    ],</endTag>
<startTag>    [</endTag>
<startTag>      1,</endTag>
<startTag>      2,</endTag>
<startTag>      3</endTag>
<startTag>    ],</endTag>
<startTag>    [</endTag>
<startTag>      1,</endTag>
<startTag>      2,</endTag>
<startTag>      3</endTag>
<startTag>    ]</endTag>
<startTag>  ]</endTag>
<startTag>}</endTag><wrapEnd>
  """
  usedErrors: []



b.bodyOkWithNestedStringsInArraysWrappedKeys =
  testDesc: 'when expected and real body are the same and I want to wrap object keys in additional tags'
  # dataReal: JSON.stringify {
  #   "login": "true"
  #   "results": [
  #     "BooBoo"
  #     5
  #     "BauBau"
  #   ]
  # }
  # dataExpected: JSON.stringify {
  #   "login": "true"
  #   "results": [
  #     "BooBoo"
  #     5
  #     "BauBau"
  #   ]
  # }
  fieldName: 'body'
  fieldResult: {
    "values": {
      "expected":JSON.stringify {
        "login": "true"
        "results": [
          "BooBoo"
          5
          "BauBau"
        ]
      }
      "actual": JSON.stringify {
        "login": "true"
        "results": [
          "BooBoo"
          5
          "BauBau"
        ]
      }
    },
    "errors": [],
    "kind": "json"
  }
  expectedOutput: """
  <wrapStart><startTag>{</endTag>
  <startTag>  &quot;<keyStart>login</keyEnd>&quot;: &quot;true&quot;,</endTag>
  <startTag>  &quot;<keyStart>results</keyEnd>&quot;: [</endTag>
  <startTag>    &quot;BooBoo&quot;,</endTag>
  <startTag>    5,</endTag>
  <startTag>    &quot;BauBau&quot;</endTag>
  <startTag>  ]</endTag>
  <startTag>}</endTag><wrapEnd>
  """
  usedErrors: []
  outputOptions:
    jsonKeyStartTag: "<keyStart>"
    jsonKeyEndTag: "</keyEnd>"
    wrapWith: '<wrapStart>##data<wrapEnd>'
    startTag: '<startTag>'
    endTag: '</endTag>'
    missingStartTag: '<missingStartTag>'
    addedStartTag: "<addedStartTag>"
    changedStartTag: '<changedStartTag>'
    comments: true
    commentStartTag: '<commentStartTag>'
    commentEndTag: '</commentEndTag>'


module.exports = {
  gavel2htmlOutputOptions
  testsHeaders: h
  testsBody: b
}
