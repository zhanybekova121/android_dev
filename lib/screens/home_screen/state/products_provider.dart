import 'package:android_dev/screens/home_screen/state/services_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsProvider = FutureProvider<List<dynamic>>((ref) async {
  final response = await ref.watch(dioServiceProvider).get('https://dummyjson.com/products', 10);
  return response['products'] as List<dynamic>;
});
