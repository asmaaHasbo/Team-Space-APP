import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_space/core/helper/app_preferences.dart';
import 'package:team_space/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:team_space/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:team_space/features/chat/domain/repositories/chat_repository.dart';
import 'package:team_space/features/chat/domain/usecases/get_my_chats.dart';
import 'package:team_space/features/chat/presentation/cubit/chats_cubit.dart';
import 'package:team_space/features/spaces/data/datasources/spaces_remote_data_source.dart';
import 'package:team_space/features/spaces/data/repositories/spaces_repository_impl.dart';
import 'package:team_space/features/spaces/domain/repositories/spaces_repository.dart';
import 'package:team_space/features/spaces/domain/usecases/create_space.dart';
import 'package:team_space/features/spaces/domain/usecases/get_my_spaces.dart';
import 'package:team_space/features/spaces/domain/usecases/join_by_code.dart';
import 'package:team_space/features/spaces/presentation/cubit/spaces_cubit.dart';

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
  
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => AppPreferences(prefs));
 
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

  //-------------------------------- spaces -------------------

  // data source
  getIt.registerLazySingleton<SpacesRemoteDataSource>(
    () => SpacesRemoteDataSourceImpl(getIt<SupabaseClient>()),
  );

  // repository
  getIt.registerLazySingleton<SpacesRepository>(
    () => SpacesRepositoryImpl(getIt<SpacesRemoteDataSource>()),
  );

  // usecases
  getIt.registerLazySingleton(() => GetMySpaces(getIt<SpacesRepository>()));
  getIt.registerLazySingleton(() => CreateSpace(getIt<SpacesRepository>()));
  getIt.registerLazySingleton(() => JoinByCode(getIt<SpacesRepository>()));

  // cubit
  getIt.registerLazySingleton(
    () => SpacesCubit(
      getMySpaces: getIt<GetMySpaces>(),
      createSpace: getIt<CreateSpace>(),
      joinByCode: getIt<JoinByCode>(),
      prefs: getIt<AppPreferences>(),
    ),
  );

  //==================== chats ====================
  //data source
  getIt.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(getIt<SupabaseClient>()),
  );

  // repository
  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(getIt<ChatRemoteDataSource>()),
  );

  // usecases
  getIt.registerLazySingleton(() => GetMyChats(getIt<ChatRepository>()));
  

  // cubit
  getIt.registerFactory<ChatsCubit>(
    () => ChatsCubit(getMyChats: getIt<GetMyChats>()),
  );
}
