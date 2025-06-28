import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:phygen/core/services/API_Client.dart';
import 'package:phygen/core/constants/api_constants.dart';
import 'package:phygen/features/Exam/data/models/file_upload_model.dart';

abstract class UploadRemoteDataSource {
    Future<UploadResponseModel> uploadFile(File file);
}

class UploadRemoteDataSourceImpl implements UploadRemoteDataSource {
    final ApiClient apiClient;

    UploadRemoteDataSourceImpl({required this.apiClient});

    @override
    Future<UploadResponseModel> uploadFile(File file) async {
        try {
            print('Starting file upload...');
            
            // Create form data
            var request = http.MultipartRequest(
                'POST',
                Uri.parse(ApiConstants.processImageEndpoint),
            );

            // Add file to request
            var fileStream = await http.MultipartFile.fromPath(
                'file',
                file.path,
                filename: file.path.split('/').last
            );
            request.files.add(fileStream);

            print('Sending request to ${request.url}');
            
            // Send request through ApiClient
            final streamedResponse = await apiClient.sendMultipartRequest(request);
            final response = await http.Response.fromStream(streamedResponse);

            print('Response status: ${response.statusCode}');
            print('Response body: ${response.body}');

            if (response.statusCode == 200) {
                // Thử parse response body
                try {
                    // Nếu response là JSON object
                    final responseData = jsonDecode(response.body);
                    print('Parsed response data: $responseData');
                    
                    if (responseData['isSuccess'] == true) {
                        return UploadResponseModel.fromJson(responseData);
                    } else {
                        throw Exception(responseData['message'] ?? 'Upload failed');
                    }
                } catch (e) {
                    print('Error parsing response: $e');
                    // Nếu response là plain text
                    throw Exception('Invalid response format');
                }
            } else {
                throw Exception('Failed to upload file: ${response.statusCode}');
            }
        } catch (e) {
            print('Error in uploadFile: $e');
            throw _handleFileUploadException(e);
        }
    }

    Exception _handleFileUploadException(dynamic e) {
        if (e is Exception) {
            if (e.toString().contains('file-too-large')) {
                return Exception('File is too large.');
            }
        }
        return Exception('An unknown error occurred: ${e.toString()}');
    }
}