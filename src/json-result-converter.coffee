traverse = require 'traverse'
jsonPointer = require 'json-pointer'

Converter = require './converter'

class JsonResultConverter extends Converter
  #@protected
  getHtmlPrivate:  ->
    out = ''
    prevLevel = 0
    prevNode = null
    errorsPaths = []
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

      firstChar = JSON.stringify(nodeValue)[0]

      if firstChar == '{' and Object.keys(nodeValue).length
        openingBracket += getIdent(this.level) + firstChar
        closingBrackets.push "}\n"
        typesOnLevels[this.level+1] = 'object'
      if firstChar == '[' and nodeValue.length
        openingBracket += getIdent(this.level) + firstChar
        closingBrackets.push "]\n"
        typesOnLevels[this.level+1] = 'array'


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
  formatFragmentFunction: (thisInstance) -> ({fragment, message, status}) ->
    thisInstance.formatFragment fragment: fragment, message: message, status: status

  #@private
  getIdentFunction: (identString) -> (level) ->
    if identString
      return (new Array(level)).join(identString)

    return ''

  #@private
  getErrors: ()->
    if not (@gavelResult.rawData and @gavelResult.rawData.length)
      return []

    amandaErrorsPaths = {}
    errors = []
    dataExpectedPaths = []

    traverse(@dataExpected).forEach (nodeValue) ->
      dataExpectedPaths.push jsonPointer.compile this.path
      return

    traverse(@dataReal).forEach (nodeValue) ->
      if not (jsonPointer.compile(this.path) in dataExpectedPaths)
        errors.push {pathArray: this.path, value: nodeValue, 'state': 1, 'message': undefined}
      return

    for i in [0..@gavelResult.rawData.length - 1]
      if @gavelResult.rawData[i]['property']
        pointer = jsonPointer.compile @gavelResult.rawData[i]['property']
      else
        pointer = '/'
      if not amandaErrorsPaths[pointer]
        amandaErrorsPaths[pointer] = @gavelResult.rawData[i]['property'] or []

    for k,v of amandaErrorsPaths
      errors.push @getStateAndMessageFromAmandaResult pathArray: v, amandaResult: @gavelResult.rawData, lowerCasedKeys: false

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

