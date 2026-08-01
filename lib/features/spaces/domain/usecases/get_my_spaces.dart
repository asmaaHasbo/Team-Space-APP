import '../entities/space.dart';
import '../repositories/spaces_repository.dart';

class GetMySpaces {
  final SpacesRepository repository;

  GetMySpaces(this.repository);

  Future<List<Space>> call() {
    return repository.getMySpaces();
  }
}