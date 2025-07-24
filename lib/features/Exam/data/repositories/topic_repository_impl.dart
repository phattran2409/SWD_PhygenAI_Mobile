import '../../domain/entities/topic.dart';
import '../../domain/repository/topic_repository.dart';
import '../models/topic_model.dart';
import '../remote/topic_remote_data_source.dart';

class TopicRepositoryImpl implements TopicRepository {
  final TopicRemoteDataSource remoteDataSource;
  TopicRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Topic>> getTopics() async {
    final topicModels = await remoteDataSource.fetchTopics();
    return topicModels
        .map(
          (model) => Topic(
            id: model.id,
            chapterId: model.chapterId,
            topicName: model.topicName,
          ),
        )
        .toList();
  }
}
