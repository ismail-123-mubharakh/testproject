import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Sample cart items data
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
    final subtotal = cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return _buildCartItem(item);
              },
            ),
          ),
          _buildPromoCodeSection(),
          _buildOrderSummary(subtotal, discountAmount, total),
          _buildCheckoutButton(total),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              item.imageUrl,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 16),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.variant,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildQuantitySelector(item),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(CartItem item) {
    return Container(
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
        ],
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
          TextButton(
            onPressed: () {
              // Handle promo code change
            },
            child: const Text('Change'),
          ),
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
          _buildSummaryRow('Delivery Fee:', '\$${deliveryFee.toStringAsFixed(2)}'),
          _buildSummaryRow('Discount:', '${discountPercentage.toStringAsFixed(0)}%'),
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