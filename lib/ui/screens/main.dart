import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/ui/screens/auth/verifyEmail.dart';
import 'package:user/ui/screens/auth/home.dart';
import 'package:user/ui/screens/home.dart';
import 'package:user/utilities/routes.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);
  Future<void> checkAuth() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null &&
        user.providerData.first.providerId == EmailAuthProvider.PROVIDER_ID &&
        user.emailVerified == false) {
      await user.reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: checkAuth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            //  user did not login
            return const MainAuthPage();
          } else {
            // user loged
            if (user.providerData.first.providerId ==
                EmailAuthProvider.PROVIDER_ID) {
              if (FirebaseAuth.instance.currentUser!.emailVerified == false) {
                // email not verifed
                return EmailVerify(
                  args: EmailVerifyArgs(false),
                );
              } else {
                // email verifed
                return const HomePage();
              }
            } else {
              //  user loged in with phone
              return const HomePage();
            }
          }
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
