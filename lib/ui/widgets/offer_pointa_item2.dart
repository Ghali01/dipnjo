import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:user/ui/screens/cart_item.dart';
import 'package:user/utilities/colors.dart';
import 'package:user/utilities/server.dart';

class OfferPointsItem2 extends StatelessWidget {
  final Map food;
  const OfferPointsItem2({
    Key? key,
    required this.food,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showBottomSheet(
          context: context,
          builder: (_) =>
              CartItem(id: food['id'], status: CartItemStatus.free)),
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
            children: [
              Expanded(
                child: Text(
                  food['name'],
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    "Let's Go",
                    style: TextStyle(fontSize: 14),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: 22,
                  ),
                ],
              ),
            ],
          ),
          Text(
            'offerPoints',
            overflow: TextOverflow.fade,
            style: TextStyle(
              color: Colors.red.shade900,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ).tr(args: [food['points'].toString()]),
        ],
      ),
    );
  }
}
