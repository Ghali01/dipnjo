import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:user/utilities/server.dart';

class OrderAPI {
  static Future<void> addItemToCart(
      int food, int count, int freeItems, List additions) async {
    http.Response response = await Server.send(
        http.post, 'orders/add-cart-item', body: {
      'food': food,
      'count': count,
      'freeItems': freeItems,
      'additions': additions
    });
    if (response.statusCode == 201) {
      return;
    }
    throw Exception();
  }

  static Future<String> getCartItem() async {
    http.Response response = await Server.send(http.get, 'orders/user-cart');
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }
    throw Exception();
  }
}
