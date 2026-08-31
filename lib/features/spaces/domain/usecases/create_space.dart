import '../entities/space.dart';
import '../repositories/spaces_repository.dart';

class CreateSpace {
  final SpacesRepository repository;

  CreateSpace(this.repository);

  Future<Space> call({required String name}) {
    return repository.createSpace(name: name);
  }
}