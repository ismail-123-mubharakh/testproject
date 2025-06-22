import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cart_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<CalculateTotals>(_onCalculateTotals);
    on<ResetValue>(_resetValues);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);

    // Check if product with same storage already exists
    final existingIndex = items.indexWhere(
            (item) => item.product.id == event.product.id
    );

    if (existingIndex >= 0) {
      // Increment quantity if exists
      items[existingIndex] = items[existingIndex].copyWith(
          quantity: items[existingIndex].quantity + 1
      );
    } else {
      // Add new item
      items.add(CartItem(
        product: event.product,
      ));
    }

    emit(state.copyWith(items: items));
    final newItems = items;

    // Then automatically calculate totals
    add(CalculateTotals(
      discountPercentage: event.product.discount!.toDouble(), // Your default discount
      deliveryFee: 5.99,     // Your default delivery fee
    ));
  }


  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    items.remove(event.item);
    emit(state.copyWith(items: items));

  }

  void _resetValues(ResetValue event ,Emitter<CartState> emit ){
    emit(state.copyWith(
      subtotal: 0,
      discountAmount: 0,
      deliveryFee: 0,
      total: 0,
    ));
  }

  void _onCalculateTotals(CalculateTotals event, Emitter<CartState> emit) {
    final subtotal = state.items.fold(
        0.0,
            (sum, item) => sum + (item.product.price! * item.quantity)
    );

    final discountAmount = state.items.fold(
      0.0,
          (sum, item) {
        if (item.product.discount != null) {
          return sum + (item.product.price! * item.quantity * item.product.discount! / 100);
        }
        return sum;
      },
    );    final total = subtotal + event.deliveryFee - discountAmount;

    emit(state.copyWith(
      subtotal: subtotal,
      discountAmount: discountAmount,
      deliveryFee: event.deliveryFee,
      total: total,
    ));
  }

  static CartState resetState() {
    return const CartState(
      items: [],
      subtotal: 0,
      discountAmount: 0,
      deliveryFee: 0,
      total: 0,
    );
  }
}