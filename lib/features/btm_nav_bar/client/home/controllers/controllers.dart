import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/features/user%20setup/repository/user_data_repository.dart';
import 'package:home_quest/models/review.dart';

final updateReviewsProvider = FutureProvider.family<void, (Review, String)>((ref, args) async {
  return await ref.watch(userDataRepoProvider).updateReviews(args.$1, args.$2);
});