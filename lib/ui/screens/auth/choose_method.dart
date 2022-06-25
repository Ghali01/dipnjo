import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:user/utilities/colors.dart';
import 'package:user/utilities/routes.dart';

enum ChooesMethodIntent { register, login }

class ChooesMethodArgs {
  ChooesMethodIntent intent;
  ChooesMethodArgs({
    required this.intent,
  });
}

class ChooesMethodPage extends StatelessWidget {
  ChooesMethodArgs args;
  ChooesMethodPage({Key? key, required this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/images/auth_bg2.png', fit: BoxFit.fill),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),
                      Container(
                          width: 68,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4)),
                          child: Row(
                            children: [
                              Container(
                                height: 8,
                                width: 16,
                                decoration: BoxDecoration(
                                    color: AppColors.brown2,
                                    borderRadius: BorderRadius.circular(4)),
                              ),
                              const SizedBox(
                                width: 40,
                              )
                            ],
                          )),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        '1/3. ${tr('step')}',
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Text(
                        args.intent == ChooesMethodIntent.register
                            ? 'Create An Account Via:'
                            : 'Login Via:',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 24),
                      ).tr(),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        args.intent == ChooesMethodIntent.register
                            ? 'chooes your register method'
                            : 'chooes your login method',
                        style: const TextStyle(
                          color: AppColors.brown1,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ).tr()
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pushNamed(
                              args.intent == ChooesMethodIntent.register
                                  ? RoutesGenerater.registerPhone
                                  : RoutesGenerater.loginPhone),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(
                                      width: .5, color: Colors.grey.shade400),
                                ),
                              ),
                              overlayColor: MaterialStateProperty.all(
                                  Colors.grey.withOpacity(.4))),
                          child: const Text(
                            'Mobile Phone Number',
                            style: TextStyle(
                                color: AppColors.brown1,
                                fontWeight: FontWeight.bold),
                          ).tr(),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pushNamed(
                              args.intent == ChooesMethodIntent.register
                                  ? RoutesGenerater.registerEmail
                                  : RoutesGenerater.loginEmail),
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                Colors.grey.withOpacity(.4)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                    width: .5, color: Colors.grey.shade400),
                              ),
                            ),
                          ),
                          child: const Text(
                            'e-mail',
                            style: TextStyle(
                                color: AppColors.brown1,
                                fontWeight: FontWeight.bold),
                          ).tr(),
                        ),
                        args.intent == ChooesMethodIntent.register
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Do You Have An Account? ',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ).tr(),
                                  InkWell(
                                    onTap: () => Navigator.of(context)
                                        .pushReplacementNamed(
                                      RoutesGenerater.chooesAuthMethod,
                                      arguments: ChooesMethodArgs(
                                          intent: ChooesMethodIntent.login),
                                    ),
                                    child: const Text(
                                      'Log in',
                                      style: TextStyle(
                                          color: AppColors.gold1,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ).tr(),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "D'not You Have An Account? ",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ).tr(),
                                  InkWell(
                                    onTap: () => Navigator.of(context)
                                        .pushReplacementNamed(
                                      RoutesGenerater.chooesAuthMethod,
                                      arguments: ChooesMethodArgs(
                                          intent: ChooesMethodIntent.register),
                                    ),
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(
                                          color: AppColors.gold1,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ).tr(),
                                  ),
                                ],
                              )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: AlignmentDirectional.topStart,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: const EdgeInsetsDirectional.only(top: 28, start: 8),
                child: Container(
                  width: 30,
                  height: 30,
                  padding: const EdgeInsetsDirectional.only(start: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(300),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.brown1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
