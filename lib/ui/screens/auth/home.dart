import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:user/ui/screens/auth/choose_method.dart';
import 'package:user/utilities/colors.dart';
import 'package:user/utilities/routes.dart';
import 'package:easy_localization/easy_localization.dart';

class MainAuthPage extends StatelessWidget {
  const MainAuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                SizedBox(
                    width: double.infinity,
                    child: Image.asset('assets/images/auth_bg.png',
                        fit: BoxFit.fill)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Expanded(flex: 2, child: SizedBox()),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                tr('homeTitle'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                tr('homeSubtitle'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.brown1,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ))
                  ],
                )
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed(
                      RoutesGenerater.chooesAuthMethod,
                      arguments: ChooesMethodArgs(
                          intent: ChooesMethodIntent.register)),
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ).tr(),
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          AppColors.white1.withOpacity(.4)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 16)),
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.brown2),
                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed(
                      RoutesGenerater.chooesAuthMethod,
                      arguments:
                          ChooesMethodArgs(intent: ChooesMethodIntent.login)),
                  child: Text(
                    'Log in',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ).tr(),
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          AppColors.brown1.withOpacity(.4)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 16)),
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.white1),
                      foregroundColor:
                          MaterialStateProperty.all(AppColors.brown2)),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
