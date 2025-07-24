import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class MathTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;

  const MathTextWidget({
    Key? key,
    required this.text,
    this.fontSize = 16,
    this.color,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ Check if text contains LaTeX
    if (_containsLatex(text)) {
      return _buildTexView();
    }
    
    // ✅ Fallback to regular text
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? Colors.black87,
        fontWeight: fontWeight,
      ),
    );
  }

  Widget _buildTexView() {
    try {
      // ✅ Clean and prepare LaTeX string
      String cleanLatex = _prepareLatexString(text);
      
      return TeXView(
        child: TeXViewDocument(cleanLatex),
        style: TeXViewStyle(
          fontStyle: TeXViewFontStyle(fontSize: fontSize.toInt() , fontWeight: _convertFontWeight(fontWeight) ),
          backgroundColor: Colors.transparent,
          margin: const TeXViewMargin.all(0),
          padding: const TeXViewPadding.all(0),
        ),
         loadingWidgetBuilder: (context) => SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? Colors.black87,
            ),
          ),
        ),
      );
      
    } catch (e) {
      // ✅ Fallback to formatted text if TeXView fails
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: Text(
          _formatFallbackText(text),
          style: TextStyle(
            fontSize: fontSize,
            color: color ?? Colors.black87,
            fontWeight: fontWeight,
            fontFamily: 'monospace',
          ),
        ),
      );
    }
  }

  // ✅ Check if text contains LaTeX
  bool _containsLatex(String text) {
    final latexPatterns = [
      r'\$',
      r'\\frac',
      r'\\omega',
      r'\\alpha',
      r'\\beta',
      r'\\gamma',
      r'\\delta',
      r'\\pi',
      r'\\theta',
      r'\\sqrt',
      r'\^{',
      r'_{',
      r'\\left',
      r'\\right',
    ];
    
    return latexPatterns.any((pattern) => text.contains(RegExp(pattern)));
  }

  // ✅ Prepare LaTeX string for TeXView
  String _prepareLatexString(String text) {
    // Remove outer dollar signs if present
    String cleaned = text.trim();
    if (cleaned.startsWith('\$') && cleaned.endsWith('\$')) {
      cleaned = cleaned.substring(1, cleaned.length - 1);
    }
    
    // Wrap in math mode if not already
    if (!cleaned.startsWith('\$')) {
      cleaned = '\$' + cleaned + '\$';
    }
    
    return cleaned;
  }

  // ✅ Convert FontWeight to TeXViewFontWeight
  TeXViewFontWeight _convertFontWeight(FontWeight? fontWeight) {
    if (fontWeight == null) return TeXViewFontWeight.normal;
    
    switch (fontWeight) {
      case FontWeight.bold:
        return TeXViewFontWeight.bold;
      case FontWeight.w500:
        return TeXViewFontWeight.w500;
      case FontWeight.w600:
        return TeXViewFontWeight.w600;
      case FontWeight.w700:
        return TeXViewFontWeight.w700;
      case FontWeight.w800:
        return TeXViewFontWeight.w800;
      case FontWeight.w900:
        return TeXViewFontWeight.w900;
      default:
        return TeXViewFontWeight.normal;
    }
  }

  // ✅ Fallback text formatting
  String _formatFallbackText(String text) {
    final replacements = {
      '\$': '',
      '\\frac{1}{2}': '½',
      '\\frac{1}{3}': '⅓',
      '\\frac{1}{4}': '¼',
      '\\frac{2}{3}': '⅔',
      '\\frac{3}{4}': '¾',
      '\\omega': 'ω',
      '\\alpha': 'α',
      '\\beta': 'β',
      '\\gamma': 'γ',
      '\\delta': 'δ',
      '\\pi': 'π',
      '\\theta': 'θ',
      '\\lambda': 'λ',
      '\\mu': 'μ',
      '\\sigma': 'σ',
      '^{2}': '²',
      '^{3}': '³',
      '_{1}': '₁',
      '_{2}': '₂',
      '_{3}': '₃',
      '\\left(': '(',
      '\\right)': ')',
      '\\sqrt{': '√(',
      '{': '(',
      '}': ')',
    };

    String result = text;
    replacements.forEach((key, value) {
      result = result.replaceAll(key, value);
    });
    
    return result.trim();
  }
}