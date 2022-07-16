import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:user/logic/controllers/registerPhone.dart';
import 'package:user/logic/models/registerPhone.dart';
import 'package:user/logic/models/user.dart';
import 'package:user/ui/screens/auth/verifyPhone.dart';
import 'package:user/utilities/colors.dart';
import 'package:user/utilities/routes.dart';

class RegisterPhonePage extends StatefulWidget {
  RegisterPhonePage({Key? key}) : super(key: key);

  @override
  State<RegisterPhonePage> createState() => _RegisterPhonePageState();
}

class _RegisterPhonePageState extends State<RegisterPhonePage> {
  TextEditingController name = TextEditingController(),
      // TextEditingController(text: 'ghale'),
      phone = TextEditingController(),
      // phone = TextEditingController(text: '+1 650-555-1234'),
      date = TextEditingController();
  // date = TextEditingController(text: '2001-8-8');

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? isNotEmpty(String? text) {
    if (text == null || text.isEmpty) {
      return tr("this field is empty");
    }
  }

  String? dateValidator(String? text) {
    if (text == null || text.isEmpty) {
      return tr("this field is empty");
    } else {
      RegExp regEx =
          RegExp(r'(\d{4}-\d{1,2}-\d{1,2}$)|(\d{4}/\d{1,2}/\d{1,2}$)');
      if (!regEx.hasMatch(text)) {
        return tr('enetr vaild data');
      }
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
                            fontWeight: FontWeight.w500,
                            fontSize: 24),
                      ).tr(),
                      const SizedBox(
                        height: 24,
                      ),
                      const Text(
                        'personal information',
                        style: TextStyle(
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
                  child: BlocProvider(
                    create: (context) => RegisterPhoneCubit(),
                    child: BlocListener<RegisterPhoneCubit, RegisterPhoneState>(
                      listenWhen: (previous, current) => current.sent,
                      listener: (context, state) {
                        Navigator.of(context)
                            .pushNamed(RoutesGenerater.phoneVerify,
                                arguments: VerifyPhoneArgs(
                                    user: RegisterPhoneUser(
                                      name: name.text,
                                      phone: phone.text,
                                      birth: date.text,
                                      gender: context
                                          .read<RegisterPhoneCubit>()
                                          .state
                                          .gender,
                                    ),
                                    flag: VerifyPhoneFlag.register,
                                    phone: phone.text,
                                    vfId: state.vfId!,
                                    resendToken: state.resendToken!));
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
                                controller: date,
                                keyboardType: TextInputType.datetime,
                                decoration: InputDecoration(
                                  hintText: tr('birthday'),
                                  helperText: tr('ex: 1992-4-5'),
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
                              BlocSelector<RegisterPhoneCubit,
                                  RegisterPhoneState, String>(
                                selector: (state) => state.gender,
                                builder: (context, state) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () => context
                                              .read<RegisterPhoneCubit>()
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .only(start: 8),
                                                  child: Icon(Icons.male,
                                                      color: state == 'm'
                                                          ? AppColors.brown3
                                                          : Colors
                                                              .grey.shade600),
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
                                                          RegisterPhoneCubit>()
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
                                              .read<RegisterPhoneCubit>()
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .only(start: 8),
                                                  child: Icon(Icons.female,
                                                      color: state == 'f'
                                                          ? AppColors.brown3
                                                          : Colors
                                                              .grey.shade600),
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
                                                          RegisterPhoneCubit>()
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
                                controller: phone,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: tr('phone'),
                                  prefixIcon: Icon(
                                    Icons.phone_outlined,
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
                              Builder(
                                  builder: (context) => InkWell(
                                        onTap: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            context
                                                .read<RegisterPhoneCubit>()
                                                .send(RegisterPhoneUser(
                                                  name: name.text,
                                                  phone: phone.text,
                                                  birth: date.text,
                                                  gender: context
                                                      .read<
                                                          RegisterPhoneCubit>()
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
                              BlocSelector<RegisterPhoneCubit,
                                  RegisterPhoneState, bool>(
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
