import '../entities/space.dart';
import '../repositories/spaces_repository.dart';

class JoinByCode {
  final SpacesRepository repository;

  JoinByCode(this.repository);

  Future<Space> call({required String inviteCode}) {
    return repository.joinByCode(inviteCode: inviteCode);
  }
}