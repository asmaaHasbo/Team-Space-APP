import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:team_space/features/home/presentation/ui/widgets/space_switcher_button.dart';
import 'package:team_space/features/home/presentation/ui/widgets/tabs/chats_tab.dart';
import 'package:team_space/features/home/presentation/ui/widgets/tabs/profile_tab.dart';
import 'package:team_space/features/home/presentation/ui/widgets/tabs/storage_tab.dart';
import 'package:team_space/features/home/presentation/ui/widgets/tabs/tasks_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const SpaceSwitcherButton()),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          ChatsTab(),
          TasksTab(),
          StorageTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: const Icon(Icons.chat_bubble_rounded),
            label: context.tr('tabs.chats'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.assignment_outlined),
            selectedIcon: const Icon(Icons.assignment_rounded),
            label: context.tr('tabs.tasks'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.folder_outlined),
            selectedIcon: const Icon(Icons.folder_rounded),
            label: context.tr('tabs.storage'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: const Icon(Icons.person_rounded),
            label: context.tr('tabs.profile'),
          ),
        ],
      ),
    );
  }
}
