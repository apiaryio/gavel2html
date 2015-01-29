clone = require 'clone'
Converter = require './converter'

class HeadersResultConverter extends Converter
  #@protected
  getLinesFromAmandaResults: ->
    @dataReal = @getFromString @dataReal
    @dataExpected = @getFromString @dataExpected
    lowercasedReal = @getLowercased @dataReal
    lowercasedExpected = @getLowercased @dataExpected

    lowercasedExpectedKeys = Object.keys(lowercasedExpected)
    lowercasedReal = Object.keys(lowercasedReal)

    dataRealWithExpected = clone @dataReal
    for k, v of @dataExpected
      if not(k.toLowerCase() in lowercasedReal)
        dataRealWithExpected[k] = v

    lines = []

    for k, v of dataRealWithExpected
      #because we want also display added headers ;(
      if not(k.toLowerCase() in lowercasedExpectedKeys)
        lines.push {pathArray: [k], value: @dataReal[k], 'state': 1, 'message': undefined}
      else
        result = @getStateAndMessageFromAmandaResult pathArray: [k], lowerCasedKeys: true
        result['value'] = dataRealWithExpected[k]
        lines.push result

    return lines

  getHtmlPrivate:  ->
    lines = @getLinesFromAmandaResults()

    html = ''

    for line in lines
      html += @formatFragment {fragment: "#{line['pathArray']}: #{line['value']}", message: line['message'], status: line['state']}

    return html


  #http://www.w3.org/Protocols/rfc2616/rfc2616-sec4.html#sec4.2
  #@private
  getLowercased: (data) ->
    ret = {}

    for k, v of data
      if typeof(k) == 'string'
        ret[k.toLowerCase()] = v
      else
        ret[k] = v

    return ret

  #@private
  getFromString: (header) ->
    if not header or typeof header isnt 'string' then return header

    headersOut = {}

    for line in header.split('\n')
      separator = line.indexOf ':'
      if separator is -1 then continue
      key   = @trim line.slice 0, separator
      value = @trim line.slice separator+1
      headersOut[key] = value

    return headersOut

module.exports = HeadersResultConverter
