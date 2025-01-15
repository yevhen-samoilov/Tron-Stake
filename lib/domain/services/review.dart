import 'package:in_app_review/in_app_review.dart';
import 'dart:developer';

final InAppReview inAppReview = InAppReview.instance;

Future<void> review() async {
  try {
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    }
  } catch (e) {
    log('Ошибка при запросе отзыва: $e');
  }
}
