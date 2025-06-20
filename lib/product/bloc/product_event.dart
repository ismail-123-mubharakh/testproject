part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}
class FetchInitialData extends ProductEvent {}
class FetchCategories extends ProductEvent {}

class FetchProducts extends ProductEvent {}

class SelectCategory extends ProductEvent {
  final int categoryIndex;

  const SelectCategory(this.categoryIndex);

  @override
  List<Object> get props => [categoryIndex];
}