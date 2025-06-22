// cart_state.dart
import '../models/cart_model.dart';

class CartState {
  final List<CartItem> items;
  final double subtotal;
  final double discountAmount;
  final double deliveryFee;
  final double total;

  const CartState({
    this.items = const [],
    this.subtotal = 0,
    this.discountAmount = 0,
    this.deliveryFee = 0,
    this.total = 0,
  });

  CartState copyWith({
    List<CartItem>? items,
    double? subtotal,
    double? discountAmount,
    double? deliveryFee,
    double? total,
  }) {
    return CartState(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discountAmount: discountAmount ?? this.discountAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
    );
  }
}