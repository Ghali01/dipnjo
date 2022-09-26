import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:user/logic/controllers/share.dart';
import 'package:user/logic/models/share.dart';
import 'package:user/ui/widgets/app_bar.dart';
import 'package:user/utilities/colors.dart';

class SharePage extends StatelessWidget {
  const SharePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 56),
        child: AppAppBar(title: 'Share'),
      ),
      body: BlocProvider(
        create: (context) => ShareCubit(),
        child: BlocBuilder<ShareCubit, ShareState>(
          buildWhen: (previous, current) => previous.loaded != current.loaded,
          builder: (context, state) {
            if (!state.loaded) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFE7E7E7),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 24,
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(100)),
                            child: const Icon(
                              Icons.star,
                              color: Color(0xFFE7E7E7),
                              size: 32,
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'My Points',
                                style: TextStyle(
                                  color: Color(0xff273037),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ).tr(),
                              Text(
                                'balance',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 20,
                                ),
                              ).tr(args: [
                                (state.usersSharedCount! * 200).toString()
                              ]),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 64,
                    ),
                    SizedBox(
                      height: 168,
                      child: Image.asset(
                        'assets/images/share.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const Text(
                      'shareText',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24),
                    ).tr(),
                    const SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: DottedBorder(
                        dashPattern: const [10, 10, 10, 10],
                        strokeWidth: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            state.code.toString(),
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    BlocSelector<ShareCubit, ShareState, String>(
                      selector: (state) => state.error,
                      builder: (context, state) {
                        return Text(
                          state,
                          style: const TextStyle(color: Colors.red),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    BlocBuilder<ShareCubit, ShareState>(
                      buildWhen: (previous, current) =>
                          previous.shareCodeValidated !=
                              current.shareCodeValidated ||
                          previous.loading == current.loading,
                      builder: (context, state) {
                        return state.shareCodeValidated!
                            ? const SizedBox()
                            : state.loading
                                ? const CircularProgressIndicator()
                                : InkWell(
                                    onTap: () async {
                                      int? code = await showDialog(
                                          context: context,
                                          builder: (_) => _ScanDialog());
                                      if (code != null) {
                                        context
                                            .read<ShareCubit>()
                                            .scanCode(code);
                                      }
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(32),
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
                                          SizedBox(
                                            width: double.infinity,
                                            height: 64,
                                            child: Center(
                                                child: const Text(
                                              "Add Code",
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ).tr()),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: InkWell(
                        onTap: () => Share.share(
                            tr('MyCode', args: [state.code.toString()])),
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
                            SizedBox(
                              width: double.infinity,
                              height: 64,
                              child: Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Share",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ).tr(),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  SvgPicture.asset(
                                    'assets/svg/share.svg',
                                    width: 24,
                                    height: 24,
                                  )
                                ],
                              )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ScanDialog extends StatelessWidget {
  _ScanDialog({Key? key}) : super(key: key);
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 160,
          child: Column(
            children: [
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                cursorColor: AppColors.brown2,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'Code',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.brown2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.brown2),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    Navigator.of(context).pop(int.parse(controller.text));
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(AppColors.brown2)),
                child: const Text('Add').tr(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
