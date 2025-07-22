import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;
import 'package:moneynest/core/services/image_service/image_service.dart';

final imageServiceProvider = Provider<ImageService>((ref) {
  return ImageService();
});
