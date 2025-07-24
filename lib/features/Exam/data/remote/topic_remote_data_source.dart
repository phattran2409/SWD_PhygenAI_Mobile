import 'dart:convert';
import 'package:phygen/core/constants/api_constants.dart';

import '../models/topic_model.dart';
import 'package:phygen/core/services/API_Client.dart';

abstract class TopicRemoteDataSource {
  Future<List<TopicModel>> fetchTopics();
}

class TopicRemoteDataSourceImpl implements TopicRemoteDataSource {
  final ApiClient apiClient;
  TopicRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<TopicModel>> fetchTopics() async {
    final response = await apiClient.get(ApiConstants.getTopics);
    if (response != null && response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = data['data']['items']['\$values'] as List;
      return items.map((e) => TopicModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load topics');
    }
  }
}
