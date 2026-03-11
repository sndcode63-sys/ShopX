import 'package:get/get.dart';
import '../../core/utils/widgets/common_widgets/custom_exeption_handle.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

enum ProductStatus { initial, loading, success, error }

class ProductController extends GetxController {
  final ProductRepository _repository;

  ProductController({ProductRepository? repository})
      : _repository = repository ?? ProductRepository();

  //  Observables
  final _products = <ProductModel>[].obs;
  final _filteredProducts = <ProductModel>[].obs;
  final _status = ProductStatus.initial.obs;
  final _errorMessage = ''.obs;
  final _searchQuery = ''.obs;
  final _selectedCategory = 'all'.obs;

  //  Getters
  List<ProductModel> get products => _filteredProducts;
  ProductStatus get status => _status.value;
  String get errorMessage => _errorMessage.value;
  String get selectedCategory => _selectedCategory.value;
  bool get isLoading => _status.value == ProductStatus.loading;
  bool get hasError => _status.value == ProductStatus.error;
  bool get hasData => _status.value == ProductStatus.success;

  List<String> get categories {
    final cats = _products.value.map((p) => p.category).toSet().toList();
    cats.sort();
    return ['all', ...cats];
  }

  // Lifecycle
  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // Fetch
  Future<void> fetchProducts() async {
    _status.value = ProductStatus.loading;
    _errorMessage.value = '';

    try {
      final data = await _repository.getProducts();
      _products.assignAll(data);
      _applyFilters();
      _status.value = ProductStatus.success;
    } on NetworkException catch (e) {
      _errorMessage.value = e.message;
      _status.value = ProductStatus.error;
    } on TimeoutException catch (e) {
      _errorMessage.value = e.message;
      _status.value = ProductStatus.error;
    } on ServerException catch (e) {
      _errorMessage.value = e.message;
      _status.value = ProductStatus.error;
    } on ParseException catch (e) {
      _errorMessage.value = e.message;
      _status.value = ProductStatus.error;
    } on ApiException catch (e) {
      _errorMessage.value = e.message;
      _status.value = ProductStatus.error;
    } catch (e) {
      _errorMessage.value = 'Something went wrong. Please try again.';
      _status.value = ProductStatus.error;
    }
  }

  // Search & Filter
  void search(String query) {
    _searchQuery.value = query;
    _applyFilters();
  }

  void filterByCategory(String category) {
    _selectedCategory.value = category;
    _applyFilters();
  }

  void _applyFilters() {
    var result = [..._products];

    if (_selectedCategory.value != 'all') {
      result =
          result.where((p) => p.category == _selectedCategory.value).toList();
    }

    if (_searchQuery.value.isNotEmpty) {
      final q = _searchQuery.value.toLowerCase();
      result = result
          .where((p) =>
      p.title.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q))
          .toList();
    }

    _filteredProducts.assignAll(result);
  }

  Future<void> retry() => fetchProducts();
}