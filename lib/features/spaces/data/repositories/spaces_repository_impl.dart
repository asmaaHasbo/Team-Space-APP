import '../../domain/entities/space.dart';
import '../../domain/repositories/spaces_repository.dart';
import '../datasources/spaces_remote_data_source.dart';

class SpacesRepositoryImpl implements SpacesRepository {
  final SpacesRemoteDataSource _remote;

  SpacesRepositoryImpl(this._remote);

  @override
  Future<List<Space>> getMySpaces() {
    return _remote.getMySpaces();
  }

  @override
  Future<Space> createSpace({required String name}) {
    return _remote.createSpace(name: name);
  }

  @override
  Future<Space> joinByCode({required String inviteCode}) {
    return _remote.joinByCode(inviteCode: inviteCode);
  }
}