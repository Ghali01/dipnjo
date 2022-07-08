import 'package:country_code_picker/country_codes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:user/ui/screens/cart_item.dart';
import 'package:user/utilities/colors.dart';
import 'package:user/utilities/server.dart';

class OfferPointsItem extends StatelessWidget {
  final Map food;
  const OfferPointsItem({Key? key, required this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showBottomSheet(
          context: context,
          builder: (_) => CartItem(
                id: food['id'],
                status: CartItemStatus.free,
              )),
      child: SizedBox(
        width: 300,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/op-${context.locale.languageCode}.png',
              fit: BoxFit.fill,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 530,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "offerPoints",
                          style: TextStyle(
                              color: Colors.red.shade900,
                              fontSize: 22,
                              fontWeight: FontWeight.w600),
                        ).tr(args: [food['points'].toString()]),
                        Text(
                          food['name'],
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.brown2,
                              fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 270,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        alignment: Alignment.center,
                        // color: Colors.black,
                        child: SizedBox(
                          width: 64,
                          // height: 64,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              Server.getAbsluteUrl(food['imageUrl']),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
