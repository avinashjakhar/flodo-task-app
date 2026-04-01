import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Renders [text] with all occurrences of [highlight] visually highlighted.
class HighlightedText extends StatelessWidget {
  final String text;
  final String highlight;
  final TextStyle? baseStyle;

  const HighlightedText({
    super.key,
    required this.text,
    required this.highlight,
    this.baseStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (highlight.isEmpty) {
      return Text(text, style: baseStyle);
    }

    final lower = text.toLowerCase();
    final query = highlight.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      final idx = lower.indexOf(query, start);
      if (idx == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (idx > start) {
        spans.add(TextSpan(text: text.substring(start, idx)));
      }
      spans.add(TextSpan(
        text: text.substring(idx, idx + query.length),
        style: GoogleFonts.dmSans(
          color: AppTheme.accent,
          backgroundColor: AppTheme.accentSoft,
          fontWeight: FontWeight.w700,
        ),
      ));
      start = idx + query.length;
    }

    return RichText(
      text: TextSpan(style: baseStyle, children: spans),
      overflow: TextOverflow.ellipsis,
    );
  }
}
