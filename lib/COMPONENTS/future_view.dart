import 'package:flutter/material.dart';
import 'package:koukoku_ads/COMPONENTS/loading_view.dart';
import 'package:koukoku_ads/COMPONENTS/text_view.dart';

class FutureView extends StatefulWidget {
  final Future<dynamic> future;
  final Widget emptyWidget;
  final Widget Function(dynamic data) childBuilder;

  FutureView({
    Key? key,
    required this.future,
    required this.childBuilder,
    required this.emptyWidget,
  }) : super(key: key);

  @override
  State<FutureView> createState() => _FutureViewState();
}

class _FutureViewState extends State<FutureView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.future,
      builder: (context, snapshot) {
        Widget content;

        if (snapshot.connectionState == ConnectionState.waiting) {
          content = const LoadingView();
        } else if (snapshot.hasError) {
          content = TextView(
            text: 'Error: ${snapshot.error}',
            color: Colors.red,
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data;
          if (data != null && data.isNotEmpty) {
            content = widget.childBuilder(data);
          } else {
            content = widget.emptyWidget;
          }
        } else {
          content = const TextView(text: 'No data');
        }

        return Align(
          alignment:
              Alignment.topCenter, // Align to the top, you can change as needed
          child: content,
        );
      },
    );
  }
}
