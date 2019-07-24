binaryDetect = require './binary-detect'
sanitizer = require './html-sanitizer'
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
  constructor: ({@dataReal, @dataExpected, @fieldResult, @usePointers}) ->
    @usedErrors   = []

  getHtml: (options = {}) ->
    {
      @wrapWith
      @startTag
      @jsonKeyStartTag
      @jsonKeyEndTag
      @missingStartTag
      @addedStartTag
      @changedStartTag
      @endTag
      @comments
      @commentStartTag
      @commentEndTag
      @identString
    } = options

    @outputs = [@missingStartTag, @startTag, @addedStartTag, @changedStartTag]

    html = @getHtmlPrivate()

    if @wrapWith
      html = @wrapWith.replace '##data', html

    return html

  #@private
  getHtmlPrivate: ->
    throw new Error 'getHtmlPrivate: not implemented. Must be implemented in subclass'


  formatFragmentParts: ({message, status}) ->
    status ?= 0
    out = [
      "#{@outputs[1 * (status or 0) + 1] or ''}"
      [@endTag]
    ]

    if @comments and message
      out[1].push "#{@commentStartTag}#{message}#{@commentEndTag}"

    return out


  #@private
  formatFragment: ({fragment, message, status, omitSanitize}) ->
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

    if omitSanitize
      output += fragment
    else
      output += @sanitize fragment

    output += @endTag

    if @comments and message
      output += ' ' + @commentStartTag
      output += message
      output += @commentEndTag

    return output

  #@private
  # builds an Array filled with all traverse-based jsonPointer.compiled paths
  # so we can reuse it in future calls
  buildDataRealPointers: ({compiledPointersKey, transformKeysFn}) ->
    if not @dataRealPointers?[compiledPointersKey]
      compiledPointers = []
      # get all pointers in expected data
      traverse(@dataReal).forEach ->
        compiledPointers.push jsonPointer.compile this.path.map(transformKeysFn)
        return
      @dataRealPointers ?= {}
      @dataRealPointers[compiledPointersKey] = compiledPointers

  #@private
  getPointerTransformKeys: (lowerCasedKeys) ->
    transformKeysFn = @_lambda
    compiledPointersKey = 'original'

    if lowerCasedKeys
      transformKeysFn = @_lowerCaseIt
      compiledPointersKey = 'lowercased'
    return [transformKeysFn, compiledPointersKey]

  #@private
  # aggregate all errors for given path and mark them with state missing, added, changed etc..
  getStateAndMessageFromResults: ({pathArray, lowerCasedKeys}) ->
    errorsCount = @fieldResult?.errors?.length
    state = 0
    message = ''

    if errorsCount
      [transformKeysFn, compiledPointersKey] = @getPointerTransformKeys lowerCasedKeys
      @buildDataRealPointers {transformKeysFn, compiledPointersKey}

      pathArrayTransformed = pathArray.map(transformKeysFn)

      for error in @fieldResult.errors
        errorPointer = error.location?.pointer
        
        if errorPointer? # filter out non json related errors
          if @areArraysIdentical pathArrayTransformed, jsonPointer.parse(errorPointer)
            # key is missing in real and is present in expected, so it's missing
            if errorPointer not in @dataRealPointers[compiledPointersKey]
              if message
                message = ' | ' + message
              message = error['message'] + message
              state = -1

            else
              # key is present in both real and expected, so its changed (different value primitive typeprobably)
              if not state
                state = 2
              if message
                message += " | "
              message += error['message']

    return {pathArray: pathArray, 'state': state, 'message': message}

  #@private
  sanitize: (data) ->
    binaryDetect data, sanitizer, escapeBasicHtml

  #@private
  _lowerCaseIt: (str) ->
    str.toLowerCase()

  #@private
  _lambda: (unknown) ->
    unknown

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
