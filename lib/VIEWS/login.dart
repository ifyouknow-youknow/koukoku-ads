import 'package:flutter/material.dart';
import 'package:ads_mahem/COMPONENTS/button_view.dart';
import 'package:ads_mahem/COMPONENTS/image_view.dart';
import 'package:ads_mahem/COMPONENTS/main_view.dart';
import 'package:ads_mahem/COMPONENTS/padding_view.dart';
import 'package:ads_mahem/COMPONENTS/pill_view.dart';
import 'package:ads_mahem/COMPONENTS/text_view.dart';
import 'package:ads_mahem/COMPONENTS/textfield_view.dart';
import 'package:ads_mahem/FUNCTIONS/colors.dart';
import 'package:ads_mahem/FUNCTIONS/nav.dart';
import 'package:ads_mahem/MODELS/DATAMASTER/datamaster.dart';
import 'package:ads_mahem/MODELS/firebase.dart';
import 'package:ads_mahem/MODELS/screen.dart';
import 'package:ads_mahem/VIEWS/browse.dart';
import 'package:ads_mahem/VIEWS/signup.dart';
import 'package:ads_mahem/VIEWS/user_browse.dart';

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
      final signedIn = await widget.dm.checkUser();
      if (signedIn) {
        setState(() {
          widget.dm.setToggleLoading(false);
        });
        // GO SOMEWHERE
        nav_PushAndRemove(context, UserBrowse(dm: widget.dm));
      }
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
      widget.dm.setToggleSplash(true);
      widget.dm.setToggleSplash2(false);
    });
    final signedIn = await widget.dm.checkUser();
    if (signedIn) {
      setState(() {
        widget.dm.setToggleLoading(false);
      });
      nav_PushAndRemove(context, UserBrowse(dm: widget.dm));
      return;
    } else {
      setState(() {
        widget.dm.setToggleLoading(false);
      });
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainView(
      backgroundColor: Colors.white,
      dm: widget.dm,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PaddingView(
                paddingBottom: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonView(
                        child: PillView(
                          backgroundColor: hexToColor("#F5F5FC"),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.arrow_back,
                                size: 18,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              TextView(
                                text: 'browse',
                                size: 16,
                                weight: FontWeight.w600,
                                wrap: false,
                              ),
                            ],
                          ),
                        ),
                        onPress: () {
                          setState(() {
                            widget.dm.setToggleSplash(false);
                            widget.dm.setToggleSplash2(true);
                          });
                          nav_PushAndRemove(context, Browse(dm: widget.dm));
                        }),
                    ButtonView(
                        child: PillView(
                          backgroundColor: hexToColor("#F5F5FC"),
                          child: const Row(
                            children: [
                              TextView(
                                text: 'sign up',
                                size: 16,
                                weight: FontWeight.w600,
                                wrap: false,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                size: 18,
                              )
                            ],
                          ),
                        ),
                        onPress: () {
                          setState(() {
                            widget.dm.setToggleSplash(false);
                            widget.dm.setToggleSplash2(true);
                          });
                          nav_Push(context, SignUp(dm: widget.dm), () {
                            setState(() {
                              widget.dm.setToggleSplash(true);
                              widget.dm.setToggleSplash2(false);
                            });
                          });
                        }),
                  ],
                ),
              ),
              const Spacer(), // This will push the text to the bottom
              PaddingView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextView(
                      text: 'Login',
                      size: 50,
                      weight: FontWeight.w800,
                      spacing: -2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextfieldView(
                      controller: _emailController,
                      placeholder: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      size: 18,
                      backgroundColor: hexToColor("#F5F5FC"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextfieldView(
                      controller: _passwordController,
                      placeholder: 'Password',
                      size: 18,
                      isPassword: true,
                      backgroundColor: hexToColor("#F5F5FC"),
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
                              size: 18,
                              weight: FontWeight.w600,
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
                            child: PillView(
                              backgroundColor: hexToColor("#F5F5FC"),
                              child: TextView(
                                text: 'login',
                                size: 18,
                                wrap: false,
                                weight: FontWeight.w500,
                              ),
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
