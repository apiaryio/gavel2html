binaryDetect = require './binary-detect'
sanitizer = require './html-sanitizer.js'
traverse = require 'traverse'
jsonPointer = require 'json-pointer'

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
  # aggregate all errors for given path and mark them with state missing, added, changed etc..
  getStateAndMessageFromAmandaResult: ({pathArray, lowerCasedKeys}) ->
    resultsCount = @gavelResult.rawData.length or 0
    state = 0
    message = ''

    if lowerCasedKeys
      transformKeys = (s) ->
        s.toLowerCase()
    else
      transformKeys = (s) ->
        s


    # get all pointers in expected data
    dataExpectedPointers = []
    traverse(@dataExpected).forEach (nodeValue) ->
      dataExpectedPointers.push jsonPointer.compile this.path.map(transformKeys)
      return

    dataRealPointers = []
    # get all pointers in expected data
    traverse(@dataReal).forEach (nodeValue) ->
      dataRealPointers.push jsonPointer.compile this.path.map(transformKeys)
      return

    if resultsCount
      for i in [0..resultsCount-1]
        if @areArraysIdentical pathArray.map(transformKeys), @gavelResult.rawData[i]?['property'] or []
          errorPointer = jsonPointer.compile(@gavelResult.rawData[i]?['property'] or [])
          # key is missing in real and is present in expected, so it's missing
          if not (errorPointer in dataRealPointers)
            if message
              message = ' | ' + message
            message = @gavelResult.rawData[i]['message'] + message
            state = -1

          else

            # key is present in both real and expected, so its changed (different value primitive type probably)
            if not state
              state = 2
            if message
              message += " | "
            message += @gavelResult.rawData[i]['message']

    return {pathArray: pathArray, 'state': state, 'message': message}

  #@private
  # aggregate all errors for given path and mark them with state missing, added, changed etc..
  getStateAndMessageFromResults: ({pathArray, lowerCasedKeys}) ->
    resultsCount = @gavelResult.results.length
    state = 0
    message = ''

    if lowerCasedKeys
      transformKeys = (s) ->
        s.toLowerCase()
    else
      transformKeys = (s) ->
        s

    # get all pointers in expected data
    dataExpectedPointers = []
    traverse(@dataExpected).forEach (nodeValue) ->
      dataExpectedPointers.push jsonPointer.compile this.path.map(transformKeys)
      return

    dataRealPointers = []
    # get all pointers in expected data
    traverse(@dataReal).forEach (nodeValue) ->
      dataRealPointers.push jsonPointer.compile this.path.map(transformKeys)
      return

    if resultsCount
      for result in @gavelResult.results
        if result['pointer'] # filter out non json related errors
          if @areArraysIdentical pathArray.map(transformKeys), jsonPointer.parse(result['pointer'])
            errorPointer = result['pointer']
            # key is missing in real and is present in expected, so it's missing
            if not (errorPointer in dataRealPointers)
              if message
                message = ' | ' + message
              message = result['message'] + message
              state = -1

            else

              # key is present in both real and expected, so its changed (different value primitive typeprobably)
              if not state
                state = 2
              if message
                message += " | "
              message += result['message']

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
