clone = require 'clone'
Converter = require './converter'

class HeadersResultConverter extends Converter
  #@protected
  getLinesFromResults: ->
    @_getLines()

  #@private
  _getLines: ->
    lineResultGetter = @getStateAndMessageFromResults

    @dataReal     = @getFromString @dataReal
    @dataExpected = @getFromString @dataExpected

    lowercasedExpectedKeys = Object.keys(@dataExpected).map (s) -> s.toLowerCase()
    lowercasedRealKeys     = Object.keys(@dataReal).map (s) -> s.toLowerCase()

    dataRealWithExpected = clone @dataReal, false

    for expectedKey, expectedValue of @dataExpected
      if expectedKey.toLowerCase() not in lowercasedRealKeys
        dataRealWithExpected[expectedKey] = expectedValue

    lines = []

    for k, v of dataRealWithExpected then do (k, v) =>
      #because we want also display added headers ;(
      if k.toLowerCase() not in lowercasedExpectedKeys
        lines.push {pathArray: [k], value: @dataReal[k], 'state': 1, 'message': undefined}
      else
        result = lineResultGetter.call @, pathArray: [k], lowerCasedKeys: true

        result['value'] = v
        lines.push result

    return lines


  getHtmlPrivate: ->
    lines = @_getLines()

    html = ''

    canOmitSanitize = @jsonKeyEndTag and @jsonKeyStartTag

    for line in lines
      lineKey = line['pathArray']
      lineVal = line['value']
      if canOmitSanitize
        lineKey = @sanitize lineKey
        lineVal = @sanitize lineVal

      html += @formatFragment {
        omitSanitize: canOmitSanitize
        fragment: "#{@jsonKeyStartTag or ''}#{lineKey}#{@jsonKeyEndTag or ''}: #{lineVal}"
        message: line['message']
        status: line['state']
      }

    return html


  #@private
  getFromString: (header) ->
    # In case header is not set for whichever reason
    # fallback to an empty object, not to break headers handling.
    if not header
      return {}
    else if typeof header isnt 'string'
      return header

    headersOut = {}

    for line in header.split('\n')
      separator = line.indexOf ':'
      if separator is -1 then continue
      key   = line.slice(0, separator).trim()
      value = line.slice(separator+1).trim()
      headersOut[key] = value

    return headersOut

module.exports = HeadersResultConverter
