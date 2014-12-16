module.exports = (body, sanitizer, escapeBasicHtml) ->
  try
    value = decodeURIComponent encodeURIComponent body
    value = sanitizer.html_sanitize escapeBasicHtml value
  catch errz
    value = "[binary data]"
  return value