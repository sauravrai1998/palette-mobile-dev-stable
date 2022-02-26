import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? status;
  final String authorId;
  final DateTime? dateTime;
  Map<String, dynamic>? groupStatus;
  final String type;
  final String? text;

  MessageModel({
    required this.status,
    required this.authorId,
    required this.dateTime,
    required this.type,
    this.text,
    this.groupStatus,
  });

  factory MessageModel.fromJson({required Map<String, dynamic> json}) {
    final Timestamp? time = json['timestamp'];
    DateTime? date;
    if (time != null) {
      date = DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch);
    }

    return MessageModel(
      status: json['status'],
      authorId: json['authorId']!,
      dateTime: date,
      groupStatus: json['groupStatus'],
      text: json['text'],
      type: json['type'],
    );
  }
}
