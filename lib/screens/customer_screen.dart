import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CustomerScreen extends StatefulWidget {
  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List products = [];
  List cartItems = [];
  List orders = [];

  String message = "";

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchOrders();
  }

  // 🔥 FETCH PRODUCTS
  void fetchProducts() async {
    var data = await ApiService.getProducts();
    setState(() => products = data);
  }

  // 🔥 FETCH ORDERS
  void fetchOrders() async {
    var data = await ApiService.getOrders();
    setState(() => orders = data);
  }

  // 🛒 ADD TO CART
  void addToCart(product) {
    setState(() {
      cartItems.add({
        "product_id": product["id"],
        "product_name": product["name"],
        "price": product["price"],
        "quantity": 1
      });
      message = "${product["name"]} added";
    });
  }

  // ❌ REMOVE FROM CART
  void removeFromCart(index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  // 📦 PLACE ORDER
  void placeOrder() async {
    if (cartItems.isEmpty) {
      setState(() => message = "Cart is empty");
      return;
    }

    await ApiService.placeOrder(cartItems);

    setState(() {
      message = "Order placed successfully";
      cartItems.clear();
    });

    fetchOrders();
  }

  // 💰 TOTAL
  double getTotal() {
    double total = 0;
    for (var item in cartItems) {
      total += item["price"] * item["quantity"];
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customer Dashboard")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔔 MESSAGE
              if (message.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.green[100],
                  child: Text(message),
                ),

              SizedBox(height: 10),

              // 🛒 CART SECTION
              Text("Cart", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

              ...cartItems.map((item) => ListTile(
                    title: Text(item["product_name"]),
                    subtitle: Text("₹ ${item["price"]} x ${item["quantity"]}"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => removeFromCart(cartItems.indexOf(item)),
                    ),
                  )),

              Text("Total: ₹ ${getTotal()}"),

              ElevatedButton(
                onPressed: placeOrder,
                child: Text("Place Order"),
              ),

              Divider(),

              // 📦 PRODUCTS
              Text("Products", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

              ...products.map((p) => Card(
                    child: ListTile(
                      title: Text(p["name"]),
                      subtitle: Text("₹ ${p["price"]}"),
                      trailing: ElevatedButton(
                        onPressed: () => addToCart(p),
                        child: Text("Add"),
                      ),
                    ),
                  )),

              Divider(),

              // 📜 ORDERS
              Text("My Orders", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

              ...orders.map((o) => Card(
                    child: ListTile(
                      title: Text("Order #${o["id"]}"),
                      subtitle: Text("₹ ${o["total_price"]} - ${o["status"]}"),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}