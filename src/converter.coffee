binaryDetect   = require './binary-detect'
sanitizer      = require './html-sanitizer.js'

regExpAmp      = /&/g
htmlEntityAmp  = '&amp;'
regExpLt       = /</g
htmlEntityLt   = '&lt;'
regExpGt       = />/g
htmlEntityGt   = '&gt;'
regExpQuot     = /"/g
htmlEntityQuot = '&quot;'

escapeBasicHtml = (val) ->
  ('' + val)
  .replace(regExpAmp, htmlEntityAmp)
  .replace(regExpLt, htmlEntityLt)
  .replace(regExpGt, htmlEntityGt)
  .replace(regExpQuot, htmlEntityQuot)

class Converter
  constructor: ({@dataReal, @dataExpected, @gavelResult}) ->
    @usedErrors   = []

  getHtml: ({@wrapWith, @startTag, @missingStartTag, @addedStartTag, @changedStartTag, @endTag, @comments, @commentStartTag, @commentEndTag, @identString}) ->

    html = @getHtmlPrivate()

    if @wrapWith
      html = @wrapWith.replace '##data', html

    return html

  #@private
  getHtmlPrivate: ->
    throw new Error 'getHtmlPrivate: not implemented. Must be implemented in subclass'

  #@private
  formatFragment: ({fragment, message, status}) ->
    output = ''

    switch status
      when -1
        output += @missingStartTag
      when 0
        output += @startTag
      when 1
        output += @addedStartTag
      when 2
        output += @changedStartTag

    output +=  @sanitize fragment
    output += @endTag

    if @comments and message
      output += ' ' + @commentStartTag
      output += message
      output += @commentEndTag

    return output

  #@private
  getStateAndMessageFromAmandaResult: ({pathArray, amandaResult, lowerCasedKeys}) ->
    resultsCount = amandaResult.length or 0
    state = 0
    message = ''

    if resultsCount
      if lowerCasedKeys
        transformKeys = (s) ->
          s.toLowerCase()
      else
        transformKeys = (s) ->
          s

      for i in [0..resultsCount-1]
        if @areArraysIdentical pathArray.map(transformKeys), amandaResult[i]?['property'] or []

          if amandaResult[i]['validator'] == 'required'
            if message
              message = ' | ' + message
            message = amandaResult[i]['message'] + message
            state = -1
          else if amandaResult[i]['validator'] == 'additionalProperties'
            if not state
              state = 1
          else
            if not state
              state = 2
            if message
              message += " | "
            message += amandaResult[i]['message']

    return {pathArray: pathArray, 'state': state, 'message': message}

  #@private
  sanitize: (data) ->
    binaryDetect data, sanitizer, escapeBasicHtml


  #@private
  areArraysIdentical: (a1, a2) ->
    i = a1.length

    if i != a2.length
      return false

    while i--
      if a1[i] != a2[i]
        return false

    return true

module.exports = Converter
