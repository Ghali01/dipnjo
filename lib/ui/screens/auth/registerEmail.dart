import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:user/logic/controllers/registerEmail.dart';
import 'package:user/logic/models/registerEmail.dart';
import 'package:user/logic/models/user.dart';
import 'package:user/ui/screens/auth/verifyEmail.dart';
import 'package:user/utilities/colors.dart';
import 'package:user/utilities/routes.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterEmailPage extends StatefulWidget {
  RegisterEmailPage({Key? key}) : super(key: key);

  @override
  State<RegisterEmailPage> createState() => _RegisterEmailPageState();
}

class _RegisterEmailPageState extends State<RegisterEmailPage> {
  TextEditingController name = TextEditingController(text: 'ghale'),
      // email = TextEditingController(text: ''),
      email = TextEditingController(text: 'ghale001.wrok@gmail.com'),
      password = TextEditingController(text: '12345678'),
      // password = TextEditingController(text: ''),
      date = TextEditingController(text: '2001-8-8'),
      city = TextEditingController(text: 'damascus');
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? isNotEmpty(String? text) {
    if (text == null || text.isEmpty) {
      return "this field is empty";
    }
  }

  String? passwordValidator(String? text) {
    if (text == null || text.isEmpty) {
      return "this field is empty";
    } else {
      if (text.length < 8) {
        return "the password should be at least 8 char";
      }
    }
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
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
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
                                width: 40,
                                decoration: BoxDecoration(
                                    color: AppColors.brown2,
                                    borderRadius: BorderRadius.circular(4)),
                              ),
                              const SizedBox(
                                width: 22,
                              )
                            ],
                          )),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        '2/3. ${tr('step')}',
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      const Text(
                        'Create An Account',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 24),
                      ).tr(),
                      const SizedBox(
                        height: 24,
                      ),
                      const Text(
                        'personal information',
                        style: TextStyle(
                          color: AppColors.brown1,
                          fontWeight: FontWeight.w500,
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
                  child: BlocProvider(
                    create: (context) => RegisterEmailCubit(),
                    child: BlocListener<RegisterEmailCubit, RegisterEmailState>(
                      listenWhen: (previous, current) => current.sent,
                      listener: (context, state) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            RoutesGenerater.emailVerify, (_) => false,
                            arguments: EmailVerifyArgs(true));
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 44, left: 16, right: 16),
                        child: Form(
                          key: formKey,
                          child: ListView(
                            children: [
                              TextFormField(
                                cursorColor: AppColors.brown2,
                                validator: isNotEmpty,
                                controller: name,
                                decoration: InputDecoration(
                                  hintText: tr('name'),
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: Colors.grey.shade600,
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red.shade900)),
                                  errorBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red)),
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
                              TextFormField(
                                cursorColor: AppColors.brown2,
                                validator: isNotEmpty,
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: tr('email'),
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: Colors.grey.shade600,
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red.shade900)),
                                  errorBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red)),
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
                              TextFormField(
                                cursorColor: AppColors.brown2,
                                validator: passwordValidator,
                                controller: password,
                                keyboardType: TextInputType.phone,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: tr('password'),
                                  prefixIcon: Icon(
                                    Icons.key_outlined,
                                    color: Colors.grey.shade600,
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red.shade900)),
                                  errorBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red)),
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
                              BlocSelector<RegisterEmailCubit,
                                  RegisterEmailState, String>(
                                selector: (state) => state.gender,
                                builder: (context, state) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () => context
                                              .read<RegisterEmailCubit>()
                                              .setGender('m'),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 0.3,
                                                    color: state == 'm'
                                                        ? AppColors.brown3
                                                        : Colors.grey.shade600),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Row(
                                              children: [
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Icon(Icons.male,
                                                    color: state == 'm'
                                                        ? AppColors.brown3
                                                        : Colors.grey.shade600),
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                Text(
                                                  'Male',
                                                  style: TextStyle(
                                                      color: state == 'm'
                                                          ? AppColors.brown3
                                                          : Colors
                                                              .grey.shade600),
                                                ),
                                                Radio<String>(
                                                  value: "m",
                                                  fillColor:
                                                      MaterialStateProperty.all(
                                                          state == 'm'
                                                              ? AppColors.brown3
                                                              : Colors.grey
                                                                  .shade600),
                                                  groupValue: state,
                                                  onChanged: (v) => context
                                                      .read<
                                                          RegisterEmailCubit>()
                                                      .setGender(v!),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () => context
                                              .read<RegisterEmailCubit>()
                                              .setGender('f'),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 0.3,
                                                    color: state == 'f'
                                                        ? AppColors.brown3
                                                        : Colors.grey.shade600),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Row(
                                              children: [
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Icon(Icons.female,
                                                    color: state == 'f'
                                                        ? AppColors.brown3
                                                        : Colors.grey.shade600),
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                Text(
                                                  'Female',
                                                  style: TextStyle(
                                                      color: state == 'f'
                                                          ? AppColors.brown3
                                                          : Colors
                                                              .grey.shade600),
                                                ),
                                                Radio<String>(
                                                  value: "f",
                                                  fillColor:
                                                      MaterialStateProperty.all(
                                                          state == 'f'
                                                              ? AppColors.brown3
                                                              : Colors.grey
                                                                  .shade600),
                                                  groupValue: state,
                                                  onChanged: (v) => context
                                                      .read<
                                                          RegisterEmailCubit>()
                                                      .setGender(v!),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                cursorColor: AppColors.brown2,
                                validator: isNotEmpty,
                                controller: date,
                                keyboardType: TextInputType.datetime,
                                decoration: InputDecoration(
                                  hintText: tr('birthday'),
                                  prefixIcon: Icon(
                                    Icons.calendar_today_outlined,
                                    color: Colors.grey.shade600,
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red.shade900)),
                                  errorBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red)),
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
                              TextFormField(
                                cursorColor: AppColors.brown2,
                                validator: isNotEmpty,
                                controller: city,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: tr('city'),
                                  prefixIcon: Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.grey.shade600,
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red.shade900)),
                                  errorBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red)),
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
                              BlocSelector<RegisterEmailCubit,
                                  RegisterEmailState, String>(
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
                                        onTap: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            context
                                                .read<RegisterEmailCubit>()
                                                .send(RegisterEmailUser(
                                                  name: name.text,
                                                  email: email.text,
                                                  password: password.text,
                                                  city: city.text,
                                                  birth: date.text, // TODO
                                                  gender: context
                                                      .read<
                                                          RegisterEmailCubit>()
                                                      .state
                                                      .gender,
                                                ));
                                          }
                                        },
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
                                                    'Continue',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ).tr()),
                                            ),
                                          ],
                                        ),
                                      )),
                              const SizedBox(
                                height: 8,
                              ),
                              BlocSelector<RegisterEmailCubit,
                                  RegisterEmailState, bool>(
                                selector: (state) => state.loading,
                                builder: (context, state) => state
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          ),
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
