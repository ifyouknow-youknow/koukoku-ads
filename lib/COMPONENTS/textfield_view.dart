import 'package:koukoku_ads/COMPONENTS/button_view.dart';
import 'package:koukoku_ads/COMPONENTS/text_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextfieldView extends StatefulWidget {
  final bool isAutoCorrect;
  final bool isAutoFocus;
  final String placeholder;
  final Color placeholderColor;
  final double size;
  final Color color;
  final Color backgroundColor;
  final double paddingV;
  final double paddingH;
  final bool enabled;
  final double borderWidth;
  final Color borderColor;
  final double radius;
  final TextInputType keyboardType;
  final int max;
  final int maxLines;
  final int minLines;
  final bool multiline;
  final bool isPassword;
  final bool isCap; // New field for capitalization
  final TextEditingController controller;

  const TextfieldView({
    super.key,
    this.isAutoCorrect = false,
    this.isAutoFocus = false,
    this.placeholder = "Enter text here...",
    this.placeholderColor = Colors.grey,
    this.size = 16,
    this.color = Colors.black,
    this.backgroundColor = Colors.black12,
    this.paddingV = 10,
    this.paddingH = 10,
    this.enabled = true,
    this.borderWidth = 0,
    this.borderColor = Colors.black,
    this.radius = 8,
    this.keyboardType = TextInputType.text,
    this.max = 0,
    this.maxLines = 1,
    this.minLines = 1,
    this.multiline = false,
    this.isPassword = false,
    this.isCap = false, // Default value
    required this.controller,
  });

  @override
  _TextfieldViewState createState() => _TextfieldViewState();
}

class _TextfieldViewState extends State<TextfieldView> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {}); // Trigger a rebuild when focus changes
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  void clearText() {
    setState(() {
      widget.controller.clear();
    });
  }

  void _dismissKeyboard() {
    _focusNode.unfocus(); // Dismisses the keyboard
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior
          .opaque, // Ensures GestureDetector detects taps outside of children
      onTap: () {
        // Dismiss keyboard and remove focus when tapping outside the TextField
        _dismissKeyboard();
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(widget.radius),
              border: widget.borderWidth > 0
                  ? Border.all(
                      color: widget.borderColor, width: widget.borderWidth)
                  : null,
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              autocorrect: widget.isAutoCorrect,
              autofocus: widget.isAutoFocus,
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: GoogleFonts.roboto(color: widget.placeholderColor),
                contentPadding: EdgeInsets.symmetric(
                  vertical: widget.paddingV,
                  horizontal: widget.paddingH,
                ),
                border: InputBorder.none,
              ),
              enabled: widget.enabled,
              keyboardType: widget.multiline
                  ? TextInputType.multiline
                  : widget.keyboardType,
              style: GoogleFonts.roboto(
                fontSize: widget.size,
                color: widget.color,
              ),
              textInputAction: widget.multiline
                  ? TextInputAction.newline
                  : TextInputAction.done,
              maxLength: widget.max > 0 ? widget.max : null,
              maxLines: widget.isPassword ? 1 : widget.maxLines,
              minLines: widget.minLines,
              obscureText: widget.isPassword,
              textCapitalization: widget.isCap
                  ? TextCapitalization.sentences
                  : TextCapitalization.none, // Toggle capitalization
            ),
          ),
          // Show "Done" button only if the TextField is focused
          if (_focusNode.hasFocus && widget.multiline)
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ButtonView(
                    onPress: _dismissKeyboard,
                    child: TextView(
                      text: 'done',
                      color: widget.color,
                      size: 20,
                      // font: 'inconsolata',
                      weight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
