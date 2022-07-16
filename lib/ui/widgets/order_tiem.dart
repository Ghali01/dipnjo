import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/logic/controllers/my_orders.dart';
import 'package:user/utilities/server.dart';

class OrderItem extends StatelessWidget {
  final Map order;
  final bool history;
  DateFormat formater = DateFormat('d MMMM yyyy h:m a');
  OrderItem({Key? key, required this.order, required this.history})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 220,
              width: double.infinity,
              child: Image.network(
                Server.getAbsluteUrl(order['items'][0]['food']['imageUrl']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'odn',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ).tr(args: [
                  order['id'].toString(),
                ]),
                const Text(
                  'amount',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ).tr(args: [
                  order['total'].toString(),
                ]),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: history
                ? Flex(
                    direction: MediaQuery.of(context).size.width >= 350
                        ? Axis.horizontal
                        : Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formater.format(DateTime.parse(order['time'])),
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 20),
                      ),
                      Text(
                        order['status'],
                        style: TextStyle(
                          fontSize: 20,
                          color: order['status'] == 'f'
                              ? const Color(0xff00A40B)
                              : const Color(0xffB43333),
                        ),
                      ).tr(),
                    ],
                  )
                : Row(
                    mainAxisAlignment:
                        order['status'] == 'f' || order['status'] == 'q'
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.start,
                    children: [
                      Text(
                        order['status'],
                        style: TextStyle(
                          fontSize: 20,
                          color: order['status'] == 'f'
                              ? const Color(0xff00A40B)
                              : const Color(0xffB43333),
                        ),
                      ).tr(),
                      order['status'] == 'q'
                          ? order['loading'] == true
                              ? const CircularProgressIndicator()
                              : TextButton(
                                  onPressed: () => context
                                      .read<MyOrdersCubit>()
                                      .cancelOrder(order['id']),
                                  child: const Text('Cancel Order').tr(),
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xffB43333)),
                                  ),
                                )
                          : const SizedBox()
                    ],
                  ),
          )
        ],
      ),
    );
  }
}
