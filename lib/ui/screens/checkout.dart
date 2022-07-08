import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:user/logic/controllers/checkout.dart';
import 'package:user/logic/models/checkout.dart';
import 'package:user/ui/widgets/app_bar.dart';
import 'package:user/utilities/colors.dart';
import 'package:user/utilities/routes.dart';

class CheckoutArgs {
  double totalCurrency;
  double dist;
  int points;
  CheckoutArgs({
    required this.totalCurrency,
    required this.dist,
    required this.points,
  });
}

class CheckoutPage extends StatelessWidget {
  CheckoutArgs args;
  CheckoutPage({Key? key, required this.args}) : super(key: key);
  TextEditingController promo = TextEditingController(text: 'sba');
  void _setTime(BuildContext context) async {
    TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.input,
        builder: (_, child) => Theme(
            data: Theme.of(context).copyWith(
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(AppColors.brown3),
                ),
              ),
              timePickerTheme: TimePickerThemeData(
                dayPeriodColor: AppColors.brown1.withOpacity(.3),
                dayPeriodTextColor: AppColors.brown2,
                hourMinuteColor: AppColors.brown4,
                entryModeIconColor: AppColors.brown4,
                dialHandColor: AppColors.brown2,
                dialTextColor: Colors.black,
                hourMinuteTextColor: Colors.black,
                inputDecorationTheme: InputDecorationTheme(
                    contentPadding: EdgeInsets.zero,
                    fillColor: AppColors.brown1.withOpacity(.1),
                    filled: true,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.brown1),
                    ),
                    enabledBorder: const OutlineInputBorder()),
              ),
            ),
            child: child!));

    if (time != null) {
      context.read<CheckoutCubit>().setTime(time);
    }
  }

  String _timeFormat(TimeOfDay time) {
    return '${time.hour}:${time.minute}';
  }

  // 33.43347967066062, 36.255868127463536 shnaya
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 56),
        child: AppAppBar(title: 'CHECKOUT'),
      ),
      body: BlocProvider(
        create: (context) => CheckoutCubit(
            totalCurrency: args.totalCurrency,
            dist: args.dist,
            points: args.points),
        child: BlocConsumer<CheckoutCubit, CheckoutState>(
          listenWhen: (previous, current) =>
              current.couponError != '' || current.done,
          listener: (context, state) {
            if (state.couponError != '') {
              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: const Text(
                          'Invalid Code',
                        ).tr(),
                        titleTextStyle: const TextStyle(
                          color: AppColors.brown4,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        content: Text(state.couponError).tr(),
                        contentTextStyle: const TextStyle(
                          color: AppColors.brown4,
                          fontSize: 18,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              Navigator.of(ctx).pop();
                            },
                            child: const Text(
                              'Close',
                              style: TextStyle(
                                color: AppColors.brown4,
                                fontSize: 18,
                              ),
                            ).tr(),
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                AppColors.brown1.withOpacity(.1),
                              ),
                            ),
                          )
                        ],
                      ));
              context.read<CheckoutCubit>().clearCouponError();
            }
            if (state.done) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(RoutesGenerater.home, (_) => false);
            }
          },
          buildWhen: (previous, current) => previous.loaded != current.loaded,
          builder: (context, state) {
            if (!state.loaded) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 7,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 250,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  state.userData!['lat'],
                                  state.userData!['lng'],
                                ),
                                zoom: 20),
                            zoomGesturesEnabled: false,
                            zoomControlsEnabled: false,
                            scrollGesturesEnabled: false,
                            rotateGesturesEnabled: false,
                            markers: {
                              Marker(
                                  markerId: const MarkerId('user'),
                                  position: LatLng(state.userData!['lat'],
                                      state.userData!['lng']))
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.black,
                                    size: 32,
                                  ),
                                  Text(
                                    state.userData!['name'],
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(start: 12),
                                child: Text(
                                  state.userData!['details'],
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(start: 12),
                                child: Text(
                                  'mob',
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ).tr(args: [state.userData!['phone']]),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  BlocSelector<CheckoutCubit, CheckoutState, TimeOfDay?>(
                    selector: (state) => state.time,
                    builder: (context, state) {
                      return InkWell(
                        onTap: () => _setTime(context),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 7,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: SvgPicture.asset(
                                        'assets/svg/clock.svg',
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      state != null
                                          ? _timeFormat(state)
                                          : 'As Soon As Possible',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ).tr()
                                  ],
                                ),
                                state != null
                                    ? IconButton(
                                        onPressed: () => context
                                            .read<CheckoutCubit>()
                                            .clearTime(),
                                        icon: const Icon(Icons.close,
                                            color: AppColors.brown2))
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  BlocBuilder<CheckoutCubit, CheckoutState>(
                    buildWhen: (previous, current) =>
                        current.promoCode != previous.promoCode ||
                        current.promoLoading != previous.promoLoading,
                    builder: (context, state) {
                      if (state.promoCode != null) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.brown1,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'promoCod',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                          ).tr(args: [state.promoCode!]),
                        );
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: TextField(
                                controller: promo,
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.brown1,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                      'assets/svg/promo.svg',
                                      width: 40,
                                      color: AppColors.brown4,
                                      height: 40,
                                    ),
                                  ),
                                  hintText: tr('Have A Promo Code?'),
                                  hintStyle: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      decoration: TextDecoration.underline),
                                ),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: state.promoLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : TextButton(
                                    onPressed: () {
                                      if (promo.text.isNotEmpty) {
                                        context
                                            .read<CheckoutCubit>()
                                            .validateCoupon(promo.text);
                                      }
                                    },
                                    style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(
                                        AppColors.brown1.withOpacity(.1),
                                      ),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      minimumSize: MaterialStateProperty.all(
                                          Size(60, 60)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.brown4),
                                    ),
                                    child: const Icon(
                                      Icons.done,
                                      size: 32,
                                      color: Colors.white,
                                    ),
                                  ),
                          )
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Pay With',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ).tr(),
                  const SizedBox(
                    height: 8,
                  ),
                  BlocSelector<CheckoutCubit, CheckoutState, String>(
                    selector: (state) => state.payMethod,
                    builder: (context, state) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () => context
                                .read<CheckoutCubit>()
                                .setPayMethod('ca'),
                            child: Card(
                              elevation: 8,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: 'ca',
                                      groupValue: state,
                                      onChanged: (v) => context
                                          .read<CheckoutCubit>()
                                          .setPayMethod(v!),
                                      fillColor: MaterialStateProperty.all(
                                          AppColors.brown1),
                                    ),
                                    SvgPicture.asset(
                                      'assets/svg/cash.svg',
                                      width: 25,
                                      height: 25,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    const Text(
                                      'CASH',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600),
                                    ).tr()
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          InkWell(
                            onTap: () => context
                                .read<CheckoutCubit>()
                                .setPayMethod('rs'),
                            child: Card(
                              elevation: 8,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: 'rs',
                                      groupValue: state,
                                      onChanged: (v) => context
                                          .read<CheckoutCubit>()
                                          .setPayMethod(v!),
                                      fillColor: MaterialStateProperty.all(
                                          AppColors.brown1),
                                    ),
                                    SvgPicture.asset(
                                      'assets/svg/recive.svg',
                                      width: 25,
                                      height: 25,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    const Text(
                                      'Receive From The Shop',
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600),
                                    ).tr()
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          InkWell(
                            onTap: () => context
                                .read<CheckoutCubit>()
                                .setPayMethod('cc'),
                            child: Card(
                              elevation: 8,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: 'cc',
                                      groupValue: state,
                                      onChanged: (v) => context
                                          .read<CheckoutCubit>()
                                          .setPayMethod(v!),
                                      fillColor: MaterialStateProperty.all(
                                          AppColors.brown1),
                                    ),
                                    SvgPicture.asset(
                                      'assets/svg/credit-card.svg',
                                      width: 25,
                                      height: 25,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    const Text(
                                      'Credit Cart',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600),
                                    ).tr()
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtotal',
                        style: TextStyle(
                          color: Color(0xff273037),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ).tr(),
                      const Text(
                        'amount',
                        style: TextStyle(
                          color: Color(0xff273037),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ).tr(args: [state.totalCurrency.toString()]),
                    ],
                  ),
                  BlocSelector<CheckoutCubit, CheckoutState, String?>(
                    selector: (state) => state.promoDiscount,
                    builder: (context, state) {
                      if (state == null) {
                        return const SizedBox();
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Coupon',
                            style: TextStyle(
                              color: Color(0xff273037),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ).tr(),
                          Text(
                            state,
                            style: const TextStyle(
                              color: Color(0xff273037),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Delivery Fee',
                        style: TextStyle(
                          color: Color(0xff273037),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ).tr(),
                      const Text(
                        'amount',
                        style: TextStyle(
                          color: Color(0xff273037),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ).tr(args: [state.deliveryFee.toString()]),
                    ],
                  ),
                  BlocSelector<CheckoutCubit, CheckoutState, double>(
                    selector: (state) => state.total,
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: TextStyle(
                              color: Colors.red.shade900,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ).tr(),
                          Text(
                            'amount',
                            style: TextStyle(
                              color: Colors.red.shade900,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ).tr(args: [state.toString()]),
                        ],
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Points',
                        style: TextStyle(
                          color: Color(0xff273037),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ).tr(),
                      Text(
                        args.points.toString(),
                        style: const TextStyle(
                          color: Color(0xff273037),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ).tr(),
                    ],
                  ),
                  Center(
                    child: BlocSelector<CheckoutCubit, CheckoutState, String>(
                      selector: (state) => state.error,
                      builder: (context, state) => Text(
                        state,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  Center(
                    child: BlocSelector<CheckoutCubit, CheckoutState, bool>(
                      selector: (state) => state.loading,
                      builder: (context, state) => state
                          ? const CircularProgressIndicator()
                          : const SizedBox(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: InkWell(
                      onTap: () => context.read<CheckoutCubit>().sendOrder(),
                      child: SizedBox(
                        height: 65,
                        child: Stack(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: SvgPicture.asset(
                                  'assets/svg/btn_bg.svg',
                                  height: 64,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: const Text(
                                  'PLACE ORDER',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ).tr()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
