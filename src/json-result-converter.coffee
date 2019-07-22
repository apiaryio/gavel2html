traverse = require 'traverse'
jsonPointer = require 'json-pointer'
type = require 'is-type'

Converter = require './converter'

class JsonResultConverter extends Converter
  #@protected
  getHtmlPrivate: ->
    out = ''
    prevLevel = 0
    prevNode = null
    errorsPaths = []
    # if @usePointers
    errors = @getErrorsFromResults()
    # else
    #   errors = @getErrors()

    closingBrackets = []
    typesOnLevels = {}
    @usedErrors = []
    errorsMap = @mapErrorsPositionByPath errors

    # traverse breaking context aagggrrrrr.....
    getIdent = @getIdentFunction @identString
    formatParts = @formatFragmentPartsFunction @
    sanitizeData = @sanitize.bind @
    usedErrors = @usedErrors

    for error in errors
      errorsPaths.push jsonPointer.compile error.pathArray

    s = ''
    indentLevel = 1
    out = {}

    writtenStart = false
    writtenEnd = false

    defaultStart = "#{@startTag}"
    defaultEnd = "#{@endTag}"
    keyTagWrapStart = "#{@jsonKeyStartTag or ''}"
    keyTagWrapEnd = "#{@jsonKeyEndTag or ''}"

    writeStart = (pieces = [defaultStart], indentation = '') ->
      if not writtenStart
        s += pieces[0] + indentation
        pieces[0] = defaultStart # reset back to default, because Array/Object ends
        writtenEnd = not writtenStart = true
      return

    writeEnd = (pieces = [defaultStart, [defaultEnd]], newline = false) ->
      if not writtenEnd
        s += "#{pieces[1].join(' ')}#{if newline then '\n' else ''}"
        # pieces[0] = defaultStart
        pieces[1] = [pieces[1][0]]
        writtenStart = not writtenEnd = true
      return

    findErrorsByPointerPath = (pointerPath) ->
      errorOnThisPath = null
      if out[pointerPath]? or not pointerPath?
        return
      errNo = errorsMap[pointerPath]
      if errNo or errNo == 0
        errorOnThisPath = errors[errNo]
        if errorOnThisPath.state != 1 # not added
          usedErrors.push pointerPath

      if errorOnThisPath? and pointerPath?
        out[pointerPath] = formatParts {
          status: errorOnThisPath.state
          message: errorOnThisPath.message?.replace('The undefined property', 'The property')
        }
      else
        out[pointerPath] = formatParts {
          status: 0
        }
      return

    walking = (node, preStringValue, postStringValue) ->
      compiledPath = null
      if @path
        compiledPath = jsonPointer.compile(@path)

      if not @path?
        compiledPath = compiledPath
      else if not @isRoot or (@isRoot and typeof(node) in ['number', 'string'])
        findErrorsByPointerPath compiledPath

      if Array.isArray(node)
        @before ->
          if @isRoot
            writeStart out[compiledPath]
          s += '['
          if not @isLeaf
            indentLevel = indentLevel + 1
            writeEnd out[compiledPath], true
          return
        @pre (x, key) ->
          pointerHere = jsonPointer.compile [].concat(@path).concat key
          findErrorsByPointerPath pointerHere
          writeStart out[pointerHere], getIdent(indentLevel)
          return
        @post (child) ->
          pointerHere = jsonPointer.compile [].concat(@path).concat child.path
          findErrorsByPointerPath pointerHere
          if !child.isLast
            s += ','
          writeEnd out[pointerHere], true
          return
        @after ->
          if not @isLeaf
            indentLevel = (indentLevel - 1) or 1
            writeStart out[compiledPath], getIdent(indentLevel)
          s += ']'
          if @isRoot
            writeEnd out[compiledPath]
          return
      else if typeof node == 'object'
        @before ->
          if @isRoot
            writeStart(out[compiledPath])
          s += '{'
          if not @isLeaf
            indentLevel = indentLevel + 1
            writeEnd out[compiledPath], true
          return
        @pre (x, key) ->
          pointerHere = jsonPointer.compile [].concat(@path).concat key
          findErrorsByPointerPath pointerHere
          writeStart out[pointerHere], getIdent(indentLevel)
          walking key, keyTagWrapStart, keyTagWrapEnd
          s += ': '
          return
        @post (child) ->
          pointerHere = jsonPointer.compile [].concat(@path).concat child.path
          findErrorsByPointerPath pointerHere
          if !child.isLast
            s += ','
          writeEnd out[pointerHere], true
          return
        @after ->
          if not @isLeaf
            indentLevel = (indentLevel - 1) or 1
            writeStart(out[compiledPath], getIdent(indentLevel))
          s += '}'
          if @isRoot
            writeEnd out[compiledPath]
          return
      else if typeof node == 'string'
        if @isRoot
          writeStart(out[compiledPath])
        s += '&quot;' # sanitizeData('"')
        s += preStringValue if preStringValue
        s += sanitizeData(node.toString().replace(/"/g, '\"'))
        s += postStringValue if postStringValue
        s += '&quot;' # sanitizeData('"')
        if @isRoot
          writeEnd(out[compiledPath])
      else
        if @isRoot
          writeStart(out[compiledPath])
        s += sanitizeData node.toString()
        if @isRoot
          writeEnd(out[compiledPath])
      return

    traverse(@dataReal).forEach walking

    # console.log "\n#{s}\n"
    @usedErrors = usedErrors

    return s


  #@private
  formatFragmentPartsFunction: (thisInstance) -> (options) ->
    thisInstance.formatFragmentParts options

  #@private
  getIdentFunction: (identString) -> (level) ->
    if identString
      return (new Array(level)).join(identString)

    return ''

  #@private
  # THIS LOOKS TO OPERATE ON AMANDA'S RAW OUTPUT.
  # NEEDS TO BE REMOVED, NO LONGER AMANDA.
  # getErrors: ()->
  #   if not (@fieldResult.rawData and @fieldResult.rawData.length)
  #     return [] # not sure about this, added keys will not be marked as addeds

  #   amandaErrorsPaths = {}
  #   errors = []
  #   dataExpectedPointers = []

  #   # get all pointers in expected data
  #   traverse(@dataExpected).forEach (nodeValue) ->
  #     dataExpectedPointers.push jsonPointer.compile this.path
  #     return

  #   # path from real does not exits in expected data so it's addded
  #   traverse(@dataReal).forEach (nodeValue) ->
  #     if not (jsonPointer.compile(this.path) in dataExpectedPointers)
  #       errors.push {pathArray: this.path, value: nodeValue, 'state': 1, 'message': undefined}
  #     return

  #   # get unique paths in errors
  #   for i in [0..@fieldResult.rawData.length - 1]

  #     # get pointer from array and sanitize 'null' path array meant as root
  #     if @fieldResult.rawData[i]['property']
  #       pointer = jsonPointer.compile @fieldResult.rawData[i]['property']
  #     else
  #       pointer = ''

  #     if not amandaErrorsPaths[pointer]
  #       amandaErrorsPaths[pointer] = @fieldResult.rawData[i]['property'] or []

  #   # get aggregated message and state for each error pointer/pathArray
  #   for pointer, pathArray of amandaErrorsPaths
  #     errors.push @getStateAndMessageFromAmandaResult pathArray: pathArray, lowerCasedKeys: false

  #   return errors

  #@private
  getErrorsFromResults: () ->
    if @fieldResult.errors.length == 0
      return [] # not sure about this, added keys will not be marked as added

    errorsPaths = {}
    errors = []
    dataExpectedPointers = []

    # get all pointers in expected data
    traverse(@dataExpected).forEach (nodeValue) ->
      dataExpectedPointers.push jsonPointer.compile this.path
      return

    # path from real does not exits in expected data so it's addded
    traverse(@dataReal).forEach (nodeValue) ->
      if not (jsonPointer.compile(this.path) in dataExpectedPointers)
        errors.push {pathArray: this.path, value: nodeValue, 'state': 1, 'message': undefined}
      return

    # get unique paths in errors
    for error in @fieldResult.errors
      if error.location?.pointer? # drop non JSON related errors
        errorsPaths[error.location.pointer] = jsonPointer.parse error.location.pointer

    # get aggregated message and state for each error pointer/pathArray
    for pointer, pathArray of errorsPaths
      errors.push @getStateAndMessageFromResults pathArray: pathArray, lowerCasedKeys: false

    return errors

  #@private
  mapErrorsPositionByPath: (errors) ->
    map = {}
    position = 0

    for error in errors
      map[jsonPointer.compile error['pathArray']] = position
      position++

    return map

module.exports = JsonResultConverter

