import 'package:equatable/equatable.dart';

enum ChatType { group, direct }

class Chat extends Equatable {
  final String id;
  final ChatType type;
  final String? name;
  final bool isDefault;

  const Chat({
    required this.id,
    required this.type,
    this.name,
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [id, type, name, isDefault];
}