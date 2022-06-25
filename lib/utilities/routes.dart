import 'package:flutter/material.dart';
import 'package:user/logic/models/user.dart';
import 'package:user/ui/screens/auth/choose_method.dart';
import 'package:user/ui/screens/auth/loginEmail.dart';
import 'package:user/ui/screens/auth/loginPhone.dart';
import 'package:user/ui/screens/auth/registerEmail.dart';
import 'package:user/ui/screens/auth/verifyPhone.dart';
import 'package:user/ui/screens/favorite_food.dart';
import 'package:user/ui/screens/home.dart';
import 'package:user/ui/screens/locations.dart';
import 'package:user/ui/screens/main.dart';
import 'package:user/ui/screens/auth/verifyEmail.dart';
import 'package:user/ui/screens/auth/home.dart';
import 'package:user/ui/screens/auth/registerPhone.dart';
import 'package:user/ui/screens/menu.dart';
import 'package:user/ui/screens/my_cart.dart';

class RoutesGenerater {
  static const home = '/home';
  static const mainAuth = '/mainAuth';
  static const main = '/';
  static const chooesAuthMethod = '/chooesAuthMethod';
  static const registerEmail = '/registerEmail';
  static const registerPhone = '/registerPhone';
  static const emailVerify = '/emailVerify';
  static const phoneVerify = '/phoneVerify';
  static const loginPhone = '/loginPhoen';
  static const loginEmail = '/loginEmail';
  static const menu = '/menu';
  static const favorites = '/favorites';
  static const locations = '/locations';
  static const myCart = '/myCart';
  static Route? generator(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case main:
        return MaterialPageRoute(builder: (_) => MainPage());
      case mainAuth:
        return MaterialPageRoute(builder: (_) => const MainAuthPage());

      case registerEmail:
        return MaterialPageRoute(builder: (_) => RegisterEmailPage());
      case registerPhone:
        return MaterialPageRoute(builder: (_) => RegisterPhonePage());

      case emailVerify:
        var args = settings.arguments as EmailVerifyArgs;
        return MaterialPageRoute(
            builder: (_) => EmailVerify(
                  args: args,
                ));
      case phoneVerify:
        var args = settings.arguments as VerifyPhoneArgs;
        return MaterialPageRoute(builder: (_) => VerifyPhone(args: args));
      case chooesAuthMethod:
        var args = settings.arguments as ChooesMethodArgs;
        return MaterialPageRoute(builder: (_) => ChooesMethodPage(args: args));
      case loginPhone:
        return MaterialPageRoute(builder: (_) => LoginPhonePage());
      case loginEmail:
        return MaterialPageRoute(builder: (_) => LoginEmailPage());
      case menu:
        MenuPageArgs args = settings.arguments as MenuPageArgs;
        return MaterialPageRoute(
            builder: (_) => MenuPage(
                  args: args,
                ));
      case favorites:
        return MaterialPageRoute(builder: (_) => const FavoriteFoodsPage());
      case locations:
        var args = settings.arguments as LocationsArgs;
        return MaterialPageRoute(
            builder: (_) => LocationsPage(
                  args: args,
                ));
      case myCart:
        return MaterialPageRoute(builder: (_) => const MyCartPage());
    }
    return null;
  }
}
