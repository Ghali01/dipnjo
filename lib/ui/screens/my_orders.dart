import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/logic/controllers/my_orders.dart';
import 'package:user/logic/models/my_orders.dart';
import 'package:user/ui/widgets/app_bar.dart';
import 'package:user/ui/widgets/order_tiem.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({Key? key}) : super(key: key);
  ScrollController genScrollController(MyOrdersCubit cubit) {
    ScrollController controller = ScrollController();
    controller.addListener(() {
      if (!cubit.state.noMore &&
          !cubit.state.loading &&
          controller.offset >= controller.position.maxScrollExtent &&
          !controller.position.outOfRange) {
        cubit.load().then((value) => null);
      }
    });
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 56),
        child: AppAppBar(title: 'Your Orders'),
      ),
      body: BlocProvider(
        create: (context) => MyOrdersCubit(),
        child: BlocSelector<MyOrdersCubit, MyOrdersState, bool>(
          selector: (state) => state.loaded,
          builder: (context, state) {
            if (!state) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              controller: genScrollController(context.read<MyOrdersCubit>()),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    alignment: AlignmentDirectional.centerStart,
                    height: 70,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    decoration: BoxDecoration(
                      color: const Color(0xffF1F1F3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Current',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ).tr(),
                  ),
                ),
                BlocSelector<MyOrdersCubit, MyOrdersState, List>(
                  selector: (state) => state.current,
                  builder: (context, state) {
                    return Column(
                      children: state
                          .map((e) => OrderItem(
                                order: e,
                                history: false,
                              ))
                          .toList(),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    alignment: AlignmentDirectional.centerStart,
                    height: 70,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    decoration: BoxDecoration(
                      color: const Color(0xffF1F1F3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'History',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ).tr(),
                  ),
                ),
                BlocSelector<MyOrdersCubit, MyOrdersState, List>(
                  selector: (state) => state.history,
                  builder: (context, state) {
                    return Column(
                      children: state
                          .map((e) => OrderItem(
                                order: e,
                                history: true,
                              ))
                          .toList(),
                    );
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
