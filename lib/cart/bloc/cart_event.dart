import '../../product/models/product_category_model.dart';
import '../models/cart_model.dart';

abstract class CartEvent {}

class AddToCart extends CartEvent {
  final Product product;


  AddToCart(this.product,);
}

class RemoveFromCart extends CartEvent {
  final CartItem item;

  RemoveFromCart(this.item);
}

class ResetValue extends CartEvent{
  final double discountPercentage;
  final double deliveryFee;
  final double subtotal;
  final double total;
  ResetValue(this.discountPercentage,this.deliveryFee,this.subtotal,this.total);
}

class CalculateTotals extends CartEvent {
  final double discountPercentage;
  final double deliveryFee;

  CalculateTotals({required this.discountPercentage, required this.deliveryFee});
}
