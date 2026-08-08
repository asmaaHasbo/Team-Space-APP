import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/handle_errors.dart';
import '../models/space_model.dart';

abstract interface class SpacesRemoteDataSource {
  Future<List<SpaceModel>> getMySpaces();

  Future<SpaceModel> createSpace({required String name});

  Future<SpaceModel> joinByCode({required String inviteCode});
}

class SpacesRemoteDataSourceImpl implements SpacesRemoteDataSource {
  final SupabaseClient _client;

  SpacesRemoteDataSourceImpl(this._client);

  @override
  Future<List<SpaceModel>> getMySpaces() async {
    try {
      // RLS ("members can view their spaces") filters this to only the
      // spaces the current user belongs to — no where-clause needed here.
      final rows = await _client.from('spaces').select();
      return rows.map((json) => SpaceModel.fromJson(json)).toList();
    } catch (e) {
      return handleError(e);
    }
  }

  @override
  Future<SpaceModel> createSpace({required String name}) async {
    try {
      // One round-trip: the Postgres function does both inserts
      // (space + owner membership) atomically and returns the new space.
      final row = await _client.rpc(
        'create_space_with_owner',
        params: {'space_name': name},
      );
      return SpaceModel.fromJson(row);
    } catch (e) {
      return handleError(e);
    }
  }
Future<SpaceModel> joinByCode({required String inviteCode}) async {
  final Map<String, dynamic>? spaceRow;

  try {
    spaceRow = await _client.rpc(
      'join_space_by_code',
      params: {'p_invite_code': inviteCode},
    );
  } catch (e) {
    return handleError(e);
  }

  if (spaceRow == null) {
    throw AuthFailureException('Invalid invite code');
  }

  return SpaceModel.fromJson(spaceRow);
}


}
