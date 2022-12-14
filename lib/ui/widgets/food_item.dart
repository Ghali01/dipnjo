import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:user/logic/models/cart_item.dart';
import 'package:user/ui/screens/cart_item.dart';
import 'package:user/utilities/colors.dart';
import 'package:user/utilities/server.dart';

class FoodItem extends StatelessWidget {
  final Map food;
  const FoodItem({
    Key? key,
    required this.food,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showBottomSheet(
          context: context,
          builder: (_) => CartItem(
                id: food['id'],
                status: CartItemStatus.paid,
              )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 250,
              width: 100,
              child: Image.network(
                Server.getAbsluteUrl(food['imageUrl']),
                fit: BoxFit.cover,
                loadingBuilder: (_, child, chunk) {
                  if (chunk == null ||
                      chunk.cumulativeBytesLoaded == chunk.expectedTotalBytes) {
                    return child;
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  food['name'],
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              MediaQuery.of(context).size.width >= 350
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "Let's Go",
                          style: TextStyle(fontSize: 13),
                        ).tr(),
                        const Icon(
                          Icons.arrow_forward,
                          size: 19,
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
          Builder(builder: (context) {
            double price = food['price'];
            if (food['offer'] != null) {
              if (food['offer']['type'] == '1') {
                price = price - (price * food['offer']['value'] / 100);
              }
              if (food['offer']['type'] == '2') {
                price = food['offer']['value'];
              }
            }

            return Flex(
              direction: MediaQuery.of(context).size.width >= 350
                  ? Axis.horizontal
                  : Axis.vertical,
              children: [
                Row(
                  children: [
                    food['offer'] != null
                        ? Padding(
                            padding: const EdgeInsetsDirectional.only(end: 8),
                            child: Text(
                              food['price'].toString(),
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.gold1,
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    MediaQuery.of(context).size.width >= 600
                                        ? 16
                                        : 14,
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Text(
                      'amount',
                      style: TextStyle(
                        color: AppColors.gold1,
                        fontWeight: FontWeight.w600,
                        fontSize:
                            MediaQuery.of(context).size.width >= 600 ? 16 : 14,
                      ),
                    ).tr(args: [price.toString()]),
                  ],
                ),
                food['offer'] != null && food['offer']['type'] == '1'
                    ? Padding(
                        padding: const EdgeInsetsDirectional.only(start: 8),
                        child: Text(
                          '${food["offer"]["value"].toInt()}%',
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            color: Colors.red.shade900,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            );
          })
        ],
      ),
    );
  }
}
