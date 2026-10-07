/// Cleans up text users paste in from web pages (articles, chats, docs)
/// before it's sent to the server.
///
/// Web-pasted content commonly carries "smart" typography (curly quotes,
/// em/en dashes, ellipsis), non-breaking/invisible Unicode spacing, and
/// zero-width formatting characters -- none of that is special-cased by
/// this app's server, so it's normalized to plain ASCII equivalents here.
///
/// Several repo methods in this app build their request body by
/// interpolating raw strings into a hand-rolled JSON literal instead of
/// calling `jsonEncode` (e.g. `'"FIELD":"$value"'`). An unescaped `"`, `\`
/// or raw newline in pasted text silently breaks that JSON, so this also
/// escapes what's left for safe embedding in that pattern specifically.
class TextSanitizer {
  TextSanitizer._();

  static final RegExp _curlySingleQuotes = RegExp(r'[‘’‚‛]');
  static final RegExp _curlyDoubleQuotes = RegExp(r'[“”„‟]');
  static final RegExp _dashes = RegExp(r'[‒–—―]');
  static final RegExp _unicodeSpaces =
      RegExp(r'[  -   　]');
  static final RegExp _invisibleFormatting = RegExp(r'[​-‍﻿]');
  static final RegExp _controlChars = RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]');

  /// Normalizes web-paste typography/whitespace and drops invisible
  /// formatting/control characters. Safe to use anywhere, independent of
  /// how the result is later transmitted.
  static String normalize(String input) {
    return input
        .replaceAll(_curlySingleQuotes, "'")
        .replaceAll(_curlyDoubleQuotes, '"')
        .replaceAll(_dashes, '-')
        .replaceAll('…', '...')
        .replaceAll(_unicodeSpaces, ' ')
        .replaceAll(_invisibleFormatting, '')
        .replaceAll(_controlChars, '');
  }

  /// [normalize], then escapes `\`, `"` and newlines so the result can be
  /// embedded directly inside one of this app's hand-rolled JSON string
  /// literals. Don't use this for text that will instead go through
  /// `jsonEncode` -- that would double-escape it.
  static String sanitizeForServer(String input) {
    final normalized = normalize(input);
    return normalized
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll('\r\n', '\\n')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\n');
  }
}
