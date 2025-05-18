import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_perak/screens/chat_list_page.dart';
import 'package:go_perak/screens/user/home_page.dart';
import 'package:go_perak/screens/user/profile_page.dart';
import 'package:go_perak/screens/user/savelist_page.dart';
import 'package:go_perak/utils/state_provider.dart/app_bottom_nav_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DashboardPage extends HookConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(bottomNavigationProvider);
    final _pageController = usePageController(initialPage: 0);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pageController.jumpToPage(navState.selectedIndex ?? 0);
      });

      return null;
    }, [navState]);

    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: const [
        HomePage(),
        SavelistPage(),
        ChatListPage(
          showBottom: true,
        ),
        ProfilePage(),
      ],
    );
  }
}
