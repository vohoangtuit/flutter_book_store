import 'dart:async';

import 'package:bookstore/data/remote/product_service.dart';
import 'package:bookstore/model/product.dart';
import 'package:bookstore/model/rest_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';


class ProductRepo {
  ProductService _productService;

  ProductRepo({@required ProductService productService})
      : _productService = productService;

  Future<List<Product>> getProductList() async {
    var c = Completer<List<Product>>();
    try {
      var response = await _productService.getProductList();
      var productList = Product.parseProductList(response.data);
      c.complete(productList);
    } on DioError {
      c.completeError(RestError.fromData('Không có dữ liệu'));
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }
}
