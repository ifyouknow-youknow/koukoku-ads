import 'package:flutter/material.dart';
import 'package:koukoku_ads/COMPONENTS/button_view.dart';
import 'package:koukoku_ads/COMPONENTS/image_view.dart';
import 'package:koukoku_ads/COMPONENTS/main_view.dart';
import 'package:koukoku_ads/COMPONENTS/padding_view.dart';
import 'package:koukoku_ads/COMPONENTS/text_view.dart';
import 'package:koukoku_ads/COMPONENTS/textfield_view.dart';
import 'package:koukoku_ads/FUNCTIONS/colors.dart';
import 'package:koukoku_ads/FUNCTIONS/nav.dart';
import 'package:koukoku_ads/MODELS/DATAMASTER/datamaster.dart';
import 'package:koukoku_ads/MODELS/firebase.dart';
import 'package:koukoku_ads/MODELS/screen.dart';
import 'package:koukoku_ads/VIEWS/browse.dart';
import 'package:koukoku_ads/VIEWS/signup.dart';
import 'package:koukoku_ads/VIEWS/user_browse.dart';

class Login extends StatefulWidget {
  final DataMaster dm;
  const Login({super.key, required this.dm});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void onLogin() async {
    //
    final email = _emailController.text;
    final pass = _passwordController.text;

    if (email.isEmpty || pass.isEmpty) {
      setState(() {
        widget.dm.alertSomethingWrong();
      });
      return;
    }
    setState(() {
      widget.dm.setToggleLoading(true);
    });
    final user = await auth_SignIn(email, pass);
    if (user != null) {
      setState(() {
        widget.dm.setToggleLoading(false);
      });
      // GO SOMEWHERE
      nav_PushAndRemove(context, UserBrowse(dm: widget.dm));
    } else {
      setState(() {
        widget.dm.setToggleLoading(false);
        widget.dm.alertSomethingWrong();
      });
    }
  }

  void init() async {
    setState(() {
      widget.dm.setToggleLoading(true);
    });
    final signedIn = await widget.dm.checkUser();
    if (signedIn) {
      setState(() {
        widget.dm.setToggleLoading(false);
      });
      nav_PushAndRemove(context, UserBrowse(dm: widget.dm));
      return;
    }
    setState(() {
      widget.dm.setToggleLoading(false);
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainView(
      backgroundColor: hexToColor("#FF1F54"),
      dm: widget.dm,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PaddingView(
                paddingTop: 0,
                paddingBottom: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonView(
                        child: const Row(
                          children: [
                            Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            TextView(
                              text: 'browse',
                              color: Colors.white,
                              size: 20,
                              weight: FontWeight.w600,
                              wrap: false,
                            ),
                          ],
                        ),
                        onPress: () {
                          nav_PushAndRemove(context, Browse(dm: widget.dm));
                        }),
                    ButtonView(
                        child: const Row(
                          children: [
                            TextView(
                              text: 'sign up',
                              color: Colors.white,
                              size: 20,
                              weight: FontWeight.w600,
                              wrap: false,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            )
                          ],
                        ),
                        onPress: () {
                          nav_Push(context, SignUp(dm: widget.dm));
                        }),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: ImageView(
                  imagePath: 'assets/logo.png',
                  width: getWidth(context) * 0.8,
                  height: getWidth(context) * 0.8,
                  objectFit: BoxFit.fill,
                ),
              ),
              const Spacer(), // This will push the text to the bottom
              PaddingView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextView(
                      text: 'Login',
                      size: 40,
                      weight: FontWeight.w800,
                      spacing: -2,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextfieldView(
                      controller: _emailController,
                      color: Colors.white,
                      placeholderColor: Colors.white60,
                      placeholder: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      size: 18,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextfieldView(
                      controller: _passwordController,
                      color: Colors.white,
                      placeholderColor: Colors.white60,
                      placeholder: 'Password',
                      size: 18,
                      isPassword: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonView(
                            child: const TextView(
                              text: 'forgot password?',
                              wrap: false,
                              size: 16,
                              color: Colors.white70,
                              weight: FontWeight.w500,
                            ),
                            onPress: () async {
                              final success = await auth_ForgotPassword(
                                  _emailController.text);
                              if (success) {
                                setState(() {
                                  widget.dm.setAlertTitle('Email Sent.');
                                  widget.dm.setAlertText(
                                      'Reset password form has been sent to your email.');
                                  widget.dm.setToggleAlert(true);
                                });
                              } else {
                                setState(() {
                                  widget.dm.setAlertTitle('Uh Oh!');
                                  widget.dm.setAlertText(
                                      'Something went wrong. Please try again and make sure you have entered the correct email.');
                                  widget.dm.setToggleAlert(true);
                                });
                              }
                            }),
                        ButtonView(
                            radius: 100,
                            backgroundColor: Colors.white,
                            paddingTop: 8,
                            paddingBottom: 8,
                            paddingLeft: 18,
                            paddingRight: 18,
                            child: const TextView(
                              text: 'login',
                              size: 16,
                              wrap: false,
                              weight: FontWeight.w500,
                            ),
                            onPress: () {
                              onLogin();
                            })
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30), // Additional space at the bottom
            ],
          ),
        ),
      ],
    );
  }
}
