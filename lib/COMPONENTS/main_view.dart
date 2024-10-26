import 'package:flutter/material.dart';
import 'package:ads_mahem/COMPONENTS/alert_view.dart';
import 'package:ads_mahem/COMPONENTS/bubble_view.dart';
import 'package:ads_mahem/COMPONENTS/button_view.dart';
import 'package:ads_mahem/COMPONENTS/image_view.dart';
import 'package:ads_mahem/COMPONENTS/loading_view.dart';
import 'package:ads_mahem/COMPONENTS/text_view.dart';
import 'package:ads_mahem/FUNCTIONS/colors.dart';
import 'package:ads_mahem/MODELS/DATAMASTER/datamaster.dart';
import 'package:ads_mahem/MODELS/screen.dart';

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
            if (widget.dm.toggleSplash)
              Positioned.fill(
                child: ImageView(imagePath: 'assets/splash.png'),
              ),
            if (widget.dm.toggleSplash2)
              Positioned.fill(
                child: ImageView(imagePath: 'assets/splash2.png'),
              ),
            Column(
              children: [
                const SizedBox(
                  height: 46,
                ),
                ...widget.children,
              ],
            ),

            // ABSOLUTE
            if (widget.dm.toggleBubble)
              BubbleView(
                backgroundColor: hexToColor('#2DD445'),
                textColor: Colors.white,
                iconColor: Colors.white,
                icon: Icons.check,
                text: widget.dm.bubbleText,
              ),
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
