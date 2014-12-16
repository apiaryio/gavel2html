DiffMatchPatch  = require 'googlediff'

Converter = require './converter'

class TextResultConverter extends Converter
  #@protected
  getHtmlPrivate:  ->
    if @dataExpected is @dataReal
      return @sanitize(@dataReal)


    dmp = new DiffMatchPatch

    #this should be provided by gavel !!!
    dataError = false
    diffError = false
    try
      if typeof(@dataExpected) != 'string'
        @dataExpected  = JSON.stringify @dataExpected
    catch e
      dataError = true

    try
      if typeof(@dataReal) != 'string'
        @dataReal  = JSON.stringify @dataReal
    catch e
      dataError = true

    html = ''

    try
      diffs = dmp.diff_main @dataExpected, @dataReal, true
    catch e
      diffError = true

    if dataError
      html += @formatFragment {fragment: "Malformed data error\n\n", status: -1}

    if not diffError
      for diff in diffs
        html += @formatFragment {fragment: diff[1], status: diff[0]}
    else
      html += @formatFragment {fragment: "Internal validator error\n\n", status: -1}
      html += @formatFragment {fragment: @dataReal, status: -1}

    return html

module.exports = TextResultConverter
