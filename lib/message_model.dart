// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MessageModel {
  final String text;
  final String senderid;
  MessageModel({
    required this.text,
    required this.senderid,
  });

  MessageModel copyWith({
    String? text,
    String? senderid,
  }) {
    return MessageModel(
      text: text ?? this.text,
      senderid: senderid ?? this.senderid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'senderid': senderid,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      text: map['text'] as String,
      senderid: map['senderid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MessageModel(text: $text, senderid: $senderid)';

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;

    return other.text == text && other.senderid == senderid;
  }

  @override
  int get hashCode => text.hashCode ^ senderid.hashCode;
}
