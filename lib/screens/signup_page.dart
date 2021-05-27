import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaselogin/screens/home_page.dart';
import 'package:firebaselogin/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class SignUpPage extends StatefulWidget {
  static const pageName = '/signUpPage';
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _userName;
  String _userEmail;
  int _userPhoneNumber;
  String _userId;
  String _userPassword;
  final _formKey = new GlobalKey<FormState>();
  _signUpUser() async {
    print('sign up user');
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        final auth = FirebaseAuth.instance;
        final userCredential = await auth.createUserWithEmailAndPassword(
            email: _userEmail, password: _userPassword);
        userCredential.user.updateProfile(displayName: _userName);
        // _userId = userCredential.user.uid;
        //await Hive.openBox('userInfo');
        await Hive.box('userInfo').put('details', {
          'userName': _userName,
          'userEmail': _userEmail,
          'phoneNumber': _userPhoneNumber,
          'password': _userPassword
        });
        Navigator.of(context).pushReplacementNamed(HomePage.pageName);
      } on PlatformException catch (error) {
        print('platform exception: $error');
      } catch (error) {
        print('other error: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 150,
              width: double.infinity,
              //  color: Colors.red,
              child: Center(
                child: Text(
                  'Sign Up',
                  style: GoogleFonts.chivo(
                      color: Colors.blueGrey,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              height: deviceHeight * 0.55,
              width: deviceWidth * 0.8,
              padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
              decoration: BoxDecoration(
                  //    color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.blueGrey,
                    width: 2,
                  )),
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Full Name'),
                          validator: (input) {
                            if (input.isEmpty || input == null) {
                              return 'Full Name is Required!';
                            }
                            if (input.length < 4) {
                              return 'Name must be at least 4 characters long';
                            }
                            return null;
                          },
                          onSaved: (input) => _userName = input,
                        ),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Email'),
                          validator: (input) {
                            if (input.isEmpty || input == null) {
                              return 'Email is Required!';
                            }
                            if (!input.contains('@')) {
                              return 'Valid Email is Required!';
                            }
                            return null;
                          },
                          onSaved: (input) => _userEmail = input,
                        ),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Phone Number'),
                          keyboardType: TextInputType.phone,
                          maxLength: 11,
                          validator: (input) {
                            if (input.isEmpty || input == null) {
                              return 'Phone number is required';
                            }
                            return null;
                          },
                          onSaved: (input) =>
                              _userPhoneNumber = int.parse(input),
                        ),
                        TextFormField(
                          validator: (input) {
                            _userPassword = input;
                            if (input.isEmpty) {
                              return 'Password is Required!';
                            }
                            if (input.length < 7) {
                              return 'Password must be at least 7 characters long';
                            }
                            return null;
                          },
                          onSaved: (input) => _userPassword = input,
                          obscureText: true,
                          decoration: InputDecoration(hintText: 'Password'),
                        ),
                        TextFormField(
                          obscureText: false,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Field Cannot be Empty!';
                            }
                            if (!(input == _userPassword)) {
                              return 'Password Mismatch!';
                            }
                            return null;
                          },
                          decoration:
                              InputDecoration(hintText: 'Confirm Password'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          child: Text('Already Signed Up? Log In'),
                          onTap: () => Navigator.of(context)
                              .pushNamed(LoginPage.pageName),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        GestureDetector(
                          onTap: () {
                            _signUpUser();
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 2, color: Colors.black)),
                            child: Icon(Icons.arrow_forward),
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
