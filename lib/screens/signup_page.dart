/*
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:ludobettings/screens/policy_page.dart';
import 'package:ludobettings/services/firebase_auth_services.dart';
import 'package:ludobettings/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:ludobettings/widget/showLoading.dart';
import 'package:provider/provider.dart';

enum AuthFormType {
  SignIn,
  SignUp,
  reset,
}

class SignUpPage extends StatefulWidget {
  final AuthFormType authFormType;

  const SignUpPage({Key key, this.authFormType}) : super(key: key);

  @override
  _SignUpPageState createState() =>
      _SignUpPageState(authFormType: this.authFormType);
}

class _SignUpPageState extends State<SignUpPage> {
  AuthFormType authFormType;

  bool isLoginPressed = false;

  _SignUpPageState({this.authFormType});

  final _formKey = GlobalKey<FormState>();
  String _email, _password, _name, _warning;
  bool terms_accepted = false;

  void switchFormState(String state) {
    _formKey.currentState.reset();
    if (state == "signUp") {
      setState(() {
        authFormType = AuthFormType.SignUp;
      });
    } else if (state == "home") {
      Navigator.of(context).pop();
    } else {
      setState(() {
        authFormType = AuthFormType.SignIn;
      });
    }
  }

  bool isValid() {
    final form = _formKey.currentState;

    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit(BuildContext context) async {
    final auth = Provider.of<FirebaseAuthServices>(context, listen: false);
    if (isValid()) {
      try {
        switch (authFormType) {
          case AuthFormType.SignIn:
            setState(() {
              isLoginPressed = true;
            });
            await auth.signInWithEmailAndPassword(_email, _password);
            Navigator.of(context).pushReplacementNamed("/home");
            break;
          case AuthFormType.SignUp:
            performCreateAccWithEmail(auth);
            break;
          case AuthFormType.reset:
            setState(() {
              isLoginPressed = true;
            });
            await auth.sendPasswordResetEmail(_email);
            print("Password Reset Email Sent");
            _warning = "A Password Reset link has been sent to ${_email}";
            setState(() {
              isLoginPressed = false;
              authFormType = AuthFormType.SignIn;
            });
            break;
        }
      } catch (error) {
        setState(() {
          _warning = error.message;
          isLoginPressed = false;
        });
        print(error);
      }
    }
  }

  performLogin(FirebaseAuthServices auth) {
    setState(() {
      isLoginPressed = true;
    });
    auth.signInWithGoogle().then((FirebaseUser user) {
      if (user != null) {
        autheticateUser(user, auth);
      } else {
        setState(() {
          isLoginPressed = false;
        });
        _warning = "We have Encountered an Error. Please Try Again";
        print("Error Occured Durin Loin");
      }
    });
  }

  performCreateAccWithEmail(FirebaseAuthServices auth) {
    setState(() {
      isLoginPressed = true;
    });

    if (terms_accepted) {
      auth
          .createUserWithEmailAndPassword(_email, _name, _password)
          .then((FirebaseUser user) {
        if (user != null) {
          autheticateUser(user, auth);
        } else {
          _warning = "We have Encountered an Error. Please Try Again";
          print("Error Occured Durin Loin");
        }
      });
    } else {
      setState(() {
        isLoginPressed = false;
      });

      showToast("Accept the Terms And Conditions",
          context: context,
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
          position: StyledToastPosition(align: Alignment.center, offset: 20.0));
    }
  }

  autheticateUser(FirebaseUser user, FirebaseAuthServices auth) {
    if (user != null) {
      auth.authenticateUser(user).then((isNewUser) {
        isLoginPressed = false;
        print("User is ${isNewUser.toString()}");
        if (isNewUser) {
          auth.addToDb(user).then((value) {
            print("Add to Db called");
          });
        } else {
          print("Old user");
        }
      });
    } else {
      setState(() {
        isLoginPressed = false;
      });
    }
  }

//  @override
//  Widget build(BuildContext context) {
//    final primaryColor = const Color(0xFF75A2EA);
//    final _height = MediaQuery.of(context).size.height;
//    final _width = MediaQuery.of(context).size.width;
//    //bool isLoginPressed = true;
//    return WillPopScope(
//      onWillPop: () {
//        return showDialog(
//            context: context,
//            barrierDismissible: false,
//            builder: (BuildContext context) {
//              return AlertDialog(
//                title: Text("Confirm Exit"),
//                content: Text("Are you sure you want to exit?"),
//                actions: <Widget>[
//                  FlatButton(
//                    child: Text("YES"),
//                    onPressed: () {
//                      SystemNavigator.pop();
//                    },
//                  ),
//                  FlatButton(
//                    child: Text("NO"),
//                    onPressed: () {
//                      Navigator.of(context).pop();
//                    },
//                  )
//                ],
//              );
//            });
//      },
//      child: Scaffold(
//        body: Stack(
//          children: <Widget>[
//            Container(
//              height: _height,
//              width: _width,
//              color: Colors.black,
//              child: SafeArea(
//                  child: Padding(
//                padding:
//                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                child: SingleChildScrollView(
//                  child: Column(
//                    children: <Widget>[
//                      _buildErrorWidget(),
//                      SizedBox(
//                        height: _height * 0.05,
//                      ),
//                      Text("Hello"),
//                      SizedBox(
//                        height: _height * 0.05,
//                      ),
//                      GoogleSignInButton(onPressed: () async {
//                        final auth =
//                        Provider.of<FirebaseAuthServices>(context, listen: false);
//                        try {
//                          //   await auth.signInWithGoogle();
//                          performLogin(auth);
//                        } catch (error) {
//                          setState(() {
//                            _warning = error.message;
//                          });
//                        }
//                      }),
//                      SizedBox(
//                        height: _height * 0.05,
//                      ),
//                      SizedBox(
//                        height: _height * 0.05,
//                      )
//                    ],
//                  ),
//                ),
//              )),
//            ),
//            isLoginPressed ? showLoadingDialog() : SizedBox.shrink(),
//          ],
//        ),
//      ),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF75A2EA);
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    //bool isLoginPressed = true;
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Exit"),
                content: Text("Are you sure you want to exit?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("YES"),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                  FlatButton(
                    child: Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: _height,
              width: _width,
              color: Colors.black,
              child: SafeArea(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _buildErrorWidget(),
                      SizedBox(
                        height: _height * 0.05,
                      ),
                      buildHeadingAutoSizeText(),
                      SizedBox(
                        height: _height * 0.05,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: _buildWidgets() +
                                _checkPolicy() +
                                _buildButtons(),
                          )),
                      SizedBox(
                        height: _height * 0.05,
                      ),
                      SizedBox(
                        height: _height * 0.05,
                      )
                    ],
                  ),
                ),
              )),
            ),
            isLoginPressed ? showLoadingDialog() : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  AutoSizeText buildHeadingAutoSizeText() {
    String header_text;
    if (authFormType == AuthFormType.SignIn) {
      header_text = "SIgn In";
    } else if (authFormType == AuthFormType.reset)
      header_text = "Forgot password";
    else {
      header_text = "Create New Account";
    }
    return AutoSizeText(
      header_text,
      maxLines: 1,
      style: TextStyle(fontSize: 40, color: Colors.white),
    );
  }

  List<Widget> _buildWidgets() {
    List<Widget> textfields = [];

    if (authFormType == AuthFormType.reset) {
      textfields.add(TextFormField(
        style: TextStyle(fontSize: 22),
        validator: Emailvalidator.validate,
        decoration: buildSignUpinputDecoration("Email"),
        keyboardType: TextInputType.text,
        onSaved: (String value) => _email = value,
      ));
      textfields.add(SizedBox(
        height: 20,
      ));

      return textfields;
    }
    if (authFormType == AuthFormType.SignUp) {
      textfields.add(TextFormField(
        style: TextStyle(fontSize: 22),
        validator: Namevalidator.validate,
        decoration: buildSignUpinputDecoration("Name"),
        keyboardType: TextInputType.text,
        onSaved: (String value) => _name = value,
      ));
      textfields.add(SizedBox(
        height: 20,
      ));
    }

    textfields.add(TextFormField(
      style: TextStyle(fontSize: 22),
      validator: Emailvalidator.validate,
      decoration: buildSignUpinputDecoration("Email"),
      keyboardType: TextInputType.emailAddress,
      onSaved: (String value) => _email = value,
    ));
    textfields.add(SizedBox(
      height: 20,
    ));
    textfields.add(TextFormField(
      style: TextStyle(fontSize: 22),
      obscureText: true,
      validator: Passwordvalidator.validate,
      keyboardType: TextInputType.text,
      decoration: buildSignUpinputDecoration("Password"),
      onSaved: (String value) => _password = value,
    ));
    textfields.add(SizedBox(
      height: 20,
    ));

    return textfields;
  }

  List<Widget> _checkPolicy() {
    if (authFormType == AuthFormType.SignUp) {
      return [
        SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Checkbox(
                value: terms_accepted,
                onChanged: (bool value) {
                  setState(() {
                    terms_accepted = value;
                  });
                }),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return PolicyPage();
                    }));
                  },
                  child: RichText(
                    text: TextSpan(
                      text: '',
                      style: TextStyle(color: Colors.red),
                      */
/*defining default style is optional *//*

                      children: <TextSpan>[
                        TextSpan(
                            text: ' I have read, understood and agree',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.lightGreenAccent)),
                        TextSpan(
                            text: ' \n to the  ',
                            style: TextStyle(color: Colors.lightGreenAccent)),
                        TextSpan(
                          text: 'Terms of use.',
                          style: TextStyle(
                              color: Colors.red,
                              decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        )
      ];
    } else {
      return [SizedBox.shrink()];
    }
  }

  List<Widget> _buildButtons() {
    String _switchButtonText, _newFormState, _submitButtonText;
    bool _showForgotpasswordButton = false;
    bool _showSocialButton = false;

    if (authFormType == AuthFormType.SignIn) {
      _switchButtonText = "Create New Account";
      _newFormState = "signUp";
      _submitButtonText = "Sign In";
      _showForgotpasswordButton = true;
      _showSocialButton = true;
    } else if (authFormType == AuthFormType.reset) {
      _switchButtonText = "Return to Login";
      _newFormState = "signIn";
      _submitButtonText = "Submit";
      _showSocialButton = false;
    } else {
      _switchButtonText = "Have an Account? Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Sign Up";
      _showSocialButton = true;
    }

    return [
      Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: Colors.white,
            child: Text(
              _submitButtonText,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 22),
            ),
            onPressed: () {
              submit(context);
            }),
      ),
      showForgotPasswordButton(_showForgotpasswordButton),
      FlatButton(
          onPressed: () {
            switchFormState(_newFormState);
          },
          child: Text(
            _switchButtonText,
            style: TextStyle(color: Colors.white),
          )),
      SizedBox(
        height: 10,
      ),
      showSocialIcons(_showSocialButton),
    ];
  }

  Widget showForgotPasswordButton(bool visible) {
    return Visibility(
      visible: visible,
      child: FlatButton(
          onPressed: () {
            setState(() {
              authFormType = AuthFormType.reset;
            });
          },
          child: Text(
            "Forgot Password?",
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Widget showSocialIcons(bool visible) {
    //final auth = Provider.of(context).auth;

    return Visibility(
        visible: visible,
        child: Column(
          children: <Widget>[
            Divider(
              color: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
            GoogleSignInButton(onPressed: () async {
              final auth =
                  Provider.of<FirebaseAuthServices>(context, listen: false);
              try {
                //   await auth.signInWithGoogle();
                performLogin(auth);
              } catch (error) {
                setState(() {
                  _warning = error.message;
                });
              }
            }),
            SizedBox(
              height: 10,
            ),
          ],
        ));
  }

  _buildErrorWidget() {
    if (_warning != null) {
      return Container(
        color: Colors.yellow,
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child:
                  IconButton(icon: Icon(Icons.error_outline), onPressed: () {}),
            ),
            Expanded(
              child: AutoSizeText(
                _warning,
                maxLines: 3,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _warning = null;
                    });
                  }),
            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  InputDecoration buildSignUpinputDecoration(String labelHint) {
    return InputDecoration(
        hintText: labelHint,
        filled: true,
        fillColor: Colors.grey,
        focusColor: Colors.white,
        contentPadding: EdgeInsets.only(top: 10, bottom: 10, left: 14),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 3)));
  }
}
*/




import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ludobettings/screens/policy_page.dart';
import 'package:ludobettings/services/firebase_auth_services.dart';
import 'package:ludobettings/utils/Constants.dart';
import 'package:ludobettings/widget/showLoading.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = "/SignUpPage";


  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isLoginPressed = false;

  _SignUpPageState();

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  String _email, _password, _name, _warning;
  bool terms_accepted = false;

  bool isValid() {
    final form = _formKey.currentState;

    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }


  performLogin(FirebaseAuthServices auth) {
    setState(() {
      isLoginPressed = true;
    });
    auth.signInWithGoogle().then((FirebaseUser user) {
      if (user != null) {
        autheticateUser(user, auth);
      } else {
        setState(() {
          isLoginPressed = false;
        });
        _warning = "We have Encountered an Error. Please Try Again";
        print("Error Occured During Loin");
      }
    });
  }

  performCreateAccWithEmail(FirebaseAuthServices auth) {
    setState(() {
      isLoginPressed = true;
    });

    if (terms_accepted) {
      auth
          .createUserWithEmailAndPassword(_email, _name, _password)
          .then((FirebaseUser user) {
        if (user != null) {
          autheticateUser(user, auth);
        } else {
          _warning = "We have Encountered an Error. Please Try Again";
          print("Error Occured Durin Loin");
        }
      });
    } else {
      setState(() {
        isLoginPressed = false;
      });
      Fluttertoast.showToast(
          msg: "Accept the Terms And Conditions",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

    }
  }

  autheticateUser(FirebaseUser user, FirebaseAuthServices auth) {
    if (user != null) {
      auth.authenticateUser(user).then((isNewUser) {
        isLoginPressed = false;
        print("User is ${isNewUser.toString()}");
        if (isNewUser) {
          auth.addToDb(user).then((value) {
            print("Add to Db called");
          });
        } else {
          print("Old user");
        }
      });
    } else {
      setState(() {
        isLoginPressed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF75A2EA);
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    //bool isLoginPressed = true;
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Exit"),
                content: Text("Are you sure you want to exit?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("YES"),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                  FlatButton(
                    child: Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: _height,
              width: _width,
              color: Colors.black,
              child: SafeArea(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          _buildErrorWidget(),
                          SizedBox(
                            height: _height * 0.05,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: CircleAvatar(
                                radius: 100,
                                child: Image.asset(
                                  Constants.app_logo,
                                  height: MediaQuery.of(context).size.height * 0.2,
                                ),
                              ),
                            ),
                          ),
                          buildHeadingAutoSizeText(),
                          SizedBox(
                            height: _height * 0.1,
                          ),
                          Text(
                            "Welcome to Ludo Contest, Here you can join ludo contest and earn rewards.",
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: _height * 0.05,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Checkbox(
                                  value: terms_accepted,
                                  onChanged: (bool value) {
                                    setState(() {
                                      terms_accepted = value;
                                    });
                                  }),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                            return PolicyPage();
                                          }));
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: '',
                                        style: TextStyle(color: Colors.red),
                                        /*defining default style is optional */
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                              ' I have read, understood and agree',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.lightGreenAccent)),
                                          TextSpan(
                                              text: ' \n to the  ',
                                              style: TextStyle(
                                                  color: Colors.lightGreenAccent)),
                                          TextSpan(
                                            text: 'Terms of use.',
                                            style: TextStyle(
                                                color: Colors.red,
                                                decoration:
                                                TextDecoration.underline),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: _height * 0.1,
                          ),
                          Visibility(
                            visible: true,
                            child: GoogleSignInButton(onPressed: () async {
                              if (terms_accepted) {
                                final auth = Provider.of<FirebaseAuthServices>(
                                    context,
                                    listen: false);
                                try {
                                  //   await auth.signInWithGoogle();
                                  performLogin(auth);
                                } catch (error) {
                                  setState(() {
                                    _warning = error.message;
                                  });
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Accept the Terms And Conditions",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );

                              }
                            }),
                          ),

                          SizedBox(
                            height: _height * 0.05,
                          )
                        ],
                      ),
                    ),
                  )),
            ),
            isLoginPressed ? showLoadingDialog() : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  AutoSizeText buildHeadingAutoSizeText() {
    String header_text = "Ludo Contest";

    return AutoSizeText(
      header_text,
      maxLines: 1,
      style: TextStyle(fontSize: 40, color: Colors.white),
    );
  }

  _buildErrorWidget() {
    if (_warning != null) {
      return Container(
        color: Colors.yellow,
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child:
              IconButton(icon: Icon(Icons.error_outline), onPressed: () {}),
            ),
            Expanded(
              child: AutoSizeText(
                _warning,
                maxLines: 3,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _warning = null;
                    });
                  }),
            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
