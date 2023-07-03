// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, unused_import

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:retirement_management_system/common/theme_helper.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:retirement_management_system/pages/changepassword.dart';
import 'package:retirement_management_system/pages/login_page.dart';

class ForgotPasswordVerificationPage extends StatefulWidget {
  const ForgotPasswordVerificationPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordVerificationPageState createState() =>
      _ForgotPasswordVerificationPageState();
}

class _ForgotPasswordVerificationPageState
    extends State<ForgotPasswordVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  bool _pinSuccess = false;
  String _verificationCode = ""; // Store the verification code sent to the email

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Verification"),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Container(
                margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 150,
                          ),
                          Text(
                            'Enter the verification code we just sent you on your email address.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          OTPTextField(
                            length: 4,
                            width: 300,
                            fieldWidth: 50,
                            style: TextStyle(fontSize: 30),
                            textFieldAlignment:
                                MainAxisAlignment.spaceAround,
                            fieldStyle: FieldStyle.underline,
                            onCompleted: (pin) {
                              setState(() {
                                _verificationCode = pin;
                                _pinSuccess = true;
                              });
                            },
                          ),
                          SizedBox(height: 50.0),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "If you didn't receive a code! ",
                                  style: TextStyle(
                                    color: Colors.black38,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Resend',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      User? user =
                                          FirebaseAuth.instance.currentUser;
                                      if (user != null) {
                                        await user.sendEmailVerification();
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ThemeHelper().alartDialog(
                                              "Successful",
                                              "Verification code resend successful.",
                                              context,
                                            );
                                          },
                                        );
                                      }
                                    },
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40.0),
                          Container(
                            decoration: _pinSuccess
                                ? ThemeHelper().buttonBoxDecoration(context)
                                : ThemeHelper().buttonBoxDecoration(
                                    context, "#AAAAAA", "#757575"),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle().copyWith(
                                backgroundColor: _pinSuccess
                                    ? MaterialStateProperty.all<Color>(
                                        Theme.of(context).primaryColor)
                                    : MaterialStateProperty.all<Color>(
                                        Colors.orange),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  "Verify".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onPressed: _pinSuccess
                                  ? () async {
                                      try {
                                        // Get the current user
                                        User? user =
                                            FirebaseAuth.instance.currentUser;
                                        if (user != null) {
                                          // Sign in the user with their email and verification code
                                          AuthCredential credential =
                                              EmailAuthProvider.credential(
                                                  email: user.email!,
                                                  password:
                                                      _verificationCode);
                                          await user
                                              .reauthenticateWithCredential(
                                                  credential);
                                          // If reauthentication is successful, navigate to the change password screen
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChangePasswordPage(),
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ThemeHelper().alartDialog(
                                              "Error",
                                              "Invalid verification code.",
                                              context,
                                            );
                                          },
                                        );
                                      }
                                    }
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


