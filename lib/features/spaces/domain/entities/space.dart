import 'package:equatable/equatable.dart';

class Space extends Equatable {
  final String id;
  final String name;
  final String inviteCode;

  const Space({
    required this.id,
    required this.name,
    required this.inviteCode,
  });

  @override
  List<Object?> get props => [id, name, inviteCode];
}