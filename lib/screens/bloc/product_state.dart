import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/product_model.dart';

part 'product_state.freezed.dart';

/// States avec Freezed
@freezed
class ProductState with _$ProductState {
  const factory ProductState.initial() = ProductInitial;
  const factory ProductState.loading() = ProductLoading;
  const factory ProductState.loaded({
    required List<Product> products,
    @Default(false) bool isSearching,
  }) = ProductLoaded;
  const factory ProductState.error(String message) = ProductError;
}