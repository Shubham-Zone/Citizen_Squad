import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackingly_new/pages/authentication/phone_auth.dart';
import 'package:hackingly_new/pages/screens/user/home_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Otp extends StatefulWidget {
  const Otp({Key? key}) : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  // late String? nameStatus="";
  // late DatabaseReference dbRef;
  final FirebaseAuth auth = FirebaseAuth.instance;
  //
  // _httpsCall() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   nameStatus = prefs.getString('name');
  // }

  late Timer _timer;
  int _start = 30;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (_start == 0) {
                timer.cancel();
                showResendBtn();
              } else {
                _start = _start - 1;
              }
            }));
  }

  @override
  void initState() {
    // _httpsCall();
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  TextEditingController smscode = TextEditingController();

  bool _canShowButton = true;
  bool _canShowCircular = false;

  bool resendText = true;
  bool resendBtn = false;

  showResendBtn() {
    resendText = !resendText;
    resendBtn = !resendBtn;
  }

  void hideWidget() {
    setState(() {
      _canShowButton = !_canShowButton;
      _canShowCircular = !_canShowCircular;
    });
  }

  void showWidget() {
    setState(() {
      _canShowButton = true;
      _canShowCircular = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context);

    final defaultPinTheme = PinTheme(
      width: mediaquery.size.width * 0.055,
      height: mediaquery.size.height * 0.056,
      textStyle: TextStyle(
          fontSize: mediaquery.size.height * 0.025,
          color: const Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    // ignore: unused_local_variable
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    // ignore: unused_local_variable
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    var code = "";

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: const EdgeInsets.only(left: 25, right: 25, top: 80),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Lottie.asset("assets/lottie/otp.json",
                    height: 200, fit: BoxFit.cover),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Phone Verification",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Please Enter the OTP sent to you",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 20,
                ),
                Pinput(
                  length: 6,
                  controller: smscode,
                  showCursor: true,
                  onChanged: (value) {
                    code = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Visibility(
                    visible: _canShowButton,
                    child: ElevatedButton(
                      onPressed: () async {
                        hideWidget();
                        try {
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: Phone.verify,
                                  smsCode: smscode.text);
                          // Sign the user in (or link) with the credential
                          await auth.signInWithCredential(credential);
                          //saving login info to sharedpref
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('repeat', true);

                          if (mounted) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Welcome()));
                          }
                        } catch (e) {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('repeat', false);
                          showWidget();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString() + code)));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text("Verify phone number"),
                    ),
                  ),
                ),
                Visibility(
                    visible: _canShowCircular,
                    child: const CircularProgressIndicator()),
                Column(
                  children: [
                    Visibility(
                      visible: _canShowButton,
                      child: Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Phone()));
                              },
                              child: const Text(
                                "Edit Phone Number ?",
                                style: TextStyle(color: Colors.black),
                              )),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: resendText,
                      child: Row(
                        children: [
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                "Resend otp in $_start sec",
                                style: const TextStyle(color: Colors.black),
                              )),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: resendBtn,
                      child: ElevatedButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            int? phNo = prefs.getInt('phoneNo');

                            await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: "+91$phNo",
                              verificationCompleted:
                                  (PhoneAuthCredential credential) {},
                              verificationFailed: (FirebaseAuthException e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())));
                                showWidget();
                              },
                              codeSent: (String verificationId,
                                  int? resendToken) async {
                                Phone.verify = verificationId;
                              },
                              codeAutoRetrievalTimeout:
                                  (String verificationId) {},
                            );

                            setState(() {
                              showResendBtn();
                              startTimer();
                              _start = 30;
                            });
                          },
                          child: const Text("Resend otp")),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
