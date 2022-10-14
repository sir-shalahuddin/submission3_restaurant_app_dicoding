import 'package:submission3_restaurant_app/data/model/customer_review.dart';

class PostReviewResult {
  bool error;
  String message;
  List<CustomerReview> customerReviews;

  PostReviewResult(
      {required this.error,
      required this.message,
      required this.customerReviews});

  factory PostReviewResult.fromJson(Map<String, dynamic> json) =>
      PostReviewResult(
        error: json["error"],
        message: json["message"],
        customerReviews: List<CustomerReview>.from(
            (json["customerReviews"]).map((x) => CustomerReview.fromJson(x))),
      );
}
