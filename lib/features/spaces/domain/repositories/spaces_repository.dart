import '../entities/space.dart';

abstract class SpacesRepository {
  Future<List<Space>> getMySpaces();

  Future<Space> createSpace({required String name});

  Future<Space> joinByCode({required String inviteCode});
}