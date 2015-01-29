[![Build Status](https://travis-ci.org/apiaryio/gavel2html.svg)](https://travis-ci.org/apiaryio/gavel2html)

# gavel2html

Convert output from [Gavel](https://github.com/apiaryio/gavel.js) to HTML

## Installation

```
npm install gavel2html
```

## Usage

```javascript
Gavel2Html = require('gavel2html');

g2h = Gavel2Html.new({
  // string - containing real data
  "realData": real,

  // string - containing expected data
  "expectedData": expected,

  // object - with output from Gavel
  "gavelOutput": gavelOutput,

  // boolean - use JSON pointers from 'resulults' key in gavel data to do not rely on Amanda's data
  "usePointers": true
});

html = g2h.getHtml({
  "wrapWith": '##data',
  "startTag": '<span>',
  "endTag": '</span>',
  "missingStartTag": '<span class="missing">',
  "addedStartTag": '<span class="added">',
  "changedStartTag": '<span class="changed">',
  "comments": true,
  "commentStartTag": '<span class="comments">',
  "commentEndTag": '</span>',
  "identString": '  '
});
```