import 'package:gestanea/core/database/models/product_model.dart';
import 'package:gestanea/core/database/models/product_category_model.dart';
import 'package:gestanea/core/database/models/product_variant_model.dart';
import 'package:gestanea/core/database/models/product_spec_model.dart';
import 'package:gestanea/core/database/models/product_review_model.dart';
import 'package:gestanea/core/database/db_helper.dart';

class MarketplaceLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // PRODUCT CATEGORIES

  /// Get all product categories
  Future<List<ProductCategoryModel>> getCategories() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'product_categories',
      orderBy: 'display_order ASC',
    );
    return result.map((map) => ProductCategoryModel.fromMap(map)).toList();
  }

  /// Get category by ID
  Future<ProductCategoryModel?> getCategoryById(String id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'product_categories',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return ProductCategoryModel.fromMap(result.first);
  }

  /// Insert a new category
  Future<void> insertCategory(ProductCategoryModel category) async {
    final db = await _dbHelper.database;
    await db.insert('product_categories', category.toMap());
  }

  /// Bulk insert categories
  Future<void> insertCategories(List<ProductCategoryModel> categories) async {
    final db = await _dbHelper.database;
    final batch = db.batch();
    for (var category in categories) {
      batch.insert('product_categories', category.toMap());
    }
    await batch.commit(noResult: true);
  }

  /// Update category
  Future<void> updateCategory(ProductCategoryModel category) async {
    final db = await _dbHelper.database;
    await db.update(
      'product_categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  /// Delete category
  Future<void> deleteCategory(String id) async {
    final db = await _dbHelper.database;
    await db.delete('product_categories', where: 'id = ?', whereArgs: [id]);
  }

  // PRODUCTS

  /// Get all products
  Future<List<ProductModel>> getProducts() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'products',
      where: 'is_available = ?',
      whereArgs: [1],
      orderBy: 'created_at DESC',
    );
    return result.map((map) => ProductModel.fromMap(map)).toList();
  }

  /// Get products by category
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'products',
      where: 'category_id = ? AND is_available = ?',
      whereArgs: [categoryId, 1],
      orderBy: 'created_at DESC',
    );
    return result.map((map) => ProductModel.fromMap(map)).toList();
  }

  /// Get product by ID
  Future<ProductModel?> getProductById(String id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return ProductModel.fromMap(result.first);
  }

  /// Insert a new product
  Future<void> insertProduct(ProductModel product) async {
    final db = await _dbHelper.database;
    await db.insert('products', product.toMap());
  }

  /// Bulk insert products
  Future<void> insertProducts(List<ProductModel> products) async {
    final db = await _dbHelper.database;
    final batch = db.batch();
    for (var product in products) {
      batch.insert('products', product.toMap());
    }
    await batch.commit(noResult: true);
  }

  /// Update product
  Future<void> updateProduct(ProductModel product) async {
    final db = await _dbHelper.database;
    await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  /// Delete product
  Future<void> deleteProduct(String id) async {
    final db = await _dbHelper.database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  /// Search products
  Future<List<ProductModel>> searchProducts(String query) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'products',
      where: '(product_name LIKE ? OR description LIKE ?) AND is_available = ?',
      whereArgs: ['%$query%', '%$query%', 1],
      orderBy: 'created_at DESC',
    );
    return result.map((map) => ProductModel.fromMap(map)).toList();
  }

  // PRODUCT VARIANTS

  /// Get variants for a product
  Future<List<ProductVariantModel>> getProductVariants(String productId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'product_variants',
      where: 'product_id = ?',
      whereArgs: [productId],
      orderBy: 'type ASC, value ASC',
    );
    return result.map((map) => ProductVariantModel.fromMap(map)).toList();
  }

  /// Insert product variant
  Future<void> insertProductVariant(ProductVariantModel variant) async {
    final db = await _dbHelper.database;
    await db.insert('product_variants', variant.toMap());
  }

  /// Bulk insert product variants
  Future<void> insertProductVariants(List<ProductVariantModel> variants) async {
    final db = await _dbHelper.database;
    final batch = db.batch();
    for (var variant in variants) {
      batch.insert('product_variants', variant.toMap());
    }
    await batch.commit(noResult: true);
  }

  /// Update product variant
  Future<void> updateProductVariant(ProductVariantModel variant) async {
    final db = await _dbHelper.database;
    await db.update(
      'product_variants',
      variant.toMap(),
      where: 'id = ?',
      whereArgs: [variant.id],
    );
  }

  /// Delete product variant
  Future<void> deleteProductVariant(String id) async {
    final db = await _dbHelper.database;
    await db.delete('product_variants', where: 'id = ?', whereArgs: [id]);
  }

  // PRODUCT SPECS

  /// Get specs for a product
  Future<List<ProductSpecModel>> getProductSpecs(String productId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'product_specs',
      where: 'product_id = ?',
      whereArgs: [productId],
      orderBy: 'name ASC',
    );
    return result.map((map) => ProductSpecModel.fromMap(map)).toList();
  }

  /// Insert product spec
  Future<void> insertProductSpec(ProductSpecModel spec) async {
    final db = await _dbHelper.database;
    await db.insert('product_specs', spec.toMap());
  }

  /// Bulk insert product specs
  Future<void> insertProductSpecs(List<ProductSpecModel> specs) async {
    final db = await _dbHelper.database;
    final batch = db.batch();
    for (var spec in specs) {
      batch.insert('product_specs', spec.toMap());
    }
    await batch.commit(noResult: true);
  }

  /// Update product spec
  Future<void> updateProductSpec(ProductSpecModel spec) async {
    final db = await _dbHelper.database;
    await db.update(
      'product_specs',
      spec.toMap(),
      where: 'id = ?',
      whereArgs: [spec.id],
    );
  }

  /// Delete product spec
  Future<void> deleteProductSpec(String id) async {
    final db = await _dbHelper.database;
    await db.delete('product_specs', where: 'id = ?', whereArgs: [id]);
  }

  // PRODUCT REVIEWS

  /// Get reviews for a product
  Future<List<ProductReviewModel>> getProductReviews(String productId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'product_reviews',
      where: 'product_id = ?',
      whereArgs: [productId],
      orderBy: 'created_at DESC',
    );
    return result.map((map) => ProductReviewModel.fromMap(map)).toList();
  }

  /// Insert product review
  Future<void> insertProductReview(ProductReviewModel review) async {
    final db = await _dbHelper.database;
    await db.insert('product_reviews', review.toMap());
  }

  /// Bulk insert product reviews
  Future<void> insertProductReviews(List<ProductReviewModel> reviews) async {
    final db = await _dbHelper.database;
    final batch = db.batch();
    for (var review in reviews) {
      batch.insert('product_reviews', review.toMap());
    }
    await batch.commit(noResult: true);
  }

  /// Update product review
  Future<void> updateProductReview(ProductReviewModel review) async {
    final db = await _dbHelper.database;
    await db.update(
      'product_reviews',
      review.toMap(),
      where: 'id = ?',
      whereArgs: [review.id],
    );
  }

  /// Delete product review
  Future<void> deleteProductReview(String id) async {
    final db = await _dbHelper.database;
    await db.delete('product_reviews', where: 'id = ?', whereArgs: [id]);
  }

  // UTILITY METHODS

  /// Check if database has categories
  Future<bool> hasCategories() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM product_categories',
    );
    final count = result.first['count'] as int;
    return count > 0;
  }

  /// Check if database has products
  Future<bool> hasProducts() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM products');
    final count = result.first['count'] as int;
    return count > 0;
  }

  /// Clear all marketplace data
  Future<void> clearAllMarketplaceData() async {
    final db = await _dbHelper.database;
    await db.delete('product_reviews');
    await db.delete('product_specs');
    await db.delete('product_variants');
    await db.delete('products');
    await db.delete('product_categories');
  }
}
