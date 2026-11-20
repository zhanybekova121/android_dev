import 'package:android_dev/screens/home_screen/services/dio_service.dart';
import 'package:android_dev/screens/home_screen/services/post_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final postServicesProvider = Provider<PostServices>((ref) => const PostServices());

final dioServiceProvider = Provider<DioService>((ref) => DioService());
