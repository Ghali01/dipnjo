import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user/utilities/server.dart';

class FoodAPI {
  static Future<String> getCategories() async {
    http.Response response = await Server.send(http.get, 'foods/category-user');
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }
    throw Exception();
  }

  static Future<List<dynamic>> getFoodSearch(
      String path, String name, int category, int page) async {
    http.Response response = await Server.send(
      http.get,
      '$path/$page',
      body: {
        'category': category,
        'name': name,
      },
    );
    if (response.statusCode == 200) {
      return [utf8.decode(response.bodyBytes), name, category];
    }

    throw Exception();
  }

  static Future<String> getAds() async {
    http.Response response = await Server.send(http.get, 'foods/advertise');

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }

    throw Exception();
  }

  static Future<String> getTopOfWeek() async {
    http.Response response = await Server.send(http.get, 'foods/tops-of-week');
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }

    throw Exception();
  }

  static Future<String> getUserPointFood() async {
    http.Response response =
        await Server.send(http.get, 'foods/user-food-points');
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }

    throw Exception();
  }

  static Future<String> getFood(int id) async {
    http.Response response = await Server.send(http.get, 'foods/food-user/$id');
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }

    throw Exception();
  }

  static Future<void> addToFav(int id) async {
    http.Response response =
        await Server.send(http.put, 'accounts/favorite-food/$id');
    if (response.statusCode == 200) {
      return;
    }
    throw Exception();
  }

  static Future<void> removeFromFav(int id) async {
    http.Response response =
        await Server.send(http.delete, 'accounts/favorite-food/$id');
    if (response.statusCode == 200) {
      return;
    }
    throw Exception();
  }

  static Future<String> getUserFavoritsFood(int page) async {
    http.Response response =
        await Server.send(http.get, 'foods/user-favorie-food/$page');
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }
    throw Exception();
  }
}
