import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/db/notification.dart';
import 'package:user/firebase_options.dart';
import 'package:user/logic/providers/account.dart';
import 'package:user/utilities/colors.dart';
import 'package:user/utilities/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'utilities/notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:user/utilities/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.instance.onTokenRefresh
      .listen((fcmToken) => AccountAPI.SetFCMToken(fcmToken))
      .onError(print);
  // await FirebaseMessaging.instance.subscribeToTopic('user');
  await initNoitification();
  FirebaseMessaging.onMessage
      .listen((msg) => handleNotification(msg).then((value) => null));
  FirebaseMessaging.onBackgroundMessage(handleNotification);
  await Hive.initFlutter();
  Hive.registerAdapter(NotificationModelAdapter());
  // print(await FirebaseMessaging.instance.getToken());
  // logout();
  // print(FirebaseAuth.instance.currentUser!);
  // AccountAPI.SetFCMToken((await FirebaseMessaging.instance.getToken())!);
  // FirebaseAuth.instance.signOut();
  // SharedPreferences sp = await SharedPreferences.getInstance();
  // sp.remove('currentLocationId');
  // sp.remove('userPhone');

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      saveLocale: true,
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
      locale: context.locale,
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
