import 'package:ayur_scoliosis_management/core/utils/api.dart';
import 'package:ayur_scoliosis_management/providers/dio/dio.dart';
import 'package:ayur_scoliosis_management/services/event/event_service_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../services/event/event_service.dart';

part 'event_service.g.dart';

@riverpod
EventService eventService(Ref ref) {
  final dio = ref.watch(dioProvider);
  return EventServiceImpl(client: dio, api: Api());
}
