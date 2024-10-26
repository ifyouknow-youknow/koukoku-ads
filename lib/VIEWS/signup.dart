import 'package:flutter/material.dart';
import 'package:ads_mahem/COMPONENTS/button_view.dart';
import 'package:ads_mahem/COMPONENTS/image_view.dart';
import 'package:ads_mahem/COMPONENTS/main_view.dart';
import 'package:ads_mahem/COMPONENTS/padding_view.dart';
import 'package:ads_mahem/COMPONENTS/pill_view.dart';
import 'package:ads_mahem/COMPONENTS/roundedcorners_view.dart';
import 'package:ads_mahem/COMPONENTS/text_view.dart';
import 'package:ads_mahem/COMPONENTS/textfield_view.dart';
import 'package:ads_mahem/FUNCTIONS/colors.dart';
import 'package:ads_mahem/FUNCTIONS/nav.dart';
import 'package:ads_mahem/MODELS/DATAMASTER/datamaster.dart';
import 'package:ads_mahem/MODELS/constants.dart';
import 'package:ads_mahem/MODELS/firebase.dart';
import 'package:ads_mahem/MODELS/screen.dart';
import 'package:ads_mahem/VIEWS/user_browse.dart';

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
        backgroundColor: hexToColor("#4D76FF"),
        dm: widget.dm,
        children: [
          // TOP
          PaddingView(
            child: Row(
              children: [
                ButtonView(
                  onPress: () {
                    setState(() {
                      widget.dm.setToggleSplash(true);
                      widget.dm.setToggleSplash2(false);
                    });
                    nav_Pop(context);
                  },
                  child: PillView(
                    backgroundColor: hexToColor("#F5F5FC"),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          size: 18,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        const TextView(
                          text: 'back',
                          size: 16,
                          weight: FontWeight.w600,
                          wrap: false,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
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
                    child: PillView(
                      backgroundColor: hexToColor("#FF5858"),
                      child: TextView(
                        text: 'sign up',
                        size: 20,
                        weight: FontWeight.w600,
                        color: Colors.white,
                      ),
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
