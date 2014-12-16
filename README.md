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

g2h = Gavel2Html.new(realData, expectedData, gavelOutput);

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