import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/firebase_options.dart';
import 'package:user/logic/providers/account.dart';
import 'package:user/utilities/colors.dart';
import 'package:user/utilities/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.instance.onTokenRefresh
      .listen((fcmToken) => AccountAPI.SetFCMToken(fcmToken))
      .onError(print);
  // AccountAPI.SetFCMToken((await FirebaseMessaging.instance.getToken())!);
  // FirebaseAuth.instance.signOut();
  runApp(
    EasyLocalization(
      path: 'assets/translations',
      saveLocale: false,
      startLocale: const Locale('en'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      initialRoute: RoutesGenerater.main,
      onGenerateRoute: RoutesGenerater.generator,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              actionsIconTheme: IconThemeData(color: AppColors.brown4)),
          fontFamily: 'Montserrat Alternates',
          progressIndicatorTheme:
              const ProgressIndicatorThemeData(color: AppColors.brown2),
          buttonTheme:
              ButtonThemeData(splashColor: AppColors.brown1.withOpacity(.4)),
          primaryColor: AppColors.brown2,
          splashColor: AppColors.brown1,
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: AppColors.brown1.withOpacity(.5))),
    );
  }
}
