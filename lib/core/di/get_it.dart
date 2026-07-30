import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/login.dart';
import '../../features/auth/domain/usecases/logout.dart';
import '../../features/auth/domain/usecases/register.dart';
import '../../features/auth/domain/usecases/watch_auth_state.dart';
import '../../features/auth/presentation/cubit/auth/auth_cubit.dart';
import '../../features/auth/presentation/cubit/login/login_cubit.dart';
import '../../features/auth/presentation/cubit/register/register_cubit.dart';

final getIt = GetIt.instance;

/// بتتنادى مرة واحدة في الـ main بعد `Supabase.initialize`
Future<void> setupGetIt() async {
  //==================== external ====================
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  //==================== auth ====================
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );

  // use cases
  getIt.registerLazySingleton<Login>(() => Login(getIt()));
  getIt.registerLazySingleton<Register>(() => Register(getIt()));
  getIt.registerLazySingleton<Logout>(() => Logout(getIt()));
  getIt.registerLazySingleton<GetCurrentUser>(() => GetCurrentUser(getIt()));
  getIt.registerLazySingleton<WatchAuthState>(() => WatchAuthState(getIt()));

  // cubits
  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(
      getCurrentUser: getIt(),
      logout: getIt(),
      watchAuthState: getIt(),
    ),
  );
  getIt.registerFactory<LoginCubit>(() => LoginCubit(login: getIt()));
  getIt.registerFactory<RegisterCubit>(() => RegisterCubit(register: getIt()));
}
