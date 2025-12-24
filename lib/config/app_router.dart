import 'package:chat_vocab/screens/home_screen/home_screen.dart';
import 'package:chat_vocab/screens/home_screen/tabs/tab_import.dart';
import 'package:chat_vocab/screens/practice_screen/practice_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomeScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => HomeTab(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/words',
              name: 'words',
              builder: (context, state) => WordListTab(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => ProfileTab(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/setting',
              name: 'setting',
              builder: (context, state) => SettingsTab(),
            ),
          ],
        ),
      ],
    ),

    // Full screen route
    GoRoute(
      path: '/practice',
      name: 'practice',
      builder: (context, state) => PracticeScreen(),
    ),
  ],
);
