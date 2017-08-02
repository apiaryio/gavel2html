{assert} = require('chai')

Gavel2Html = require('../../src/index')


describe('Regression Tests', ->
  describe('application/json', ->
    body = JSON.stringify([
      {
        "question": "Favourite programming language?",
        "published_at": "2015-08-05T08:40:51.620Z",
        "choices": [
          {
            "choice": "Swift",
            "votes": 2048
          },
          {
            "choice": "Python",
            "votes": 1024
          },
          {
            "choice": "Objective-C",
            "votes": 512
          },
          {
            "choice": "Ruby",
            "votes": 256
          }
        ]
      }
    ], null, 4)

    gavel2html = new Gavel2Html(
      dataReal: body
      dataExpected: body
      gavelResult:
        rawData: {length: 0}
        validator: 'JsonExample'
        expectedType: 'application/json'
        realType: 'application/json'
        results: []
      usePointers: true
    )
    html = gavel2html.getHtml({
      wrapWith: '##data'
      startTag: '<li>'
      endTag: '</li>'
      missingStartTag: '<li class="delete inline">'
      addedStartTag: '<li class="insert inline">'
      changedStartTag: '<li class="modify inline">'
      comments: true,
      commentStartTag: '<span class="modify inline">'
      commentEndTag: '</span>'
    })

    it('renders HTML in an expected format', ->
      assert.equal(html, '''\
        <li>[</li>
        <li>  {</li>
        <li>    &quot;question&quot;: &quot;Favourite programming language?&quot;,</li>
        <li>    &quot;published_at&quot;: &quot;2015-08-05T08:40:51.620Z&quot;,</li>
        <li>    &quot;choices&quot;: [</li>
        <li>      {</li>
        <li>        &quot;choice&quot;: &quot;Swift&quot;,</li>
        <li>        &quot;votes&quot;: 2048</li>
        <li>      },</li>
        <li>      {</li>
        <li>        &quot;choice&quot;: &quot;Python&quot;,</li>
        <li>        &quot;votes&quot;: 1024</li>
        <li>      },</li>
        <li>      {</li>
        <li>        &quot;choice&quot;: &quot;Objective-C&quot;,</li>
        <li>        &quot;votes&quot;: 512</li>
        <li>      },</li>
        <li>      {</li>
        <li>        &quot;choice&quot;: &quot;Ruby&quot;,</li>
        <li>        &quot;votes&quot;: 256</li>
        <li>      }</li>
        <li>    ]</li>
        <li>  }</li>
        <li>]</li>\
      ''')
    )
  )

  describe('application/vnd.apiary.http-headers+json', ->
    gavel2html = new Gavel2Html(
      dataReal:
        'Content-Type': 'application/json'
        'Access-Control-Allow-Origin': '*'
        'Access-Control-Allow-Methods': 'OPTIONS,GET,HEAD,POST,PUT,DELETE,TRACE,CONNECT'
        'Access-Control-Max-Age': 10
        'x-apiary-transaction-id': '598089e808a408eb42bec1d5'
        'Content-Length': 496
      dataExpected:
        'Content-Type': 'application/json'
      gavelResult:
        rawData: {length: 0}
        validator: 'HeadersJsonExample'
        expectedType: 'application/vnd.apiary.http-headers+json'
        realType: 'application/vnd.apiary.http-headers+json'
        results: []
      usePointers: true
    )
    html = gavel2html.getHtml({
      wrapWith: '##data'
      startTag: '<li>'
      endTag: '</li>'
      missingStartTag: '<li class="delete" title="This line is missing">'
      addedStartTag: '<li class="insert" title="This is an extra line that wasn\'t documented, but it\'s probably OK">'
      changedStartTag: '<li class="modify" title="Warning! This is different value">'
      comments: false
      commentStartTag: '<span>'
      commentEndTag: '</span>'
    })

    it('renders HTML in an expected format', ->
      assert.equal(html, [
        '<li>Content-Type: application/json</li>'
        '<li class="insert" title="This is an extra line that wasn\'t documented, but it\'s probably OK">Access-Control-Allow-Origin: *</li>'
        '<li class="insert" title="This is an extra line that wasn\'t documented, but it\'s probably OK">Access-Control-Allow-Methods: OPTIONS,GET,HEAD,POST,PUT,DELETE,TRACE,CONNECT</li>'
        '<li class="insert" title="This is an extra line that wasn\'t documented, but it\'s probably OK">Access-Control-Max-Age: 10</li>'
        '<li class="insert" title="This is an extra line that wasn\'t documented, but it\'s probably OK">x-apiary-transaction-id: 598089e808a408eb42bec1d5</li>'
        '<li class="insert" title="This is an extra line that wasn\'t documented, but it\'s probably OK">Content-Length: 496</li>'
      ].join(''))
    )
  )
)
