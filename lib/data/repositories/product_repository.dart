import 'dart:convert';

import '../../core/constants/app_constants.dart';
import '../../core/utils/widgets/common_widgets/custom_exeption_handle.dart';
import '../models/product_model.dart';
import '../providers/api_provider.dart';

class ProductRepository {
  final ApiProvider _apiProvider;

  ProductRepository({ApiProvider? apiProvider})
      : _apiProvider = apiProvider ?? ApiProvider();

  Future<List<ProductModel>> getProducts() async {
    try {
      final response =
      await _apiProvider.client.get(AppConstants.productsEndpoint);

      final List<dynamic> jsonList = jsonDecode(response.data);
      return jsonList
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on FormatException {
      throw const ParseException('Invalid response format from server.');
    }
  }
}