Converter = require './converter'

JsonResultConverter = require './json-result-converter'
TextResultConverter = require './text-result-converter'
HeadersResultConverter = require './headers-result-converter'

transformJsonData = (real, expected) ->
  try
    realTransformed = JSON.parse real
    expectedTransformed = JSON.parse expected
  catch e
    return false

  return {real: realTransformed, expected: expectedTransformed}

class Gavel2Html
  constructor: ({ fieldName, fieldResult, usePointers }) ->
    @fieldName    = fieldName
    # Real and expected data are stored only to preserve
    # previously existing references. Remove this and use "fieldResult"
    # referenced directly when refactoring.
    @dataReal     = fieldResult.values.actual
    @dataExpected = fieldResult.values.expected
    @fieldResult  = fieldResult
    @usePointers  = usePointers
    @usedErrors   = []

  getHtml: (givenOptions = {}) ->
    {
      wrapWith
      startTag
      endTag
      jsonKeyStartTag
      jsonKeyEndTag
      missingStartTag
      addedStartTag
      changedStartTag
      comments
      commentStartTag
      commentEndTag
      identString
    } = givenOptions

    options = {
      missingStartTag
      addedStartTag
      changedStartTag
      comments
      commentStartTag
      commentEndTag
      wrapWith: wrapWith || '##data'
      startTag: startTag || '<li>'
      endTag: endTag || '</li>'
      jsonKeyStartTag: jsonKeyStartTag || ''
      jsonKeyEndTag: jsonKeyEndTag || ''
      identString: identString || '  '
    }

    converter = @getConverter()

    try
      result = converter.getHtml options
      @usedErrors = converter.usedErrors
      return result
    catch e
      console.log('\n\nERROR CAUGHT:', e)
      console.log('\n\n')
      html = missingStartTag + "Internal validator error\n\n" + endTag
      try
        if typeof(@dataReal) != 'string'
          @dataReal = JSON.stringify @dataReal
      catch e
        false

      html += @dataReal

      if wrapWith
        html = wrapWith.replace '##data', html

      return html

  #@private
  getConverter: ->
    options = {
      @fieldName
      @dataReal
      @dataExpected
      @fieldResult
      @usePointers
    }

    switch @fieldResult?.kind
      when 'json'
        if @fieldName == 'headers'
          return new HeadersResultConverter options

        transformedData = transformJsonData(options.dataReal, options.dataExpected)

        if transformedData
          options.dataReal = transformedData.real
          options.dataExpected = transformedData.expected
          return new JsonResultConverter options

        return new TextResultConverter options

    return new TextResultConverter options

module.exports.Gavel2Html = Gavel2Html
