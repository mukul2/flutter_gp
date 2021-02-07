import 'package:maulaji/view/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
/*
class PhoneVerificationScreen extends StatelessWidget {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  String verificationId_;

  AuthResult result;

  String userType;

  PhoneVerificationScreen(this.userType);

  Future<bool> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
   // showThisToast("trying with " + phone);

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          //Navigator.of(context).pop();

          AuthResult result = await _auth.signInWithCredential(credential);

          FirebaseUser user = result.user;

          if (user != null) {
            // user is available
            Navigator.of(context).pop();
            if (userType == "p") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignupActivityPatient()));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignupActivityDoctor()));
            }
          } else {
            print("Error");
          }

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (AuthException exception) {
          showThisToast("error occured " + exception.message);
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          verificationId_ = verificationId;
//          showDialog(
//              context: context,
//              barrierDismissible: false,
//              builder: (context) {
//                showThisToast("code sent");
//                return AlertDialog(
//                  title: Text("Give the code?"),
//                  content: Column(
//                    mainAxisSize: MainAxisSize.min,
//                    children: <Widget>[
//                      TextField(
//                        controller: _codeController,
//                      ),
//                    ],
//                  ),
//                  actions: <Widget>[
//                    FlatButton(
//                      child: Text("Confirm"),
//                      textColor: Colors.white,
//                      color: Colors.blue,
//                      onPressed: () async {
//                        final code = _codeController.text.trim();
//                        AuthCredential credential =
//                            PhoneAuthProvider.getCredential(
//                                verificationId: verificationId, smsCode: code);
//
//                        AuthResult result =
//                            await _auth.signInWithCredential(credential);
//
//                        FirebaseUser user = result.user;
//
//                        if (user != null) {
//                          //veri done
//                          Navigator.of(context).pop();
//                          Navigator.push(context, MaterialPageRoute(
//                              builder: (context) => SignupActivityPatient()
//                          ));
//                        } else {
//                          print("Error");
//                        }
//                      },
//                    )
//                  ],
//                );
//              });
        },
        codeAutoRetrievalTimeout: null);
  }

  @override
  Widget build(BuildContext context) {
    loginUser(PHONE_NUMBER_VERIFIED, context);
    return Scaffold(
        body: Center(
      child: Text("Please wait"),
    ));
  }
}

void showThisToast(String s) {
  Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}


 */
class LoginPageWithVerification extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPageWithVerification> {
  String phoneNumber, verificationId;
  String otp, authStatus = "";

  Future<void> verifyPhoneNumber(BuildContext context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 15),
      verificationCompleted: (AuthCredential authCredential) {
        setState(() {
          showThisToast("Your account is successfully verified");
          authStatus = "Your account is successfully verified";
        });
      },
      /*
      verificationFailed: (AuthException authException) {
        setState(() {
          authStatus = "Authentication failed";
        });
      },

       */
      codeSent: (String verId, [int forceCodeResent]) {
        verificationId = verId;
        setState(() {
          authStatus = "OTP has been successfully send";
        });
        otpDialogBox(context).then((value) {});
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
        setState(() {
          authStatus = "TIMEOUT";
        });
      },
    );
  }

  otpDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter your OTP'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30),
                    ),
                  ),
                ),
                onChanged: (value) {
                  otp = value;
                },
              ),
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  signIn(otp);
                },
                child: Text(
                  'Submit',
                ),
              ),
            ],
          );
        });
  }

  Future<void> signIn(String otp) async {
    await FirebaseAuth.instance
        .signInWithCredential(PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: otp,
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.app;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Text(
              "Phone Auth demo📱",
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.network(
              "https://avatars1.githubusercontent.com/u/41328571?s=280&v=4",
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                keyboardType: TextInputType.phone,
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30),
                      ),
                    ),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.phone_iphone,
                      color: Colors.cyan,
                    ),
                    hintStyle: new TextStyle(color: Colors.grey[800]),
                    hintText: "Enter Your Phone Number...",
                    fillColor: Colors.white70),
                onChanged: (value) {
                  phoneNumber = value;
                },
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () =>
              phoneNumber == null ? null : verifyPhoneNumber(context),
              child: Text(
                "Generate OTP",
                style: TextStyle(color: Colors.white),
              ),
              elevation: 7.0,
              color: Colors.cyan,
            ),
            SizedBox(
              height: 20,
            ),
            Text("Need Help?"),
            SizedBox(
              height: 20,
            ),
            Text(
              "Please enter the phone number followed by country code",
              style: TextStyle(color: Colors.green),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              authStatus == "" ? "" : authStatus,
              style: TextStyle(
                  color: authStatus.contains("fail") ||
                      authStatus.contains("TIMEOUT")
                      ? Colors.red
                      : Colors.green),
            )
          ],
        ),
      ),
    );
  }
}