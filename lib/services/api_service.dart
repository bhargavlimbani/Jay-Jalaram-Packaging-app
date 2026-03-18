import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {

  static Future<Map<String, dynamic>> login(String email, String password) async {
    var res = await http.post(
      Uri.parse("${AppConstants.baseUrl}/auth/login.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    return jsonDecode(res.body);
  }

  static Future<List> getProducts() async {
    var res = await http.get(Uri.parse("${AppConstants.baseUrl}/products/get_products.php"));
    return jsonDecode(res.body);
  }

  static Future<List> getOrders() async {
    var res = await http.get(Uri.parse("${AppConstants.baseUrl}/orders/get_my_orders.php"));
    return jsonDecode(res.body);
  }

  static Future<void> placeOrder(List items) async {
    await http.post(
      Uri.parse("${AppConstants.baseUrl}/orders/place_order.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"items": items}),
    );
  }
}