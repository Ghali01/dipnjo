import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:user/logic/controllers/locations.dart';
import 'package:user/logic/controllers/my_cart.dart';
import 'package:user/logic/models/my_cart.dart';
import 'package:user/ui/screens/locations.dart';
import 'package:user/ui/widgets/app_bar.dart';
import 'package:user/utilities/colors.dart';
import 'package:user/utilities/routes.dart';

class MyCartPage extends StatelessWidget {
  const MyCartPage({Key? key}) : super(key: key);

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
                        child: Container(
                          height: 150,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          width: 270,
                                          child: Text(
                                            state != null
                                                ? 'details details details  details  details  details  details  details  details  details  details  details  details  details  details  details  details  details '
                                                : '',
                                            softWrap: false,
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
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Text(
                                            state != null
                                                ? state['dist'].toString()
                                                : '',
                                            style: const TextStyle(
                                                color: AppColors.brown4,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
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
                      );
                    },
                  ),
                  // const S
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
