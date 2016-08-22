# gavel2html

[![npm version](https://badge.fury.io/js/gavel2html.svg)](https://badge.fury.io/js/gavel2html)
[![Build Status](https://travis-ci.org/apiaryio/gavel2html.svg?branch=master)](https://travis-ci.org/apiaryio/gavel2html)
[![Build status](https://ci.appveyor.com/api/projects/status/1rj4gt5g5prjp5ah/branch/master?svg=true)](https://ci.appveyor.com/project/Apiary/gavel2html/branch/master)
[![Dependency Status](https://david-dm.org/apiaryio/gavel2html.svg)](https://david-dm.org/apiaryio/gavel2html)
[![devDependency Status](https://david-dm.org/apiaryio/gavel2html/dev-status.svg)](https://david-dm.org/apiaryio/gavel2html#info=devDependencies)
[![Known Vulnerabilities](https://snyk.io/test/npm/gavel2html/badge.svg)](https://snyk.io/test/npm/gavel2html)

The `gavel2html` utility renders HTML diff from [Gavel.js][] output.

## Installation

```
npm install gavel2html
```

## Usage

```javascript
Gavel2Html = require('gavel2html');

const gavel2html = new Gavel2Html({
  dataReal: '{"name": "hell"}',
  dataExpected: '{"name": "hello"}',
});

const html = gavel2html.getHtml({
  wrapWith: '##data',
  startTag: '<span>',
  endTag: '</span>',
  missingStartTag: '<span class="missing">',
  addedStartTag: '<span class="added">',
  changedStartTag: '<span class="changed">',
  comments: true,
  commentStartTag: '<span class="comments">',
  commentEndTag: '</span>',
  identString: '  '
});

console.log(html);
```

```
<span>{&quot;name&quot;: &quot;hell</span><span class="missing">o</span><span>&quot;}</span>
```

### Options

- `dataReal` (string, required) - Actual body data
- `dataExpected` (string, required) - Expected body data
- `gavelResult` (object) - Validation object, output from [Gavel.js][]
- `usePointers`: true (boolean, default) - Whether to use JSON pointers from 'results' key in Gavel data to not to rely on Amanda's data

### `getHtml` options

- `wrapWith` (string)
- `startTag` (string)
- `endTag` (string)
- `missingStartTag` (string) - String to be used as a start when marking _missing_ sequence of characters.
- `addedStartTag` (string) - String to be used as a start when marking _added_ sequence of characters.
- `changedStartTag` (string) - String to be used as a start when marking _changed_ sequence of characters.
- `comments` (boolean)
- `commentStartTag` (string)
- `commentEndTag` (string)
- `identString` (string) - String to use for one level of indentation.

> **Note:** The gavel2html library is underdocumented. Please see [#7](https://github.com/apiaryio/gavel2html/issues/7) for details.


[Gavel.js]: https://github.com/apiaryio/gavel.js
