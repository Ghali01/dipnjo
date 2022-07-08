import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:user/logic/controllers/rate.dart';
import 'package:user/logic/models/rate.dart';
import 'package:user/ui/widgets/app_bar.dart';
import 'package:user/utilities/colors.dart';

class RatePage extends StatelessWidget {
  const RatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 56),
        child: AppAppBar(title: 'Rating Us'),
      ),
      body: BlocProvider(
        create: (context) => RateCubit(),
        child: BlocBuilder<RateCubit, RateState>(
          buildWhen: (previous, current) => previous.loaded != current.loaded,
          builder: (context, state) {
            if (!state.loaded) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: [
                BlocSelector<RateCubit, RateState, int?>(
                  selector: (state) => state.myRate,
                  builder: (context, state) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFFE7E7E7),
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 24,
                            ),
                            state != null
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '$state.0 ',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 32,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Text(
                                        '/5',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 24,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () =>
                                        context.read<RateCubit>().setRate(1),
                                    icon: Icon(
                                      (state ?? 0) >= 1
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: AppColors.gold1,
                                      size: 28,
                                    )),
                                const SizedBox(
                                  width: 16,
                                ),
                                IconButton(
                                    onPressed: () =>
                                        context.read<RateCubit>().setRate(2),
                                    icon: Icon(
                                      (state ?? 0) >= 2
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: AppColors.gold1,
                                      size: 28,
                                    )),
                                const SizedBox(
                                  width: 16,
                                ),
                                IconButton(
                                    onPressed: () =>
                                        context.read<RateCubit>().setRate(3),
                                    icon: Icon(
                                      (state ?? 0) >= 3
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: AppColors.gold1,
                                      size: 28,
                                    )),
                                const SizedBox(
                                  width: 16,
                                ),
                                IconButton(
                                    onPressed: () =>
                                        context.read<RateCubit>().setRate(4),
                                    icon: Icon(
                                      (state ?? 0) >= 4
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: AppColors.gold1,
                                      size: 28,
                                    )),
                                const SizedBox(
                                  width: 16,
                                ),
                                IconButton(
                                    onPressed: () =>
                                        context.read<RateCubit>().setRate(5),
                                    icon: Icon(
                                      (state ?? 0) >= 5
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: AppColors.gold1,
                                      size: 28,
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.rateData!.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 24,
                          ),
                          SizedBox(
                            width: 32,
                            child: Center(
                              child: Text(
                                state.rateData![index]['rate'].toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          const Icon(
                            Icons.star,
                            color: Color(0xff909090),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: LinearPercentIndicator(
                              percent:
                                  state.rateData![index]['count'] / state.total,
                              backgroundColor: const Color(0xFFE7E7E7),
                              progressColor: AppColors.gold1,
                              lineHeight: 10,
                              barRadius: const Radius.circular(8),
                            ),
                          ),
                          const SizedBox(
                            width: 32,
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 64),
                            child: Center(
                              child: Text(
                                state.rateData![index]['count'].toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 32,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
