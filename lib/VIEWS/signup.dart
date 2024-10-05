import 'package:flutter/material.dart';
import 'package:koukoku_ads/COMPONENTS/button_view.dart';
import 'package:koukoku_ads/COMPONENTS/image_view.dart';
import 'package:koukoku_ads/COMPONENTS/main_view.dart';
import 'package:koukoku_ads/COMPONENTS/padding_view.dart';
import 'package:koukoku_ads/COMPONENTS/roundedcorners_view.dart';
import 'package:koukoku_ads/COMPONENTS/text_view.dart';
import 'package:koukoku_ads/COMPONENTS/textfield_view.dart';
import 'package:koukoku_ads/FUNCTIONS/colors.dart';
import 'package:koukoku_ads/FUNCTIONS/nav.dart';
import 'package:koukoku_ads/MODELS/DATAMASTER/datamaster.dart';
import 'package:koukoku_ads/MODELS/constants.dart';
import 'package:koukoku_ads/MODELS/firebase.dart';
import 'package:koukoku_ads/MODELS/screen.dart';
import 'package:koukoku_ads/VIEWS/user_browse.dart';

class SignUp extends StatefulWidget {
  final DataMaster dm;
  const SignUp({super.key, required this.dm});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  void onSignUp() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        widget.dm.alertMissingInfo();
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        widget.dm.setToggleAlert(true);
        widget.dm.setAlertTitle("Passwords must match");
        widget.dm.setAlertText('Please enter the same password to continue.');
      });
      return;
    }

    setState(() {
      widget.dm.setToggleLoading(true);
    });

    final user =
        await auth_CreateUser(_emailController.text, _passwordController.text);
    if (user != null) {
      final success =
          await firebase_CreateDocument('${appName}_Users', user.uid, {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
      });
      if (success) {
        setState(() {
          widget.dm.setToggleLoading(false);
        });
        nav_PushAndRemove(context, UserBrowse(dm: widget.dm));
      } else {
        setState(() {
          widget.dm.setToggleLoading(false);
          widget.dm.alertSomethingWrong();
        });
      }
    } else {
      setState(() {
        widget.dm.setToggleLoading(false);
        widget.dm.alertSomethingWrong();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainView(
        backgroundColor: hexToColor("#4F49FF"),
        dm: widget.dm,
        children: [
          // TOP
          PaddingView(
            child: Row(
              children: [
                ButtonView(
                  onPress: () {
                    nav_Pop(context);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 26,
                      ),
                      const TextView(
                        text: 'back',
                        size: 18,
                        color: Colors.white,
                        weight: FontWeight.w600,
                        wrap: false,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          ImageView(
            imagePath: 'assets/logo.png',
            width: getWidth(context) * 0.2,
            height: getWidth(context) * 0.2,
          ),
          // MAIN
          Expanded(
            child: SingleChildScrollView(
              child: PaddingView(
                  child: Column(
                children: [
                  RoundedCornersView(
                    topLeft: 20,
                    topRight: 20,
                    bottomLeft: 20,
                    bottomRight: 20,
                    backgroundColor: Colors.white,
                    child: PaddingView(
                      paddingTop: 15,
                      paddingBottom: 20,
                      paddingLeft: 20,
                      paddingRight: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextView(
                            text: 'Sign up',
                            size: 40,
                            weight: FontWeight.w800,
                            spacing: -1,
                            // color: Colors.white,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextView(
                                      text: 'first name',
                                      // color: Colors.white,
                                      size: 16,
                                      weight: FontWeight.w500,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    TextfieldView(
                                      controller: _firstNameController,
                                      // color: Colors.white,
                                      // placeholderColor: Colors.white60,
                                      placeholder: 'ex. John',
                                      isCap: true,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextView(
                                      text: 'last name',
                                      // color: Colors.white,
                                      size: 16,
                                      weight: FontWeight.w500,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    TextfieldView(
                                      controller: _lastNameController,
                                      // color: Colors.white,
                                      // placeholderColor: Colors.white60,
                                      placeholder: 'ex. Doe',
                                      isCap: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // EMAIL
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextView(
                                text: 'email',
                                // color: Colors.white,
                                size: 16,
                                weight: FontWeight.w500,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              TextfieldView(
                                controller: _emailController,
                                // color: Colors.white,
                                // placeholderColor: Colors.white60,
                                placeholder: 'ex. jdoe@gmail.com',
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 10,
                          ),
                          // PASSWORD
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextView(
                                text: 'password',
                                // color: Colors.white,
                                size: 16,
                                weight: FontWeight.w500,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              TextfieldView(
                                controller: _passwordController,
                                // color: Colors.white,
                                // placeholderColor: Colors.white60,
                                placeholder: '8 characters minimum',
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 10,
                          ),
                          // CONFIRM
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextView(
                                text: 'confirm password',
                                // color: Colors.white,
                                size: 16,
                                weight: FontWeight.w500,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              TextfieldView(
                                controller: _confirmPasswordController,
                                // color: Colors.white,
                                // placeholderColor: Colors.white60,
                                placeholder: 'passwords must match',
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextView(
                    text:
                        'Say goodbye to ineffective bots and costly ads! Your ads deserve to be seen where they truly matter. Place them where they will be noticed and appreciated, ensuring they reach the right audience.',
                    size: 16,
                    color: Colors.white,
                    weight: FontWeight.w500,
                  )
                ],
              )),
            ),
          ),
          //

          PaddingView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonView(
                    paddingTop: 8,
                    paddingBottom: 8,
                    paddingLeft: 18,
                    paddingRight: 18,
                    radius: 100,
                    backgroundColor: Colors.white,
                    child: TextView(
                      text: 'sign up',
                      size: 16,
                      weight: FontWeight.w500,
                    ),
                    onPress: () {
                      onSignUp();
                    })
              ],
            ),
          ),
          SizedBox(
            height: 20,
          )
        ]);
  }
}
