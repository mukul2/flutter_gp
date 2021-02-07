import 'package:maulaji/utils/commonWidgets.dart';
import 'package:maulaji/view/doctor/Widgets.dart';
import 'package:maulaji/view/login_view.dart';
import 'package:maulaji/view/patient/OnlineDoctorFullProfileView.dart';
import 'package:maulaji/view/patient/screens/DoctorLogin/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../main.dart';

Padding extraPadding(){

return Padding(padding: EdgeInsets.fromLTRB(15, 00, 0, 30));
}
Padding backArrow(){
  return Padding(
  padding: EdgeInsets.fromLTRB(20, 10, 0, 00),
  child: InkWell(
    onTap: () {},
    child: Icon(
      Icons.arrow_back_outlined,
      size: 32,
    ),
  ),
);
}

Padding title(){
  return Padding(
    padding: EdgeInsets.fromLTRB(20, 10, 5, 15),
    child: Text(
      "Doctor Login",
      style: TextStyle(
        // color: Color(0xFF34448c),
        fontSize: 25,
      ),
    ),
  );
}
Padding inputFieldEmail( ){
  String email;

  return Padding(
    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
    child: TextFormField(

      //focusNode: myFocusNode,
      style: TextStyle(
        color: Colors.blue,
      ),
      initialValue: "",

      validator: (value) {
        email = value;
        if (value.isEmpty) {
          return 'Please enter Email';
        }
        return null;
      },
      cursorColor: Colors.blue,
      decoration: InputDecoration(
          fillColor: Color.fromARGB(255, 234, 234, 234),
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 234, 234, 234),
                width: 10.0),
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 234, 234, 234),
                  width: 10.0)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 234, 234, 234),
                  width: 10.0)),
          labelText: "Email",
          focusColor: Colors.blue,
          labelStyle: TextStyle(color: Colors.blue)),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
    ),
  );
}
Padding inputFieldPassword( ){
  String email;

  return Padding(
    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
    child: TextFormField(

      //focusNode: myFocusNode,
      style: TextStyle(
        color: Colors.blue,
      ),
      initialValue: "",

      validator: (value) {
        email = value;
        if (value.isEmpty) {
          return 'Please enter Email';
        }
        return null;
      },
      cursorColor: Colors.blue,
      decoration: InputDecoration(
          fillColor: Color.fromARGB(255, 234, 234, 234),
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 234, 234, 234),
                width: 10.0),
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 234, 234, 234),
                  width: 10.0)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 234, 234, 234),
                  width: 10.0)),
          labelText: "Email",
          focusColor: Colors.blue,
          labelStyle: TextStyle(color: Colors.blue)),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
    ),
  );
}
Widget StandbyWid = Text(
  "Login",
  style: TextStyle(color: Colors.white, fontSize: 18),
);
Form loginForm(_formKey,BuildContext context,String userType){
  String email,password;
  return Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        extraPadding(),
        backArrow(),
        title(),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(

            //focusNode: myFocusNode,
            style: TextStyle(
              color: primaryColor,
            ),
            initialValue: "doctor@callgpnow.com",

            validator: (value) {
              email = value;
              if (value.isEmpty) {
                return 'Please enter Email';
              }
              return null;
            },
            cursorColor: primaryColor,
            decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 234, 234, 234),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 234, 234, 234),
                      width: 10.0),
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 234, 234, 234),
                        width: 10.0)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 234, 234, 234),
                        width: 10.0)),
                labelText: "Email",
                focusColor: primaryColor,
                labelStyle: TextStyle(color:primaryColor)),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(
           // focusNode: myFocusNode2,
            style: TextStyle(
              color: primaryColor,
            ),
            initialValue: "12345",
            validator: (value) {
              password = value;
              if (value.isEmpty) {
                return 'Please enter Password';
              }
              return null;
            },
            cursorColor: primaryColor,
            decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 234, 234, 234),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 234, 234, 234),
                      width: 10.0),
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 234, 234, 234))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 234, 234, 234))),
                labelText: "Password",
                focusColor:primaryColor,
                labelStyle: TextStyle(
                  color: primaryColor,
                )),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: SizedBox(
              height: 55,
              width: double.infinity, // match_parent
              child: RaisedButton(
                color: primaryColor,
                onPressed: () async {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_formKey.currentState.validate()) {
                    Block.getInstance().clickedLogin(context,email,password,"d");

                  }
                },
                child: StandbyWid,
              )),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CheckPhoneIntegForm("d")));
            },
            child: Container(
              width: double.infinity,
              height: 50,
              child: Center(
                child: Text(
                  "Sign Up Here",
                  style: TextStyle(
                      fontSize: 18,
                      color: primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              decoration: decoration,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FindAccountActivity()));
          },
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                "Forgot password ?",
                style: TextStyle(color: primaryColor),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class Widgets {
  static Widget textFormField(
      {@required TextEditingController controller,
        @required bool darkBackground,
        String labelText,
        String suffixText,
        bool obscureText = false,
        TextInputType inputType = TextInputType.text,
        FormFieldValidator<String> validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Theme(

        child: TextFormField(

          keyboardType: inputType,
          controller: controller,
          autocorrect: false,
          obscureText: obscureText,

          validator: validator,
        ),
      ),
    );
  }

  static Widget maxWidthRaisedButton(
      {@required String text, @required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: RaisedButton(

          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }

  static Widget textWithPadding(
      {@required String text,
        Color textColor,
        double fontSize,
        double verticalPadding = 0.0,
        double horizontalPadding = 0.0}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: verticalPadding, horizontal: horizontalPadding),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: fontSize),
      ),
    );
  }

  static Widget iconButton({
    @required IconData icon,
    @required Color color,
    @required String tooltip,
    @required VoidCallback onPressed,
  }) {
    return Ink(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: CircleBorder(),
      ),
      child: IconButton(
        onPressed: onPressed,
        iconSize: 40,
        icon: Icon(
          icon,
          color: color,
        ),
        tooltip: tooltip,
      ),
    );
  }
}