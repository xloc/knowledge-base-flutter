import 'package:get_it/get_it.dart';
import 'package:knowledge_base_flutter/src/models.dart';

final getIt = GetIt.instance;

void initGetIt() {
  getIt.registerSingletonAsync<KnowledgeBase>(
      () => KnowledgeBase.load('assets/storage.yaml'));
}
