import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/models/meta.dart';

class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  // final double rating;
  int stock;
  // final List<String> tags;
  // final String brand;
  // final String sku;
  // final int weight;
  // final Dimensions dimensions;
  // final String warrantyInformation;
  // final String shippingInformation;
  // final String availabilityStatus;
  // final List<Review> reviews;
  // final String returnPolicy;
  // final int minimumOrderQuantity;
  final Meta meta;
  // final List<String> images;
  final String thumbnail;

  // Constructor
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    // required this.rating,
    required this.stock,
    // required this.tags,
    // required this.brand,
    // required this.sku,
    // required this.weight,
    // required this.dimensions,
    // required this.warrantyInformation,
    // required this.shippingInformation,
    // required this.availabilityStatus,
    // required this.reviews,
    // required this.returnPolicy,
    // required this.minimumOrderQuantity,
    required this.meta,
    // required this.images,
    required this.thumbnail,
  });

  // Factory method for creating an instance from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      price: (json['price']).toDouble(),
      discountPercentage: (json['discountPercentage']).toDouble(),
      // rating: json['rating'],
      stock: json['stock'],
      // tags: List<String>.from(json['tags']),
      // brand: json['brand'],
      // sku: json['sku'],
      // weight: json['weight'],
      // dimensions: Dimensions.fromJson(json['dimensions']),
      // warrantyInformation: json['warrantyInformation'],
      // shippingInformation: json['shippingInformation'],
      // availabilityStatus: json['availabilityStatus'],
      // reviews:
      //     (json['reviews'] as List).map((e) => Review.fromJson(e)).toList(),
      // returnPolicy: json['returnPolicy'],
      // minimumOrderQuantity: json['minimumOrderQuantity'],
      meta: Meta.fromJson(json['meta']),
      // images: List<String>.from(json['images']),
      thumbnail: json['thumbnail'],
    );
  }

  // Factory method for creating an instance from Firestore DocumentSnapshot
  static Product fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Product(
      id: snapshot['id'],
      title: snapshot['title'],
      description: snapshot['description'],
      category: snapshot['category'],
      price: snapshot['price'],
      discountPercentage: snapshot['discountPercentage'],
      // rating: snapshot['rating'],
      stock: snapshot['stock'],
      // tags: List<String>.from(snapshot['tags']),
      // brand: snapshot['brand'],
      // sku: snapshot['sku'],
      // weight: snapshot['weight'],
      // dimensions: Dimensions.fromJson(snapshot['dimensions']),
      // warrantyInformation: snapshot['warrantyInformation'],
      // shippingInformation: snapshot['shippingInformation'],
      // availabilityStatus: snapshot['availabilityStatus'],
      // reviews:
      //     (snapshot['reviews'] as List).map((e) => Review.fromJson(e)).toList(),
      // returnPolicy: snapshot['returnPolicy'],
      // minimumOrderQuantity: snapshot['minimumOrderQuantity'],
      meta: Meta.fromJson(snapshot['meta']),
      // images: List<String>.from(snapshot['images']),
      thumbnail: snapshot['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        // 'price': price,
        'discountPercentage': discountPercentage,
        // 'rating': rating,
        'stock': stock,
        // 'tags': tags,
        // 'brand': brand,
        // 'sku': sku,
        // 'weight': weight,
        // 'dimensions': dimensions.toJson(),
        // 'warrantyInformation': warrantyInformation,
        // 'shippingInformation': shippingInformation,
        // 'availabilityStatus': availabilityStatus,
        // 'reviews': reviews.map((e) => e.toJson()).toList(),
        // 'returnPolicy': returnPolicy,
        // 'minimumOrderQuantity': minimumOrderQuantity,
        // 'meta': meta.toJson(),
        // 'images': images,
        // 'thumbnail': thumbnail,
      };
}

class Dimensions {
  final double width;
  final double height;
  final double depth;

  Dimensions({
    required this.width,
    required this.height,
    required this.depth,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      width: json['width'],
      height: json['height'],
      depth: json['depth'],
    );
  }

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        'depth': depth,
      };
}

class Review {
  final double rating;
  final String comment;
  final DateTime date;
  final String reviewerName;
  final String reviewerEmail;

  Review({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: json['rating'],
      comment: json['comment'],
      date: DateTime.parse(json['date']),
      reviewerName: json['reviewerName'],
      reviewerEmail: json['reviewerEmail'],
    );
  }

  Map<String, dynamic> toJson() => {
        'rating': rating,
        'comment': comment,
        'date': date.toIso8601String(),
        'reviewerName': reviewerName,
        'reviewerEmail': reviewerEmail,
      };
}
