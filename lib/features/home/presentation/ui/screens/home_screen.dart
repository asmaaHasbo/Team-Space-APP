import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_space/features/home/presentation/ui/screens/no_space_screen.dart';
import 'package:team_space/features/home/presentation/ui/widgets/home_error_view.dart';
import 'package:team_space/features/home/presentation/ui/widgets/home_space_shell.dart';
import 'package:team_space/features/spaces/presentation/cubit/spaces_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SpacesCubit>().getMySpaces();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpacesCubit, SpacesState>(
      // Create / join action states are handled by listeners; they must not
      // tear down the shell while the user is working inside it.
      buildWhen: (previous, current) =>
          current is SpacesInitial ||
          current is SpacesLoading ||
          current is SpacesLoaded ||
          current is SpacesEmpty ||
          current is SpacesError,
      builder: (context, state) => switch (state) {
        SpacesLoaded() => const HomeSpaceShell(),
        SpacesEmpty() => const NoSpaceScreen(),
        SpacesError(:final message) => HomeErrorView(message: message),
        _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
      },
    );
  }
}
