import 'package:flutter_bloc/flutter_bloc.dart';

/// A cubit whose screen can be popped while a request is still on its way:
/// the reply lands after `close()`, and `emit` throws on a closed cubit.
///
/// Anything emitted after the close is dropped instead — the screen that
/// asked for it is gone, so there is nothing left to show it.
abstract class SafeCubit<State> extends Cubit<State> {
  SafeCubit(super.initialState);

  @override
  void emit(State state) {
    if (isClosed) return;
    super.emit(state);
  }
}
