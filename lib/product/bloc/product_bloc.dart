import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:testsc/product/models/product_category_model.dart';
import 'package:testsc/product/dataSources//product_service.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<FetchCategories>(_onFetchCategories);
    on<FetchProducts>(_onFetchProducts);
    on<SelectCategory>(_onSelectCategory);
  }

// Simplified individual handlers
  Future<void> _onFetchCategories(
      FetchCategories event,
      Emitter<ProductState> emit,
      ) async {
    if (state is ProductCategoriesLoaded) {
      final currentState = state as ProductCategoriesLoaded;
      emit(currentState.copyWith(isCategoriesLoading: true));
    } else {
      emit(ProductLoading());
    }

    try {
      final categories = await ProductService.fetchCategory();
      emit(ProductCategoriesLoaded(
        categories: categories.categories ?? [],
        selectedCategoryIndex: 0,
        products: state is ProductCategoriesLoaded
            ? (state as ProductCategoriesLoaded).products
            : [],
      ));
    } catch (e) {
      emit(ProductError(message: 'Failed to load categories: $e'));
    }
  }

  Future<void> _onFetchProducts(
      FetchProducts event,
      Emitter<ProductState> emit,
      ) async {
    if (state is! ProductCategoriesLoaded) {
      // Option 1: Automatically fetch categories first
      //add(FetchCategories());
      // Then fetch products after categories are loaded
      await Future.delayed(Duration.zero); // Allow categories event to process
      add(FetchProducts());
      return;
    }

    final currentState = state as ProductCategoriesLoaded;
    emit(currentState.copyWith(isProductsLoading: true));

    try {
      final products = await ProductService.fetchProductList();
      emit(currentState.copyWith(
        products: products.products ?? [],
        isProductsLoading: false,
      ));
    } catch (e) {
      emit(currentState.copyWith(
        errorMessage: 'Failed to load products: $e',
        isProductsLoading: false,
      ));
    }
  }
  void _onSelectCategory(
      SelectCategory event,
      Emitter<ProductState> emit,
      ) {
    if (state is ProductCategoriesLoaded) {
      final currentState = state as ProductCategoriesLoaded;
      emit(currentState.copyWith(selectedCategoryIndex: event.categoryIndex));
    }
  }
}