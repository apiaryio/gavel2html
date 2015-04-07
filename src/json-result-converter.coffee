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
    if @usePointers
      errors = @getErrorsFromResults()
    else
      errors = @getErrors()

    closingBrackets = []
    typesOnLevels = {}
    @usedErrors = []
    errorsMap = @mapErrorsPositionByPath errors

    #traverse breaking context aagggrrrrr.....
    getIdent = @getIdentFunction @identString
    formatFragment = @formatFragmentFunction @

    usedErrors = @usedErrors

    for error in errors
      errorsPaths.push jsonPointer.compile error.pathArray

    traverse(@dataReal).forEach (nodeValue) ->
      openingBracket = ''
      errorOnThisPath = null
      closingBracketsStr = ''

      if (prevLevel > this.level) and closingBrackets.length
        for i in [this.level..prevLevel-1]
          closingBracketsStr += getIdent(prevLevel-i+1) + closingBrackets.pop()

          if typesOnLevels[prevLevel-i+1] == 'array'
            # remove last newline char
            closingBracketsStr = closingBracketsStr.substring(0, closingBracketsStr.length - 1)
            closingBracketsStr += ",\n"

          else if typesOnLevels[prevLevel-i+1] == 'object' and typesOnLevels[prevLevel-i] == 'array'
            # remove last newline char
            closingBracketsStr = closingBracketsStr.substring(0, closingBracketsStr.length - 1)
            closingBracketsStr += ",\n"

      typeOfNodeValue = null
      hasKeys = false
      if type.array nodeValue
        typeOfNodeValue = 'array'
        firstChar = '['
        lastChar = ']'
        if nodeValue.length
          hasKeys = true
      else if type.object nodeValue
        typeOfNodeValue = 'object'
        firstChar = '{'
        lastChar = '}'
        for own k, v of nodeValue
          hasKeys = true
          break

      if hasKeys and typeOfNodeValue
        openingBracket += getIdent(this.level) + firstChar
        closingBrackets.push "#{lastChar}\n"
        typesOnLevels[this.level+1] = typeOfNodeValue


      if this.isRoot
        format = false
        if typeof nodeValue is 'number'
          out +=  "#{nodeValue}"
          format = true
        else if typeof nodeValue is 'string'
          out += "\"#{nodeValue}\""
          format = true
        else if openingBracket
          out = openingBracket + "\n"


        if format
          errNo = errorsMap[jsonPointer.compile this.path]

          if errNo or errNo is 0
            errorOnThisPath = errors[errNo]
            if errorOnThisPath.state != 1 #added
              usedErrors.push jsonPointer.compile this.path

          if errorOnThisPath
            out = formatFragment fragment: out, message: errorOnThisPath.message?.replace('The undefined property', 'The property') , status: errorOnThisPath.state
          else
            out = formatFragment fragment: out, message: undefined, status: 0

      else
        if typesOnLevels[this.level] == 'array'
          key = ''
        else
          key = '"' + this.key + '": '

        keyValuePair =  getIdent(this.level) + key + "#{openingBracket}"

        if this.isLeaf
          if typeof nodeValue is 'number'
            keyValuePair += nodeValue
          else if Array.isArray nodeValue
            keyValuePair += JSON.stringify nodeValue
          else if typeof(nodeValue) == 'object'
            keyValuePair += JSON.stringify nodeValue
          else
            keyValuePair += '"' + nodeValue + '"'

        errNo = errorsMap[jsonPointer.compile this.path]

        if errNo or errNo is 0
          errorOnThisPath = errors[errNo]
          if errorOnThisPath.state != 1 #added
            usedErrors.push jsonPointer.compile this.path

        if errorOnThisPath
          keyValuePair = formatFragment fragment: keyValuePair, message: errorOnThisPath.message?.replace('The undefined property', 'The property'), status: errorOnThisPath.state
        else
          keyValuePair = formatFragment fragment: keyValuePair, message: undefined, status: 0

        if closingBracketsStr
          out += getIdent(this.level-1) + "#{closingBracketsStr}"

        # append comma if parent is array
        if typesOnLevels[this.level] == 'array' and typeof(nodeValue) != 'object'
          if parseInt(this.key) != this.parent.node.length - 1
            keyValuePair += ","

        out += keyValuePair + "\n"

      prevLevel = this.level
      prevNode = this.node

      return

    if prevLevel
      for i in [0..prevLevel-1]
        out += getIdent(prevLevel-i) + closingBrackets.pop()

    @usedErrors = usedErrors

    return out



  #@private
  formatFragmentFunction: (thisInstance) -> (options) ->
    thisInstance.formatFragment options

  #@private
  getIdentFunction: (identString) -> (level) ->
    if identString
      return (new Array(level)).join(identString)

    return ''

  #@private
  getErrors: ()->
    if not (@gavelResult.rawData and @gavelResult.rawData.length)
      return [] # not sure about this, added keys will not be marked as addeds

    amandaErrorsPaths = {}
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
    for i in [0..@gavelResult.rawData.length - 1]

      # get pointer from array and sanitize 'null' path array meant as root
      if @gavelResult.rawData[i]['property']
        pointer = jsonPointer.compile @gavelResult.rawData[i]['property']
      else
        pointer = ''

      if not amandaErrorsPaths[pointer]
        amandaErrorsPaths[pointer] = @gavelResult.rawData[i]['property'] or []

    # get aggregated message and state for each error pointer/pathArray
    for pointer, pathArray of amandaErrorsPaths
      errors.push @getStateAndMessageFromAmandaResult pathArray: pathArray, lowerCasedKeys: false

    return errors

  #@private
  getErrorsFromResults: () ->
    if @gavelResult.results.length == 0
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
    for result in @gavelResult.results
      if result['pointer']? # filter out non JSON related errors
        errorsPaths[result['pointer']] = jsonPointer.parse result['pointer']

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

