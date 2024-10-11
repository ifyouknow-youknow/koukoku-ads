import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class TextView extends StatefulWidget {
  const TextView({
    super.key,
    this.text = "Hello, Bagel!",
    this.font = "jakarta",
    this.size = 14,
    this.color = Colors.black,
    this.isUnderlined = false,
    this.isItalic = false,
    this.weight = FontWeight.normal,
    this.isTypewriter = false,
    this.interval = const Duration(milliseconds: 20),
    this.align = TextAlign.left,
    this.wrap = true,
    this.spacing = 0.0,
    this.isStriked = false,
  });

  final String text;
  final String font;
  final double size;
  final Color color;
  final FontWeight weight;
  final bool isUnderlined;
  final bool isItalic;
  final bool isTypewriter;
  final Duration interval;
  final TextAlign align;
  final bool wrap;
  final double spacing;
  final bool isStriked; // Added isStriked property

  @override
  _TextViewState createState() => _TextViewState();
}

class _TextViewState extends State<TextView> {
  late String _displayedText;
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.isTypewriter) {
      _displayedText = '';
      _startTypewriterEffect();
    } else {
      _displayedText = widget.text;
    }
  }

  @override
  void didUpdateWidget(TextView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if the text has changed
    if (widget.text != oldWidget.text) {
      if (widget.isTypewriter) {
        _displayedText = '';
        _currentIndex = 0;
        _startTypewriterEffect(); // Restart the typewriter effect
      } else {
        setState(() {
          _displayedText = widget.text;
        });
      }
    }
  }

  void _startTypewriterEffect() {
    _timer = Timer.periodic(widget.interval, (timer) {
      if (_currentIndex < widget.text.length) {
        setState(() {
          _displayedText = widget.text.substring(0, _currentIndex + 1);
          _currentIndex++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle;

    TextDecoration decoration = TextDecoration.none;
    if (widget.isUnderlined) {
      decoration = TextDecoration.underline;
    }
    if (widget.isStriked) {
      decoration = decoration == TextDecoration.none
          ? TextDecoration.lineThrough
          : TextDecoration.combine([decoration, TextDecoration.lineThrough]);
    }

    switch (widget.font.toLowerCase()) {
      case 'jakarta':
        textStyle = GoogleFonts.plusJakartaSans(
          fontSize: widget.size,
          color: widget.color,
          decoration: decoration,
          fontWeight: widget.weight,
          fontStyle: widget.isItalic ? FontStyle.italic : FontStyle.normal,
          letterSpacing: widget.spacing,
        );
        break;
      case 'inconsolata':
        textStyle = GoogleFonts.inconsolata(
          fontSize: widget.size,
          color: widget.color,
          decoration: decoration,
          fontWeight: widget.weight,
          fontStyle: widget.isItalic ? FontStyle.italic : FontStyle.normal,
          letterSpacing: widget.spacing,
        );
        break;
      case 'playfairdisplay':
        textStyle = GoogleFonts.playfairDisplay(
          fontSize: widget.size,
          color: widget.color,
          decoration: decoration,
          fontWeight: widget.weight,
          fontStyle: widget.isItalic ? FontStyle.italic : FontStyle.normal,
          letterSpacing: widget.spacing,
        );
        break;
      case 'lato':
        textStyle = GoogleFonts.lato(
          fontSize: widget.size,
          color: widget.color,
          decoration: decoration,
          fontWeight: widget.weight,
          fontStyle: widget.isItalic ? FontStyle.italic : FontStyle.normal,
          letterSpacing: widget.spacing,
        );
        break;
      case 'roboto':
        textStyle = GoogleFonts.roboto(
          fontSize: widget.size,
          color: widget.color,
          decoration: decoration,
          fontWeight: widget.weight,
          fontStyle: widget.isItalic ? FontStyle.italic : FontStyle.normal,
          letterSpacing: widget.spacing,
        );
        break;
      case 'poppins':
        textStyle = GoogleFonts.poppins(
          fontSize: widget.size,
          color: widget.color,
          decoration: decoration,
          fontWeight: widget.weight,
          fontStyle: widget.isItalic ? FontStyle.italic : FontStyle.normal,
          letterSpacing: widget.spacing,
        );
        break;
      case 'merriweather':
        textStyle = GoogleFonts.merriweather(
          fontSize: widget.size,
          color: widget.color,
          decoration: decoration,
          fontWeight: widget.weight,
          fontStyle: widget.isItalic ? FontStyle.italic : FontStyle.normal,
          letterSpacing: widget.spacing,
        );
        break;
      default:
        textStyle = TextStyle(
          fontSize: widget.size,
          color: widget.color,
          decoration: decoration,
          fontWeight: widget.weight,
          fontStyle: widget.isItalic ? FontStyle.italic : FontStyle.normal,
          letterSpacing: widget.spacing,
        );
    }

    return Text(
      _displayedText,
      style: textStyle,
      textAlign: widget.align,
      softWrap: widget.wrap,
    );
  }
}
