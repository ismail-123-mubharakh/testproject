import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<CartItem> cartItems = [
    CartItem(
      name: 'Xbox series X',
      variant: '1 TB',
      price: 570.00,
      quantity: 1,
      imageUrl: 'assets/xbox.png',
    ),
    CartItem(
      name: 'Wireless Controller',
      variant: 'Blue',
      price: 77.00,
      quantity: 1,
      imageUrl: 'assets/controller.png',
    ),
    CartItem(
      name: 'Razer Kaira Pro',
      variant: 'Green',
      price: 153.00,
      quantity: 1,
      imageUrl: 'assets/headset.png',
    ),
  ];

  final double deliveryFee = 5.00;
  final double discountPercentage = 40.0;

  @override
  Widget build(BuildContext context) {
    final subtotal = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    final discountAmount = subtotal * (discountPercentage / 100);
    final total = subtotal + deliveryFee - discountAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My cart'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: ( context, state) {
          return   Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:  Container(
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(item.product.image!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Product Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.model!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.product.brand!,
                                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${item.product.price!.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: () {
                                setState(() {
                                  if (item.quantity > 1) {
                                    item.quantity--;
                                  }
                                });
                              },
                            ),
                            Text(item.quantity.toString()),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () {
                                setState(() {
                                  item.quantity++;
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                BlocProvider.of<CartBloc>(context)
                                    .add(RemoveFromCart(item));
                                /*BlocProvider.of<CartBloc>(context)
                                    .add(ResetValue(0,0,0,0));*/
                              },
                            ),
                          ],
                        ),
                      )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              state.items.isNotEmpty ? Column(
                children: [
                  _buildPromoCodeSection(),
                  _buildOrderSummary(state.subtotal,state.discountAmount,state.total),
                  _buildCheckoutButton(total),
                ],
              ) : Center(child: Text("No items available"))

            ],
          );
        },

      ),
    );
  }



  Widget _buildPromoCodeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          const Text('ADJ3AK', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Icon(Icons.check_circle, color: Colors.green[400], size: 16),
          const Text(' Promocode applied'),
          const Spacer(),
          TextButton(onPressed: () {}, child: const Text('Change')),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(double subtotal, double discount, double total) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal:', '\$${subtotal.toStringAsFixed(2)}'),
          _buildSummaryRow(
            'Delivery Fee:',
            '\$${deliveryFee.toStringAsFixed(2)}',
          ),
          _buildSummaryRow(
            'Discount:',
            '${discountPercentage.toStringAsFixed(0)}%',
          ),
          const Divider(height: 24),
          _buildSummaryRow(
            'Checkout for',
            '\$${total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(double total) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            // Handle checkout
          },
          child: const Text(
            'Proceed to Checkout',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class CartItem {
  final String name;
  final String variant;
  final double price;
  int quantity;
  final String imageUrl;

  CartItem({
    required this.name,
    required this.variant,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}
