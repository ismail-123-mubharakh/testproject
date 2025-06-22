import '../../product/models/product_category_model.dart';

class CartItem {
  final Product product;
  late final int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  // Add this copyWith method
  CartItem copyWith({
    Product? product,
    String? selectedStorage,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}