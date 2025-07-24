class TopicModel {
  final int id;
  final int chapterId;
  final String topicName;

  TopicModel({
    required this.id,
    required this.chapterId,
    required this.topicName,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'],
      chapterId: json['chapterId'],
      topicName: json['topicName'],
    );
  }
}
