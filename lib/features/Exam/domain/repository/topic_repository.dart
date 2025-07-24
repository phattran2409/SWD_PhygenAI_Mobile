import '../entities/topic.dart';

abstract class TopicRepository {
  Future<List<Topic>> getTopics();
}
