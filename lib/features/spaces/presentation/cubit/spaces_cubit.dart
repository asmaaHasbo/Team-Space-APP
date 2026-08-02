import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/space.dart';
import '../../domain/usecases/get_my_spaces.dart';
import '../../domain/usecases/create_space.dart';
import '../../domain/usecases/join_by_code.dart';
import '../../../../core/error/handle_errors.dart';

part 'spaces_state.dart';

class SpacesCubit extends Cubit<SpacesState> {
  final GetMySpaces _getMySpaces;
  final CreateSpace _createSpace;
  final JoinByCode _joinByCode;

  SpacesCubit({
    required GetMySpaces getMySpaces,
    required CreateSpace createSpace,
    required JoinByCode joinByCode,
  }) : _getMySpaces = getMySpaces,
       _createSpace = createSpace,
       _joinByCode = joinByCode,
       super(const SpacesInitial());

  // the durable list — survives action-state changes
  List<Space> _spaces = [];
  Space? _selectedSpace;

  Future<void> getMySpaces() async {
    emit(const SpacesLoading());
    try {
      _spaces = await _getMySpaces();

      if (_spaces.isEmpty) {
        _selectedSpace = null;
        emit(const SpacesEmpty());
        return;
      }

      _selectedSpace ??= _spaces.first;
      emit(SpacesLoaded(_spaces, _selectedSpace!));
    } on AppException catch (e) {
      emit(SpacesError(e.message));
    }
  }

  Future<void> createSpace(String name) async {
    emit(const CreateSpaceLoading());
    try {
      await _createSpace(name: name);
      emit(const CreateSpaceSuccess());
      await getMySpaces(); // refresh the list from the server
    } on AppException catch (e) {
      emit(CreateSpaceError(e.message));
    }
  }

  Future<void> joinByCode(String inviteCode) async {
    emit(const JoinSpaceLoading());
    try {
      await _joinByCode(inviteCode: inviteCode);
      emit(const JoinSpaceSuccess());
      await getMySpaces(); // refresh the list from the server
    } on AppException catch (e) {
      emit(JoinSpaceError(e.message));
    }
  }
}
