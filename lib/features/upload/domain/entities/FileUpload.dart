class FileUpload {
  final String id;
  final String fileName;
  final String filePath;
  final int size; 
  final DateTime? uploadDate;

  FileUpload({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.size,
     this.uploadDate,
  });
  }
