import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:user/utilities/server.dart';

class OrderAPI {
  static Future<void> addItemToCart(
      int food, int count, int freeItems, List additions, String note) async {
    http.Response response =
        await Server.send(http.post, 'orders/add-cart-item', body: {
      'food': food,
      'count': count,
      'freeItems': freeItems,
      'additions': additions,
      'note': note,
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

  static Future<void> clearCartItems() async {
    http.Response response = await Server.send(http.delete, 'orders/user-cart');
    if (response.statusCode == 204) {
      return;
    }
    throw Exception();
  }

  static Future<void> deleteCartItem(int id) async {
    http.Response response =
        await Server.send(http.delete, 'orders/del-cart-item/$id');
    if (response.statusCode == 204) {
      return;
    }
    throw Exception();
  }

  static Future<String> validateCoupon(String key) async {
    http.Response response =
        await Server.send(http.get, 'orders/validate-coupon/$key');
    if (response.statusCode == 404) {
      throw CouponEx(CouponExType.notFound);
    } else if (response.statusCode == 521) {
      throw CouponEx(CouponExType.used);
    } else if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }
    throw Exception();
  }

  static Future<void> sendOrded(
      String? time, String? promoCode, String payMethod, int location) async {
    http.Response response =
        await Server.send(http.post, 'orders/send-order', body: {
      'recieveTime': time,
      'promoCode': promoCode,
      'payMethod': payMethod,
      'location': location
    });
    print(response.body);
    if (response.statusCode == 201) {
      return;
    }
    throw Exception();
  }

  static Future<String> getOrders(int page) async {
    http.Response response =
        await Server.send(http.get, 'orders/user-orders/$page');
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }
    throw Exception();
  }

  static Future<void> cancelOrder(int id) async {
    http.Response response =
        await Server.send(http.put, 'orders/cancel-order/$id');
    if (response.statusCode == 200) {
      return;
    }
    throw Exception();
  }
}

enum CouponExType { used, notFound }

class CouponEx implements Exception {
  CouponExType type;

  CouponEx(this.type);
}
