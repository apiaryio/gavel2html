{assert} = require 'chai'
Gavel2Html = require('../../src/index')

describe 'Dollar sign in the body', ->
  gavelResult = {
    fields: {
      body: {
        kind: 'json',
        values: {
          actual: JSON.stringify({ symbol: '$' }),
          expected: JSON.stringify({ symbol: 'a' }),
        },
        errors: []
      }
    }
  }

  payload = {
    fieldName: 'body',
    fieldResult: gavelResult.fields.body,
  }
  diff = new Gavel2Html payload
  html = diff.getHtml()

  it 'escapes the dollar sign in the diff', ->
    assert.equal(html, '<li>{</li>\n<li>  &quot;symbol&quot;: &quot;$$&quot;</li>\n<li>}</li>')
