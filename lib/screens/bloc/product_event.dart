import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_event.freezed.dart';

/// Events avec Freezed
@freezed
class ProductEvent with _$ProductEvent {
  const factory ProductEvent.loadProducts() = LoadProducts;
  const factory ProductEvent.searchProducts(String query) = SearchProducts;
  const factory ProductEvent.resetSearch() = ResetSearch;
}