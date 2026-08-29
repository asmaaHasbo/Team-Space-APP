import 'package:team_space/features/chat/domain/repositories/chat_repository.dart';

import '../entities/space_member.dart';

class GetSpaceMembers {
  final ChatRepository repository;
  GetSpaceMembers(this.repository);

  Future<List<SpaceMember>> call({required String spaceId}) {
    return repository.getSpaceMembers(spaceId: spaceId);
  }
}
