import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_space/core/helper/app_preferences.dart';
import 'package:team_space/core/language/app_locales.dart';
import 'package:team_space/features/home/presentation/ui/widgets/space_action_dialog.dart';
import 'package:team_space/features/spaces/domain/entities/space.dart';
import 'package:team_space/features/spaces/domain/repositories/spaces_repository.dart';
import 'package:team_space/features/spaces/domain/usecases/create_space.dart';
import 'package:team_space/features/spaces/domain/usecases/get_my_spaces.dart';
import 'package:team_space/features/spaces/domain/usecases/join_by_code.dart';
import 'package:team_space/features/spaces/presentation/cubit/spaces_cubit.dart';
import 'package:team_space/features/spaces/presentation/ui/widgets/invite_dialog.dart';

const _oldSpace = Space(
  id: 'space-old',
  name: 'مساحة قديمة',
  inviteCode: 'aaaa1111',
);

const _createdSpace = Space(
  id: 'space-new',
  name: 'فريق التصميم',
  inviteCode: '733c1abf',
);

class _FakeSpacesRepository implements SpacesRepository {
  @override
  Future<Space> createSpace({required String name}) async => _createdSpace;

  @override
  Future<Space> joinByCode({required String inviteCode}) async => _createdSpace;

  // the newly created space is not first on purpose: picking it must come
  // from the saved selection, never from the list order.
  @override
  Future<List<Space>> getMySpaces() async => [_oldSpace, _createdSpace];
}

void main() {
  late SpacesCubit cubit;

  setUp(() async {
    // the user is currently sitting inside the old space
    SharedPreferences.setMockInitialValues({'selected_space_id': _oldSpace.id});
    final repository = _FakeSpacesRepository();
    cubit = SpacesCubit(
      getMySpaces: GetMySpaces(repository),
      createSpace: CreateSpace(repository),
      joinByCode: JoinByCode(repository),
      prefs: AppPreferences(await SharedPreferences.getInstance()),
    );
  });

  tearDown(() => cubit.close());

  Widget testApp() {
    return EasyLocalization(
      supportedLocales: AppLocales.supported,
      path: AppLocales.path,
      fallbackLocale: AppLocales.fallback,
      startLocale: AppLocales.arabic,
      child: Builder(
        builder: (context) => ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (_, _) => BlocProvider<SpacesCubit>.value(
            value: cubit,
            child: MaterialApp(
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              home: Builder(
                builder: (innerContext) => Scaffold(
                  body: Center(
                    child: ElevatedButton(
                      onPressed: () => SpaceActionDialog.show(
                        innerContext,
                        SpaceDialogMode.create,
                      ),
                      child: const Text('open-create-dialog'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('creating a space closes its dialog and opens the invite dialog',
      (tester) async {
    // a phone-sized surface, otherwise ScreenUtil scales against 800x600
    tester.view.physicalSize = const Size(1125, 2436);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await EasyLocalization.ensureInitialized();

    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('open-create-dialog'));
    await tester.pumpAndSettle();
    expect(find.byType(SpaceActionDialog), findsOneWidget);

    await tester.enterText(find.byType(TextField), _createdSpace.name);
    await tester.tap(find.text(tr('spaces.create.confirm')));
    await tester.pumpAndSettle();

    // the create dialog is gone and the invite one took its place
    expect(find.byType(SpaceActionDialog), findsNothing);
    expect(find.byType(InviteDialog), findsOneWidget);

    // and it shows the code of the space that was just created
    expect(find.text(_createdSpace.inviteCode), findsOneWidget);
    expect(find.text(tr('spaces.invite.title')), findsOneWidget);
  });

  test('a created space becomes the selected one', () async {
    await cubit.createSpace(_createdSpace.name);

    final state = cubit.state;
    expect(state, isA<SpacesLoaded>());
    expect((state as SpacesLoaded).selectedSpace, _createdSpace);
  });

  test('a joined space becomes the selected one', () async {
    await cubit.joinByCode(_createdSpace.inviteCode);

    final state = cubit.state;
    expect(state, isA<SpacesLoaded>());
    expect((state as SpacesLoaded).selectedSpace, _createdSpace);
  });
}
