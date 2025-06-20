part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductCategoriesLoaded extends ProductState {
  final List<String> categories;
  final List<Product> products;
  final int selectedCategoryIndex;
  final bool isProductsLoading;
  final bool isCategoriesLoading;
  final String? errorMessage;

  const ProductCategoriesLoaded({
    required this.categories,
    this.products = const [],
    this.selectedCategoryIndex = 0,
    this.isProductsLoading = false,
    this.isCategoriesLoading = false,
    this.errorMessage,
  });

  // Add copyWith method
  ProductCategoriesLoaded copyWith({
    List<String>? categories,
    List<Product>? products,
    int? selectedCategoryIndex,
    bool? isProductsLoading,
    bool? isCategoriesLoading,
    String? errorMessage,
  }) {
    return ProductCategoriesLoaded(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
      isProductsLoading: isProductsLoading ?? this.isProductsLoading,
      isCategoriesLoading: isCategoriesLoading ?? this.isCategoriesLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    categories,
    products,
    selectedCategoryIndex,
    isProductsLoading,
    isCategoriesLoading,
    errorMessage,
  ];
}

class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object> get props => [message];
}