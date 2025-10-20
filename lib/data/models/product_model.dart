import 'package:freezed_annotation/freezed_annotation.dart';

// Fichiers générés
part 'product_model.freezed.dart';
part 'product_model.g.dart';

/// Modèle Product avec Freezed et JsonSerializable
@freezed
class Product with _$Product {
  const factory Product({
    required int id,
    required String title,
    required double price,
    required String description,
    required String category,
    required String image,
    required Rating rating,
  }) = _Product;

  /// Désérialisation depuis JSON
  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

/// Sous-modèle Rating
@freezed
class Rating with _$Rating {
  const factory Rating({
    required double rate,
    required int count,
  }) = _Rating;

  /// Désérialisation depuis JSON
  factory Rating.fromJson(Map<String, dynamic> json) =>
      _$RatingFromJson(json);
}