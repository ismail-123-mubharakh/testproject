import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

import '../models/category_model.dart';
import '../models/product_category_model.dart';

class ProductService {
  static const String _baseUrl1 =
      'https://fakestoreapi.com/api/products/category';
  static const String _baseUrl2 =
      'https://fakestoreapi.in/api/products/category?type=mobile';
  static const int _timeoutSeconds = 15;

  static Future<CategoryModel> fetchCategory() async {
    try {
      final response = await http
          .get(Uri.parse('https://fakestoreapi.in/api/products/category'))
          .timeout(const Duration(seconds: _timeoutSeconds));

      log("API Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        return CategoryModel.fromJson(responseJson);
      } else {
        throw HttpException('HTTP ${response.statusCode}');
      }
    } on SocketException catch (e) {
      throw Exception('No internet connection: ${e.message}');
    } on HttpException catch (e) {
      throw Exception('Failed to load data: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Invalid data format: ${e.message}');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }

  static Future<ProductCategoryModel> fetchProductList() async {
    try {
      final response = await http
          .get(
            Uri.parse(
              'https://fakestoreapi.in/api/products/category?type=mobile',
            ),
          )
          .timeout(const Duration(seconds: _timeoutSeconds));

      log("API Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        return ProductCategoryModel.fromJson(responseJson);
      } else {
        throw HttpException('HTTP ${response.statusCode}');
      }
    } on SocketException catch (e) {
      throw Exception('No internet connection: ${e.message}');
    } on HttpException catch (e) {
      throw Exception('Failed to load data: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Invalid data format: ${e.message}');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }
}
