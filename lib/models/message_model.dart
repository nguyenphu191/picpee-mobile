class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;      
  final DateTime timestamp;
  final bool isImage;     
  bool isRead;            
  String? fileName;        

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.isImage = false,
    this.isRead = false,
    this.fileName,
  });

  String get displayName {
    if (isImage) {
      return fileName ?? 'Image ${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
    return content;
  }
}
