import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/logic/controllers/locations.dart';
import 'package:user/logic/controllers/my_cart.dart';
import 'package:user/logic/models/my_cart.dart';
import 'package:user/ui/screens/checkout.dart';
import 'package:user/ui/screens/locations.dart';
import 'package:user/ui/widgets/app_bar.dart';
import 'package:user/utilities/colors.dart';
import 'package:user/utilities/routes.dart';
import 'package:user/utilities/server.dart';

class MyCartPage extends StatelessWidget {
  const MyCartPage({Key? key}) : super(key: key);
  void _checkOutClicked(BuildContext context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.getString('userPhone') == null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(
            'Set Phone Number',
          ).tr(),
          titleTextStyle: const TextStyle(
            color: AppColors.brown4,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          content: const Text('You Have To Add Your Phone Number').tr(),
          contentTextStyle: const TextStyle(
            color: AppColors.brown4,
            fontSize: 18,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await Navigator.of(context).pushNamed(RoutesGenerater.profile);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Set',
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
        ),
      );
      return;
    }
    if (sp.getInt('currentLocationId') == null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(
            'Set Your Location',
          ).tr(),
          titleTextStyle: const TextStyle(
            color: AppColors.brown4,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          content: const Text('You Have To Set Your Location').tr(),
          contentTextStyle: const TextStyle(
            color: AppColors.brown4,
            fontSize: 18,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(
                    AppColors.brown1.withOpacity(.1),
                  ),
                ),
                child: const Text(
                  'Set',
                  style: TextStyle(
                    color: AppColors.brown4,
                    fontSize: 18,
                  ),
                ).tr())
          ],
        ),
      );
      return;
    }
    var state = context.read<MyCartCubit>().state;
    CheckoutArgs args = CheckoutArgs(
        totalCurrency: state.totalCurrency!,
        points: state.totalPoints!,
        dist: state.location!['dist']);
    Navigator.of(context).pushNamed(RoutesGenerater.checkout, arguments: args);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 56),
        child: AppAppBar(title: 'My Cart'),
      ),
      body: BlocProvider(
        create: (context) => MyCartCubit(),
        child: BlocSelector<MyCartCubit, MyCartState, bool>(
          selector: (state) => state.loaded,
          builder: (context, state) {
            if (!state) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  BlocSelector<MyCartCubit, MyCartState, Map?>(
                    selector: (state) {
                      return state.location;
                    },
                    builder: (context, state) {
                      return InkWell(
                        onTap: () async {
                          var location = await Navigator.of(context).pushNamed(
                              RoutesGenerater.locations,
                              arguments: LocationsArgs(
                                  intent: LocationsIntent.select));
                          if (location != null) {
                            context
                                .read<MyCartCubit>()
                                .setLocation(location as Map);
                          }
                        },
                        splashColor: Colors.transparent,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 150),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.brown2,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 65,
                                  child: SvgPicture.asset(
                                    'assets/svg/milk.svg',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state != null
                                                ? state['name']
                                                : tr('No Location Selecte'),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 21,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: 220,
                                            child: Text(
                                              state != null
                                                  ? state['details']
                                                  : '',
                                              // softWrap: false,
                                              overflow: TextOverflow.fade,
                                              style: const TextStyle(
                                                  color: AppColors.brown3,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          state != null
                                              ? Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Text(
                                                    state['dist']
                                                            .toStringAsFixed(
                                                                1) +
                                                        ' ' +
                                                        tr('km'),
                                                    style: const TextStyle(
                                                        color: AppColors.brown4,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 30,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'your order',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ).tr(),
                      BlocBuilder<MyCartCubit, MyCartState>(
                        buildWhen: (previous, current) =>
                            previous.itmes != current.itmes ||
                            previous.clearLoading != current.clearLoading,
                        builder: (context, state) => state.itmes == null ||
                                state.itmes!.isEmpty
                            ? const SizedBox()
                            : state.clearLoading
                                ? const CircularProgressIndicator()
                                : TextButton.icon(
                                    onPressed: () =>
                                        context.read<MyCartCubit>().clearAll(),
                                    icon: const Icon(Icons.delete),
                                    label: const Text('Clear all'),
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color:
                                                        Colors.red.shade700))),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.red.shade700)),
                                  ),
                      )
                    ],
                  ),
                  Expanded(
                    child: BlocSelector<MyCartCubit, MyCartState, List>(
                      selector: (state) => state.itmes!,
                      builder: (context, state) {
                        if (state.isEmpty) {
                          return Center(
                            child: const Text('No Items').tr(),
                          );
                        }
                        return ListView.builder(
                          itemCount: state.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: Image.network(
                                          Server.getAbsluteUrl(
                                              state[index]['food']['imageUrl']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state[index]['food']['name'],
                                          style: const TextStyle(
                                              color: AppColors.brown4,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              state[index]['count'].toString(),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            const Text(
                                              'amount',
                                              style: TextStyle(
                                                  color: AppColors.gold1,
                                                  fontSize: 18),
                                            ).tr(args: [
                                              state[index]['total'].toString()
                                            ]),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                state[index]['loading']
                                    ? const CircularProgressIndicator()
                                    : IconButton(
                                        onPressed: () => context
                                            .read<MyCartCubit>()
                                            .deleteItem(state[index]['id']),
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.grey.shade700,
                                          size: 20,
                                        ),
                                      )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: BlocBuilder<MyCartCubit, MyCartState>(
                      buildWhen: (previous, current) =>
                          previous.totalCurrency != current.totalCurrency ||
                          previous.totalPoints != current.totalPoints,
                      builder: (context, state) => state.itmes!.isEmpty
                          ? const SizedBox()
                          : InkWell(
                              onTap: () => _checkOutClicked(context),
                              child: SizedBox(
                                height: 65,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(32),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: SvgPicture.asset(
                                          'assets/svg/btn_bg.svg',
                                          height: 64,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Center(
                                                child: const Text(
                                                  'CHECKOUT',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ).tr(),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  state.totalCurrency! > 0
                                                      ? const Text(
                                                          "amount",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ).tr(args: [
                                                          state.totalCurrency
                                                              .toString()
                                                        ])
                                                      : const SizedBox(),
                                                  state.totalPoints! > 0
                                                      ? const Text(
                                                          "invoicePoints",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ).tr(args: [
                                                          state.totalPoints
                                                              .toString()
                                                        ])
                                                      : const SizedBox(),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
