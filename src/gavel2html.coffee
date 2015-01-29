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
  constructor: ({dataReal, dataExpected, gavelResult, usePointers}) ->
    @dataReal     = dataReal
    @dataExpected = dataExpected
    @gavelResult  = gavelResult
    @usePointers  = usePointers
    @usedErrors   = []


  getHtml: ({wrapWith, startTag, endTag, missingStartTag, addedStartTag, changedStartTag, comments, commentStartTag, commentEndTag, identString}) ->
    options = {
      wrapWith: wrapWith || '##data',
      startTag: startTag || '<li>',
      endTag: endTag  || '</li>',
      missingStartTag: missingStartTag,
      addedStartTag: addedStartTag,
      changedStartTag: changedStartTag,
      comments: comments,
      commentStartTag: commentStartTag,
      commentEndTag: commentEndTag,
      identString: identString || '  '
    }

    converter = @getConverter()

    try
      result = converter.getHtml options
      @usedErrors   = converter.usedErrors
      return result
    catch e
      html = missingStartTag + "Internal validator error\n\n" + endTag
      try
        if typeof(@dataReal) != 'string'
          @dataReal  = JSON.stringify @dataReal
      catch e
        false

      html += @dataReal

      if wrapWith
        html = wrapWith.replace '##data', html

      return html

  #@private
  getConverter: ->
    options = {
      dataReal: @dataReal
      dataExpected: @dataExpected
      gavelResult: @gavelResult
      usePointers: @usePointers
    }

    switch @gavelResult?.validator
      when 'TextDiff'
        return new TextResultConverter options
      when 'JsonSchema'
        transformedData = transformJsonData(options.dataReal, options.dataExpected)
        if transformedData
          options.dataReal = transformedData.real
          options.dataExpected = transformedData.expected
          return new JsonResultConverter options
        return new TextResultConverter options
      when 'JsonExample'
        transformedData = transformJsonData(options.dataReal, options.dataExpected)
        if transformedData
          options.dataReal = transformedData.real
          options.dataExpected = transformedData.expected
          return new JsonResultConverter options
        return new TextResultConverter options
      when 'HeadersJsonSchema'
        return new HeadersResultConverter options
      when 'HeadersJsonExample'
        return new HeadersResultConverter options

    return new TextResultConverter options

module.exports.Gavel2Html = Gavel2Html
