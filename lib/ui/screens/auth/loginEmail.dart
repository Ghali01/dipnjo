import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:user/logic/controllers/loginEmail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/logic/models/loginEmail.dart';
import 'package:user/ui/screens/auth/verifyEmail.dart';
import 'package:user/utilities/colors.dart';
import 'package:user/utilities/routes.dart';

class LoginEmailPage extends StatelessWidget {
  LoginEmailPage({Key? key}) : super(key: key);
  // ghale001.wrok@gmail.com
  final TextEditingController email = TextEditingController();
  // TextEditingController(text: 'ghale001.wrok@gmail.com');
  final TextEditingController password = TextEditingController();
  // TextEditingController(text: '12345678');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SizedBox(
              width: double.infinity,
              child:
                  Image.asset('assets/images/auth_bg3.png', fit: BoxFit.fill)),
          Column(
            children: [
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 130,
                      ),
                      const Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.w600),
                      ).tr(),
                      const SizedBox(
                        height: 26,
                      ),
                      const Text(
                        'loginSubtitle',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.brown1,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ).tr()
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: BlocProvider(
                  create: (context) => LoginEmailCubit(),
                  child: BlocListener<LoginEmailCubit, LoginEmailState>(
                    listenWhen: (previous, current) => current.goNext,
                    listener: (context, state) {
                      if (FirebaseAuth.instance.currentUser!.emailVerified) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            RoutesGenerater.home, (route) => false);
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            RoutesGenerater.emailVerify, (route) => false,
                            arguments: EmailVerifyArgs(false));
                      }
                    },
                    child: Scaffold(
                      body: Padding(
                        padding:
                            const EdgeInsets.only(left: 16, right: 16, top: 64),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextField(
                              cursorColor: AppColors.brown2,
                              controller: email,
                              decoration: InputDecoration(
                                hintText: tr('email'),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.grey.shade600,
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red.shade900)),
                                errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: .2, color: Colors.grey.shade600),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: .2, color: Colors.grey.shade600),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextField(
                              cursorColor: AppColors.brown2,
                              controller: password,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: tr('password'),
                                prefixIcon: Icon(
                                  Icons.key_outlined,
                                  color: Colors.grey.shade600,
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red.shade900)),
                                errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: .2, color: Colors.grey.shade600),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: .2, color: Colors.grey.shade600),
                                ),
                              ),
                            ),
                            BlocSelector<LoginEmailCubit, LoginEmailState,
                                String>(
                              selector: (state) => state.error,
                              builder: (context, state) => Text(
                                state,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Builder(
                                builder: (context) => InkWell(
                                      onTap: () => context
                                          .read<LoginEmailCubit>()
                                          .login(email.text, password.text),
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
                                            padding:
                                                const EdgeInsets.only(top: 16),
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'Login',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ).tr()),
                                          ),
                                        ],
                                      ),
                                    )),
                            const SizedBox(
                              height: 8,
                            ),
                            BlocSelector<LoginEmailCubit, LoginEmailState,
                                    bool>(
                                selector: (state) => state.loading,
                                builder: (context, state) => state
                                    ? const CircularProgressIndicator()
                                    : const SizedBox()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
