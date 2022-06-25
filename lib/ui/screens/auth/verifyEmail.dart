import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/logic/controllers/verifyEmail.dart';
import 'package:user/logic/models/verifyEmail.dart';
import 'package:user/utilities/colors.dart';
import 'package:user/utilities/routes.dart';

class EmailVerifyArgs {
  final bool sentOne;
  EmailVerifyArgs(this.sentOne);
}

class EmailVerify extends StatefulWidget {
  EmailVerifyArgs args;
  EmailVerify({Key? key, required this.args}) : super(key: key);

  @override
  State<EmailVerify> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  late Timer timer;
  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await FirebaseAuth.instance.currentUser!.reload();
      // print(FirebaseAuth.instance.currentUser!.emailVerified);
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        timer.cancel();
        Navigator.of(context)
            .pushNamedAndRemoveUntil(RoutesGenerater.home, (route) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/images/auth_bg2.png', fit: BoxFit.fill),
          Column(
            children: [
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      Container(
                        height: 8,
                        width: 66,
                        decoration: BoxDecoration(
                            color: AppColors.brown2,
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        '3/3. ${tr('step')}',
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      const Text(
                        'Email Verify',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 24),
                      ).tr()
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24)),
                  child: BlocProvider(
                      create: (context) =>
                          VerifyEmailCubit(!(widget.args.sentOne)),
                      child: BlocBuilder<VerifyEmailCubit, VerifyEmailState>(
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 64),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "We send email to",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ).tr(args: [
                                  FirebaseAuth.instance.currentUser!.email!
                                ]),
                                Text(
                                  state.canSend
                                      ? ""
                                      : "You can resend in second",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ).tr(args: [state.count.toString()]),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  state.error,
                                  style: const TextStyle(color: Colors.red),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                state.canSend
                                    ? Builder(
                                        builder: (context) => InkWell(
                                          onTap: () => context
                                              .read<VerifyEmailCubit>()
                                              .resent(),
                                          child: Stack(
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: SvgPicture.asset(
                                                  'assets/svg/btn_bg.svg',
                                                  height: 64,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16),
                                                child: Align(
                                                    alignment: Alignment.center,
                                                    child: const Text(
                                                      'Resend',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ).tr()),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  height: 8,
                                ),
                                state.loading
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : const SizedBox()
                              ],
                            ),
                          );
                        },
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
