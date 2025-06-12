import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../models/category_model.dart';
import '../models/product_category_model.dart';
import '../service/product_service.dart';

class ProductViewModel with ChangeNotifier {
  CategoryModel? categoryModel;
  bool isLoading = false;
  String? errorMessage;
  List<String> categoryList = [
  ]; // Initialize as empty list instead of nullable
  List<Product> productList = [
  ]; // Initialize as empty list instead of nullable



  Future<void> getCategory() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final value = await ProductService.fetchCategory()
          .timeout(const Duration(seconds: 30));

      if (value != null && value.categories != null) {
        categoryModel = value;
        categoryList = List<String>.from(value.categories!);
      } else {
        categoryList = [];
        errorMessage = "No categories found";
      }
    } on TimeoutException {
      errorMessage = "Request timed out";
      categoryList = [];
    } catch (e) {
      errorMessage = "Failed to load categories: ${e.toString()}";
      categoryList = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProductList() async {
    try {
      isLoading = true;
      errorMessage = null;

      final value = await ProductService.fetchProductList()
          .timeout(const Duration(seconds: 30));

      if (value != null && value.products != null) {
        productList.addAll(value.products!);
      } else {
        productList = [];
        errorMessage = "No categories found";
      }
    } on TimeoutException {
      errorMessage = "Request timed out";
      productList = [];
    } catch (e) {
      errorMessage = "Failed to load categories: ${e.toString()}";
      productList = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }


// Remove the redundant getProductDetails method
  }
}