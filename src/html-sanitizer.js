{
  var html4 = {}, html, html_sanitize;
  html4.atype = {
    'NONE': 0,
    'URI': 1,
    'URI_FRAGMENT': 11,
    'SCRIPT': 2,
    'STYLE': 3,
    'ID': 4,
    'IDREF': 5,
    'IDREFS': 6,
    'GLOBAL_NAME': 7,
    'LOCAL_NAME': 8,
    'CLASSES': 9,
    'FRAME_TARGET': 10
  }, html4.ATTRIBS = {
    '*::onload': 2
  }, html4.eflags = {
    'OPTIONAL_ENDTAG': 1,
    'EMPTY': 2,
    'CDATA': 4,
    'RCDATA': 8,
    'UNSAFE': 16,
    'FOLDABLE': 32,
    'SCRIPT': 64,
    'STYLE': 128
  }, html4.ELEMENTS = {
    'a': 16,
    'abbr': 16,
    'acronym': 16,
    'address': 16,
    'applet': 16,
    'area': 18,
    'b': 16,
    'base': 18,
    'basefont': 18,
    'bdo': 16,
    'big': 16,
    'blockquote': 16,
    'body': 49,
    'br': 18,
    'button': 16,
    'canvas': 16,
    'caption': 16,
    'center': 16,
    'cite': 16,
    'code': 16,
    'col': 18,
    'colgroup': 17,
    'dd': 17,
    'del': 16,
    'dfn': 16,
    'dir': 16,
    'div': 16,
    'dl': 16,
    'dt': 17,
    'em': 16,
    'fieldset': 16,
    'font': 16,
    'form': 16,
    'frame': 18,
    'frameset': 16,
    'h1': 16,
    'h2': 16,
    'h3': 16,
    'h4': 16,
    'h5': 16,
    'h6': 16,
    'head': 49,
    'hr': 18,
    'html': 49,
    'i': 16,
    'iframe': 20,
    'img': 18,
    'input': 18,
    'ins': 16,
    'isindex': 18,
    'kbd': 16,
    'label': 16,
    'legend': 16,
    'li': 17,
    'link': 18,
    'map': 16,
    'menu': 16,
    'meta': 18,
    'nav': 16,
    'nobr': 16,
    'noembed': 20,
    'noframes': 20,
    'noscript': 20,
    'object': 16,
    'ol': 16,
    'optgroup': 16,
    'option': 17,
    'p': 17,
    'param': 18,
    'pre': 16,
    'q': 16,
    's': 16,
    'samp': 16,
    'script': 84,
    'select': 16,
    'small': 16,
    'span': 16,
    'strike': 16,
    'strong': 16,
    'style': 148,
    'sub': 16,
    'sup': 16,
    'table': 16,
    'tbody': 17,
    'td': 17,
    'textarea': 24,
    'tfoot': 17,
    'th': 17,
    'thead': 17,
    'title': 24,
    'tr': 17,
    'tt': 16,
    'u': 16,
    'ul': 16,
    'var': 16
  }, html4.ueffects = {
    'NOT_LOADED': 0,
    'SAME_DOCUMENT': 1,
    'NEW_DOCUMENT': 2
  }, html4.URIEFFECTS = {}, html4.ltypes = {
    'UNSANDBOXED': 2,
    'SANDBOXED': 1,
    'DATA': 0
  }, html4.LOADERTYPES = {}, typeof
  window !== 'undefined' && (window['html4'] = html4), html = (function (html4) {
    var ALLOWED_URI_SCHEMES, ATTR_RE, EFLAGS_TEXT, ENTITIES, ENTITY_RE, URI_SCHEME_RE, ampRe, cssSchema, decimalEscapeRe, endTagRe, entityRe, gtRe, hexEscapeRe, lcase, looseAmpRe, ltRe, nulRe, parseCssDeclarations, quotRe, sanitizeCssProperty, splitWillCapture;
    'undefined' !== typeof
    window && (parseCssDeclarations = window['parseCssDeclarations'], sanitizeCssProperty = window['sanitizeCssProperty'], cssSchema = window['cssSchema']), 'script' === 'SCRIPT'.toLowerCase() ? (lcase = function (s) {
      return s.toLowerCase()
    }) : (lcase = function (s) {
      return s.replace(/[A-Z]/g, function (ch) {
        return String.fromCharCode(ch.charCodeAt(0) | 32)
      })
    }), ENTITIES = {
      'lt': '\x3c',
      'gt': '\x3e',
      'amp': '\x26',
      'nbsp': '\xa0',
      'quot': '\"',
      'apos': '\''
    }, decimalEscapeRe = /^#(\d+)$/, hexEscapeRe = /^#x([0-9A-Fa-f]+)$/;

    function
    lookupEntity(name) {
      var m;
      return name = lcase(name), ENTITIES.hasOwnProperty(name) ? ENTITIES[name] : (m = name.match(decimalEscapeRe), m ? String.fromCharCode(parseInt(m[1], 10)) : (m = name.match(hexEscapeRe)) ? String.fromCharCode(parseInt(m[1], 16)) : '')
    }

    function
    decodeOneEntity(_, name) {
      return lookupEntity(name)
    }
    nulRe = /\0/g;

    function stripNULs(s) {
      return s.replace(nulRe, '')
    }
    entityRe = /\x26(#\d+|#x[0-9A-Fa-f]+|\w+);/g;

    function
    unescapeEntities(s) {
      return s.replace(entityRe, decodeOneEntity)
    }
    ampRe = /\x26/g, looseAmpRe = /\x26([^a-z#]|#(?:[^0-9x]|x(?:[^0-9a-f]|$)|$)|$)/gi, ltRe = /[\x3c]/g, gtRe = /\x3e/g, quotRe = /\"/g;

    function
    escapeAttrib(s) {
      return ('' + s).replace(ampRe, '\x26amp;').replace(ltRe, '\x26lt;').replace(gtRe, '\x26gt;').replace(quotRe, '\x26#34;')
    }

    function
    normalizeRCData(rcdata) {
      return rcdata.replace(looseAmpRe, '\x26amp;$1').replace(ltRe, '\x26lt;').replace(gtRe, '\x26gt;')
    }
    ATTR_RE = new
    RegExp('^\\s*([a-z][a-z-]*)(?:\\s*(=)\\s*((\")[^\"]*(\"|$)|(\')[^\']*(\'|$)|(?=[a-z][a-z-]*\\s*=)|[^\"\'\\s]*))?', 'i'), ENTITY_RE = /^(#[0-9]+|#x[0-9a-f]+|\w+);/i, splitWillCapture = 'a,b'.split(/(,)/).length === 3, EFLAGS_TEXT = html4.eflags.CDATA | html4.eflags.RCDATA;

    function
    makeSaxParser(handler) {
      return function (htmlText, param) {
        return parse(htmlText, handler, param)
      }
    }

    function
    parse(htmlText, handler, param) {
      var h = handler,
        current, eflags, end, m, next, noMoreEndComments, noMoreGT, p, parts, pos, tag, tagName;
      h.startDoc && h.startDoc(param), parts = htmlSplit(htmlText), noMoreGT = false, noMoreEndComments = false;
      for (pos = 0, end = parts.length; pos < end;) {
        current = parts[pos++], next = parts[pos];
        switch (current) {
          case '\x26':
            ENTITY_RE.test(next) ? (h.pcdata && h.pcdata('\x26' + next, param), ++pos) : h.pcdata && h.pcdata('\x26amp;', param);
            break;
          case '\x3c/':
            (m = /^(\w+)[^\'\"]*/.exec(next)) ? m[0].length === next.length && parts[pos + 1] === '\x3e' ? (pos += 2, tagName = lcase(m[1]), html4.ELEMENTS.hasOwnProperty(tagName) && (h.endTag && h.endTag(tagName, param))) : (pos = parseEndTag(parts, pos, h, param)) : h.pcdata && h.pcdata('\x26lt;/', param);
            break;
          case '\x3c':
            (m = /^(\w+)\s*\/?/.exec(next)) ? m[0].length === next.length && parts[pos + 1] === '\x3e' ? (pos += 2, tagName = lcase(m[1]), html4.ELEMENTS.hasOwnProperty(tagName) && (h.startTag && h.startTag(tagName, [], param), eflags = html4.ELEMENTS[tagName], eflags & EFLAGS_TEXT && (tag = {
              'name': tagName,
              'next': pos,
              'eflags': eflags
            }, pos = parseText(parts, tag, h, param)))) : (pos = parseStartTag(parts, pos, h, param)) : h.pcdata && h.pcdata('\x26lt;', param);
            break;
          case '\x3c!--':
            if (!noMoreEndComments) {
              for (p = pos + 1; p < end; ++p) if (parts[p] === '\x3e' && /--$/.test(parts[p - 1])) break;
              p < end ? (pos = p + 1) : (noMoreEndComments = true)
            }
            noMoreEndComments && (h.pcdata && h.pcdata('\x26lt;!--', param));
            break;
          case '\x3c!':
            if (!/^\w/.test(next)) h.pcdata && h.pcdata('\x26lt;!', param);
            else {
              if (!noMoreGT) {
                for (p = pos + 1; p < end; ++p) if (parts[p] === '\x3e') break;
                p < end ? (pos = p + 1) : (noMoreGT = true)
              }
              noMoreGT && (h.pcdata && h.pcdata('\x26lt;!', param))
            }
            break;
          case '\x3c?':
            if (!noMoreGT) {
              for (p = pos + 1; p < end; ++p) if (parts[p] === '\x3e') break;
              p < end ? (pos = p + 1) : (noMoreGT = true)
            }
            noMoreGT && (h.pcdata && h.pcdata('\x26lt;?', param));
            break;
          case '\x3e':
            h.pcdata && h.pcdata('\x26gt;', param);
            break;
          case '':
            break;
          default:
            h.pcdata && h.pcdata(current, param)
        }
      }
      h.endDoc && h.endDoc(param)
    }

    function
    htmlSplit(str) {
      var re = /(\x3c\/|\x3c\!--|\x3c[!?]|[\x26\x3c\x3e])/g,
        lastPos, m, parts;
      str += '';
      if (splitWillCapture) return str.split(re);
      parts = [], lastPos = 0;
      while ((m = re.exec(str)) !== null) parts.push(str.substring(lastPos, m.index)), parts.push(m[0]), lastPos = m.index + m[0].length;
      return parts.push(str.substring(lastPos)), parts
    }

    function
    parseEndTag(parts, pos, h, param) {
      var tag = parseTagAndAttrs(parts, pos);
      return tag ? (tag.eflags !== void
      0 && (h.endTag && h.endTag(tag.name, param)), tag.next) : parts.length
    }

    function parseStartTag(parts, pos, h, param) {
      var
      tag = parseTagAndAttrs(parts, pos);
      if (!tag) return parts.length;
      if (tag.eflags !== void
      0) {
        h.startTag && h.startTag(tag.name, tag.attrs, param);
        if (tag.eflags & EFLAGS_TEXT) return parseText(parts, tag, h, param)
      }
      return tag.next
    }
    endTagRe = {};

    function
    parseText(parts, tag, h, param) {
      var end = parts.length,
        buf, first, p, re;
      endTagRe.hasOwnProperty(tag.name) || (endTagRe[tag.name] = new
      RegExp('^' + tag.name + '(?:[\\s\\/]|$)', 'i')), re = endTagRe[tag.name], first = tag.next, p = tag.next + 1;
      for (; p < end; ++p) if (parts[p - 1] === '\x3c/' && re.test(parts[p])) break;
      p < end && (p -= 1), buf = parts.slice(first, p).join('');
      if (tag.eflags & html4.eflags.CDATA) h.cdata && h.cdata(buf, param);
      else if (tag.eflags & html4.eflags.RCDATA) h.rcdata && h.rcdata(normalizeRCData(buf), param);
      else throw new Error('bug');
      return p
    }

    function parseTagAndAttrs(parts, pos) {
      var m = /^(\w+)/.exec(parts[pos]),
        tag = {
          'name': lcase(m[1])
        }, aName, aValue, abuf, attrs, buf, end, p, quote, sawQuote;
      html4.ELEMENTS.hasOwnProperty(tag.name) ? (tag.eflags = html4.ELEMENTS[tag.name]) : (tag.eflags = void
      0), buf = parts[pos].substr(m[0].length), p = pos + 1, end = parts.length;
      for (; p < end; ++p) {
        if (parts[p] === '\x3e') break;
        buf += parts[p]
      }
      if (end <= p) return;
      attrs = [];
      while (buf !== '') {
        m = ATTR_RE.exec(buf);
        if (!m) buf = buf.replace(/^[\s\S][^a-z\s]*/, '');
        else if (m[4] && !m[5] || m[6] && !m[7]) {
          quote = m[4] || m[6], sawQuote = false, abuf = [buf, parts[p++]];
          for (; p < end; ++p) {
            if (sawQuote) {
              if (parts[p] === '\x3e') break
            } else if (0 <= parts[p].indexOf(quote)) sawQuote = true;
            abuf.push(parts[p])
          }
          if (end <= p) break;
          buf = abuf.join('');
          continue
        } else aName = lcase(m[1]), aValue = m[2] ? decodeValue(m[3]) : aName, attrs.push(aName, aValue), buf = buf.substr(m[0].length)
      }
      return tag.attrs = attrs, tag.next = p + 1, tag
    }

    function
    decodeValue(v) {
      var q = v.charCodeAt(0);
      return (q === 34 || q === 39) && (v = v.substr(1, v.length - 2)), unescapeEntities(stripNULs(v))
    }

    function
    makeHtmlSanitizer(tagPolicy) {
      var emit = function (text, out) {
        ignoring || out.push(text)
      }, ignoring, stack;
      return makeSaxParser({
        'startDoc': function (_) {
          stack = [], ignoring = false
        },
        'startTag': function (tagName, attribs, out) {
          var
          attribName, eflags, i, n, value;
          if (ignoring) return;
          if (!html4.ELEMENTS.hasOwnProperty(tagName)) return;
          eflags = html4.ELEMENTS[tagName];
          if (eflags & html4.eflags.FOLDABLE) return;
          attribs = tagPolicy(tagName, attribs);
          if (!attribs) return ignoring = !(eflags & html4.eflags.EMPTY), void
          0;
          eflags & html4.eflags.EMPTY || stack.push(tagName), out.push('\x3c', tagName);
          for (i = 0, n = attribs.length; i < n; i += 2) attribName = attribs[i], value = attribs[i + 1], value !== null && value !== void
          0 && out.push(' ', attribName, '=\"', escapeAttrib(value), '\"');
          out.push('\x3e')
        },
        'endTag': function (tagName, out) {
          var
          eflags, i, index, stackEl;
          if (ignoring) return ignoring = false, void 0;
          if (!html4.ELEMENTS.hasOwnProperty(tagName)) return;
          eflags = html4.ELEMENTS[tagName];
          if (!(eflags & (html4.eflags.EMPTY | html4.eflags.FOLDABLE))) {
            if (eflags & html4.eflags.OPTIONAL_ENDTAG) for (index = stack.length; --index >= 0;) {
              stackEl = stack[index];
              if (stackEl === tagName) break;
              if (!(html4.ELEMENTS[stackEl] & html4.eflags.OPTIONAL_ENDTAG)) return
            } else for (index = stack.length; --index >= 0;) if (stack[index] === tagName) break;
            if (index < 0) return;
            for (i = stack.length; --i > index;) stackEl = stack[i], html4.ELEMENTS[stackEl] & html4.eflags.OPTIONAL_ENDTAG || out.push('\x3c/', stackEl, '\x3e');
            stack.length = index, out.push('\x3c/', tagName, '\x3e')
          }
        },
        'pcdata': emit,
        'rcdata': emit,
        'cdata': emit,
        'endDoc': function (out) {
          for (; stack.length; --stack.length) out.push('\x3c/', stack[stack.length - 1], '\x3e')
        }
      })
    }
    URI_SCHEME_RE = new
    RegExp('^(?:([^:/?# ]+):)?'), ALLOWED_URI_SCHEMES = /^(?:https?|mailto)$/i;

    function
    safeUri(uri, naiveUriRewriter) {
      var parsed;
      return naiveUriRewriter ? (parsed = ('' + uri).match(URI_SCHEME_RE), parsed && (!parsed[1] || ALLOWED_URI_SCHEMES.test(parsed[1])) ? naiveUriRewriter(uri) : null) : null
    }

    function
    sanitizeAttribs(tagName, attribs, opt_naiveUriRewriter, opt_nmTokenPolicy) {
      var attribKey, attribName, atype, i, sanitizedDeclarations, value;
      for (i = 0; i < attribs.length; i += 2) {
        attribName = attribs[i], value = attribs[i + 1], atype = null, ((attribKey = tagName + '::' + attribName, html4.ATTRIBS.hasOwnProperty(attribKey)) || (attribKey = '*::' + attribName, html4.ATTRIBS.hasOwnProperty(attribKey))) && (atype = html4.ATTRIBS[attribKey]);
        if (atype !== null) switch (atype) {
          case
          html4.atype.NONE:
            break;
          case html4.atype.SCRIPT:
            value = null;
            break;
          case html4.atype.STYLE:
            if ('undefined' === typeof
            parseCssDeclarations) {
              value = null;
              break
            }
            sanitizedDeclarations = [], parseCssDeclarations(value, {
              'declaration': function (property, tokens) {
                var
                normProp = property.toLowerCase(),
                  schema = cssSchema[normProp];
                if (!schema) return;
                sanitizeCssProperty(normProp, schema, tokens, opt_naiveUriRewriter), sanitizedDeclarations.push(property + ': ' + tokens.join(' '))
              }
            }), value = sanitizedDeclarations.length > 0 ? sanitizedDeclarations.join(' ; ') : null;
            break;
          case
          html4.atype.ID:
          case html4.atype.IDREF:
          case html4.atype.IDREFS:
          case html4.atype.GLOBAL_NAME:
          case
          html4.atype.LOCAL_NAME:
          case html4.atype.CLASSES:
            value = opt_nmTokenPolicy ? opt_nmTokenPolicy(value) : value;
            break;
          case
          html4.atype.URI:
            value = safeUri(value, opt_naiveUriRewriter);
            break;
          case html4.atype.URI_FRAGMENT:
            value && '#' === value.charAt(0) ? (value = value.substring(1), value = opt_nmTokenPolicy ? opt_nmTokenPolicy(value) : value, value !== null && value !== void
            0 && (value = '#' + value)) : (value = null);
            break;
          default:
            value = null
        } else value = null;
        attribs[i + 1] = value
      }
      return attribs
    }

    function
    makeTagPolicy(opt_naiveUriRewriter, opt_nmTokenPolicy) {
      return function (tagName, attribs) {
        if (!(html4.ELEMENTS[tagName] & html4.eflags.UNSAFE)) return sanitizeAttribs(tagName, attribs, opt_naiveUriRewriter, opt_nmTokenPolicy)
      }
    }

    function
    sanitizeWithPolicy(inputHtml, tagPolicy) {
      var outputArray = [];
      return makeHtmlSanitizer(tagPolicy)(inputHtml, outputArray), outputArray.join('')
    }

    function
    sanitize(inputHtml, opt_naiveUriRewriter, opt_nmTokenPolicy) {
      var tagPolicy = makeTagPolicy(opt_naiveUriRewriter, opt_nmTokenPolicy);
      return sanitizeWithPolicy(inputHtml, tagPolicy)
    }
    return {
      'escapeAttrib': escapeAttrib,
      'makeHtmlSanitizer': makeHtmlSanitizer,
      'makeSaxParser': makeSaxParser,
      'makeTagPolicy': makeTagPolicy,
      'normalizeRCData': normalizeRCData,
      'sanitize': sanitize,
      'sanitizeAttribs': sanitizeAttribs,
      'sanitizeWithPolicy': sanitizeWithPolicy,
      'unescapeEntities': unescapeEntities
    }
  })(html4), html_sanitize = html.sanitize, typeof
  window !== 'undefined' && (window['html'] = html, window['html_sanitize'] = html_sanitize);
  exports !== 'undefined', exports.html_sanitize = html_sanitize
}