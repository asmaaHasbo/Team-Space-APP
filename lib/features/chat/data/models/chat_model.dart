import '../../domain/entities/chat.dart';

class ChatModel extends Chat {
  const ChatModel({
    required super.id,
    required super.type,
    super.name,
    super.isDefault = false,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as String,
      type: ChatType.values.byName(json['type'] as String),
      name: json['name'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
    );
  }
}