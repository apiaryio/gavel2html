# gavel2html

[![npm version](https://badge.fury.io/js/gavel2html.svg)](https://badge.fury.io/js/gavel2html)
[![Build Status](https://travis-ci.org/apiaryio/gavel2html.svg?branch=master)](https://travis-ci.org/apiaryio/gavel2html)
[![Build status](https://ci.appveyor.com/api/projects/status/1rj4gt5g5prjp5ah/branch/master?svg=true)](https://ci.appveyor.com/project/Apiary/gavel2html/branch/master)
[![Dependency Status](https://david-dm.org/apiaryio/gavel2html.svg)](https://david-dm.org/apiaryio/gavel2html)
[![devDependency Status](https://david-dm.org/apiaryio/gavel2html/dev-status.svg)](https://david-dm.org/apiaryio/gavel2html?type=dev)
[![Known Vulnerabilities](https://snyk.io/test/npm/gavel2html/badge.svg)](https://snyk.io/test/npm/gavel2html)

A utility library to render an HTML diff from the [Gavel.js][] validation results.

## Installation

```bash
npm install gavel2html
```

## Usage

```js
const gavel = require('gavel');
const Gavel2Html = require('gavel2html');

// Validate expected/actual HTTP transaction with Gavel.
const gavelResult = gavel(expected, actual);

const renderer = new Gavel2Html({
  // Pass the name of the field you wish to render
  fieldName: 'body',
  // ...and the validation result for that field
  fieldResult: gavelResult.fields.body,
});

const html = renderer.getHtml({
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
## API

### `Gavel2Html(options)`

Creates a renderer instance with the given options.

#### Options

```ts
{
  // Gavel validation results field name.
  // Affects the converter being used internally.
  fieldName: 'statusCode' | 'headers' | 'body'

  // Gavel validation results for the given `fieldName`.
  // Refer to the Gavel's documentation for more details.
  fieldResults: GavelFieldValidationResults

  // Use JSON pointers from the Gavel validation results
  // passed in the `fieldResults` option.
  usePointers?: boolean
}
```

### `getHtml(options): string`

Returns an HTML string representing the markup of the validation results data diff.

#### Options

```ts
{
  // String to wrap the outpout data with.
  // The "##data" acts as a placeholder that gets
  // substituted with the output results.
  // Example: <div>##data</div>.
  wrapWith?: string = '##data'
  startTag?: string = '<li>'
  endTag?: string = '</li>'
  jsonKeyStartTag?: string = ''
  jsonKeyEndTag?: string = ''

  // String to use at the beginning of
  // a missing sequence of characters.
  missingStartTag?: string

  // String to use at the beginning of
  // an added sequence of characters.
  addedStartTag?: string

  // String to use as a start when marking
  // a changed sequence of characters.
  changedStartTag?: string

  // Include comments in the output.
  comments?: boolean
  commentStartTag?: string
  commentEndTag?: string

  // String to use as a one level of indentation.
  identString?: string = '  '
}
```

[Gavel.js]: https://github.com/apiaryio/gavel.js
