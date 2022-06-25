import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:user/logic/controllers/verifyPhone.dart';
import 'package:user/logic/models/user.dart' as um;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/logic/models/verifyPhone.dart';
import 'package:user/utilities/colors.dart';
import 'package:user/utilities/routes.dart';

enum VerifyPhoneFlag { register, login }

class VerifyPhoneArgs {
  um.RegisterPhoneUser? user;
  VerifyPhoneFlag flag;
  String phone;
  String vfId;
  int resendToken;
  VerifyPhoneArgs({
    this.user,
    required this.vfId,
    required this.resendToken,
    required this.flag,
    required this.phone,
  });
}

class VerifyPhone extends StatelessWidget {
  VerifyPhoneArgs args;
  VerifyPhone({Key? key, required this.args}) : super(key: key);

  String getCode() =>
      controller0.text +
      controller1.text +
      controller2.text +
      controller3.text +
      controller4.text +
      controller5.text;
  FocusNode node0 = FocusNode(),
      node1 = FocusNode(),
      node2 = FocusNode(),
      node3 = FocusNode(),
      node4 = FocusNode(),
      node5 = FocusNode();
  TextEditingController controller0 = TextEditingController(),
      controller1 = TextEditingController(),
      controller2 = TextEditingController(),
      controller3 = TextEditingController(),
      controller4 = TextEditingController(),
      controller5 = TextEditingController();
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
                        'Enter The Code Sent To Your Phone',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 24),
                      ).tr(),
                      const SizedBox(
                        height: 24,
                      ),
                      const Text(
                        'we sent',
                        style: TextStyle(
                          color: AppColors.brown1,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ).tr(args: [args.phone])
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
                        VerifyPhoneCubit(args.resendToken, args.vfId),
                    child: BlocListener<VerifyPhoneCubit, VerifyPhoneState>(
                      listenWhen: (previous, current) => current.verifed,
                      listener: (context, state) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            RoutesGenerater.home, (_) => false);
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 64, left: 16, right: 16),
                        child: Column(
                          children: [
                            BlocSelector<VerifyPhoneCubit, VerifyPhoneState,
                                List>(
                              selector: (state) => state.codes,
                              builder: (context, state) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      height: 40,
                                      child: TextField(
                                        controller: controller0,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        maxLength: 1,
                                        cursorColor: AppColors.brown1,
                                        style: const TextStyle(fontSize: 24),
                                        decoration: InputDecoration(
                                          counter: const SizedBox(),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 16),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: .3,
                                                color: Colors.grey.shade600),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: .3,
                                                color: Colors.grey.shade600),
                                          ),
                                        ),
                                        onChanged: (v) {
                                          context
                                              .read<VerifyPhoneCubit>()
                                              .setNCStatus(0);
                                          if (v.isNotEmpty) {
                                            node0.requestFocus();
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    state[0]
                                        ? SizedBox(
                                            width: 50,
                                            height: 40,
                                            child: TextField(
                                              controller: controller1,
                                              maxLength: 1,
                                              focusNode: node0,
                                              cursorColor: AppColors.brown1,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              style:
                                                  const TextStyle(fontSize: 24),
                                              decoration: InputDecoration(
                                                counter: const SizedBox(),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 16),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: .3,
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: .3,
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                              ),
                                              onChanged: (_) {
                                                context
                                                    .read<VerifyPhoneCubit>()
                                                    .setNCStatus(1);
                                                node1.requestFocus();
                                              },
                                            ),
                                          )
                                        : Image.asset(
                                            'assets/images/donuts.png'),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    state[1]
                                        ? SizedBox(
                                            width: 50,
                                            height: 40,
                                            child: TextField(
                                              maxLength: 1,
                                              controller: controller2,
                                              focusNode: node1,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              cursorColor: AppColors.brown1,
                                              style:
                                                  const TextStyle(fontSize: 24),
                                              decoration: InputDecoration(
                                                counter: const SizedBox(),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 16),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: .3,
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: .3,
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                              ),
                                              onChanged: (v) {
                                                context
                                                    .read<VerifyPhoneCubit>()
                                                    .setNCStatus(2);
                                                if (v.isNotEmpty) {
                                                  node2.requestFocus();
                                                }
                                              },
                                            ),
                                          )
                                        : Image.asset(
                                            'assets/images/donuts.png'),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    state[2]
                                        ? SizedBox(
                                            width: 50,
                                            height: 40,
                                            child: TextField(
                                              controller: controller3,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              maxLength: 1,
                                              focusNode: node2,
                                              cursorColor: AppColors.brown1,
                                              style:
                                                  const TextStyle(fontSize: 24),
                                              decoration: InputDecoration(
                                                counter: const SizedBox(),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 16),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: .3,
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: .3,
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                              ),
                                              onChanged: (v) {
                                                context
                                                    .read<VerifyPhoneCubit>()
                                                    .setNCStatus(3);
                                                if (v.isNotEmpty) {
                                                  node3.requestFocus();
                                                }
                                              },
                                            ),
                                          )
                                        : Image.asset(
                                            'assets/images/donuts.png'),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    state[3]
                                        ? SizedBox(
                                            width: 50,
                                            height: 40,
                                            child: TextField(
                                              controller: controller4,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              maxLength: 1,
                                              focusNode: node3,
                                              cursorColor: AppColors.brown1,
                                              style:
                                                  const TextStyle(fontSize: 24),
                                              decoration: InputDecoration(
                                                counter: const SizedBox(),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 16),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: .3,
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: .3,
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                              ),
                                              onChanged: (v) {
                                                context
                                                    .read<VerifyPhoneCubit>()
                                                    .setNCStatus(4);
                                                if (v.isNotEmpty) {
                                                  node4.requestFocus();
                                                }
                                              },
                                            ),
                                          )
                                        : Image.asset(
                                            'assets/images/donuts.png'),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    state[4]
                                        ? SizedBox(
                                            width: 50,
                                            height: 40,
                                            child: TextField(
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              maxLength: 1,
                                              controller: controller5,
                                              focusNode: node4,
                                              cursorColor: AppColors.brown1,
                                              style:
                                                  const TextStyle(fontSize: 24),
                                              decoration: InputDecoration(
                                                counter: const SizedBox(),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 16),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: .3,
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: .3,
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                              ),
                                              onChanged: (v) {
                                                if (getCode().length == 6) {
                                                  context
                                                      .read<VerifyPhoneCubit>()
                                                      .verify(getCode(),
                                                          args.flag, args.user);
                                                }
                                              },
                                            ),
                                          )
                                        : Image.asset(
                                            'assets/images/donuts.png'),
                                  ],
                                );
                              },
                            ),
                            BlocBuilder<VerifyPhoneCubit, VerifyPhoneState>(
                              buildWhen: (previous, current) =>
                                  previous.canSend != current.canSend ||
                                  previous.count != current.count,
                              builder: (context, state) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      state.canSend
                                          ? "try to "
                                          : "you can resend in ${state.count}",
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    state.canSend
                                        ? TextButton(
                                            onPressed: () => context
                                                .read<VerifyPhoneCubit>()
                                                .resend(args.phone),
                                            child: const Text(
                                              'resend',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: AppColors.gold1),
                                            ))
                                        : const SizedBox(),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            BlocSelector<VerifyPhoneCubit, VerifyPhoneState,
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
                                          .read<VerifyPhoneCubit>()
                                          .verify(
                                              getCode(), args.flag, args.user),
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
                                                  'Verify',
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
                            BlocSelector<VerifyPhoneCubit, VerifyPhoneState,
                                bool>(
                              selector: (state) => state.loading,
                              builder: (context, state) => state
                                  ? const CircularProgressIndicator()
                                  : const SizedBox(),
                            ),
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
