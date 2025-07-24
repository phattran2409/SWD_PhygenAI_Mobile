import 'package:flutter/foundation.dart';

class ExamSetModel {
  final String id;
  final String title;
  final int classId;
  final String description;
  final String createdBy;
  final DateTime createdAt;
  final String status;

  ExamSetModel({
    required this.id,
    required this.title,
    required this.classId,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    required this.status,
  });

  factory ExamSetModel.fromJson(Map<String, dynamic> json) {
    return ExamSetModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      classId: json['classId'] ?? 0,
      description: json['description'] ?? '',
      createdBy: json['createdBy'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime(1970),
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'classId': classId,
      'description': description,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }
}

class ExamSetResponseModel {
  final String id;
  final bool isSuccess;
  final String message;
  final List<ExamSetModel> data;

  ExamSetResponseModel({
    required this.id,
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ExamSetResponseModel.fromJson(Map<String, dynamic> json) {
    List<ExamSetModel> sets = [];
    try {
      if (json['data'] != null) {
        if (json['data'] is Map && json['data']['\$values'] != null) {
          final setsJson = json['data']['\$values'] as List;
          sets = setsJson.map((e) => ExamSetModel.fromJson(e as Map<String, dynamic>)).toList();
        } else if (json['data'] is List) {
          final setsJson = json['data'] as List;
          sets = setsJson.map((e) => ExamSetModel.fromJson(e as Map<String, dynamic>)).toList();
        }
      }
    } catch (e) {
      debugPrint('❌ Error parsing exam sets: $e');
    }
    return ExamSetResponseModel(
      id: json['\$id']?.toString() ?? json['id']?.toString() ?? '',
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'] ?? '',
      data: sets,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isSuccess': isSuccess,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
} 