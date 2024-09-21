import 'package:flutter/material.dart';
import 'package:koukoku_ads/COMPONENTS/alert_view.dart';
import 'package:koukoku_ads/COMPONENTS/bubble_view.dart';
import 'package:koukoku_ads/COMPONENTS/button_view.dart';
import 'package:koukoku_ads/COMPONENTS/loading_view.dart';
import 'package:koukoku_ads/COMPONENTS/text_view.dart';
import 'package:koukoku_ads/MODELS/DATAMASTER/datamaster.dart';
import 'package:koukoku_ads/MODELS/screen.dart';

class MainView extends StatefulWidget {
  final DataMaster dm;
  final List<Widget> children;
  final Color backgroundColor;

  const MainView({
    super.key,
    required this.dm,
    required this.children,
    this.backgroundColor = Colors.white,
  });

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      resizeToAvoidBottomInset: true,
      body: SizedBox(
        height: getHeight(context),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 46,
                ),
                ...widget.children,
              ],
            ),

            // ABSOLUTE
            if (widget.dm.toggleBubble) const BubbleView(),
            if (widget.dm.toggleAlert)
              AlertView(
                title: widget.dm.alertTitle,
                message: widget.dm.alertText,
                actions: [
                  ButtonView(
                    child: const TextView(
                      text: 'Close',
                      wrap: false,
                    ),
                    onPress: () {
                      setState(() {
                        widget.dm.setToggleAlert(false);
                      });
                    },
                  ),
                  ...widget.dm.alertButtons
                ],
              ),
            if (widget.dm.toggleLoading) const LoadingView()
          ],
        ),
      ),
    );
  }
}
