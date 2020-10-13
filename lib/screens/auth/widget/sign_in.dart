import 'package:flutter/material.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:school_timetable_app/screens/auth/widget/sign_in_up_bar.dart';
import 'package:school_timetable_app/screens/auth/widget/title.dart';

class SignIn extends StatelessWidget {
  const SignIn({
    Key key,
    @required this.onRegisterClicked,
  }) : super(key: key);
  final VoidCallback onRegisterClicked;

  @override
  Widget build(BuildContext context) {
    final isSubmitting = context.isSubmitting();
    return SignInForm(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: LoginTitle(
                    title: "Welcome\nBack",
                  ),
                )),
            Expanded(
                flex: 4,
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: EmailTextFormField(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: PasswordTextFormField(),
                    ),
                    SignInBar(
                      isLoading: isSubmitting,
                      label: 'Sign In',
                      onPressed: () {
                        context.signInWithEmailAndPassword();
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        splashColor: Colors.white,
                        onTap: () {
                          onRegisterClicked?.call();
                        },
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: "Sign Up ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
