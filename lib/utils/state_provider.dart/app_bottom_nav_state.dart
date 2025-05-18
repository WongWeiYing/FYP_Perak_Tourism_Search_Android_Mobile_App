import 'package:hooks_riverpod/hooks_riverpod.dart';

class BottomNavigation {
  int? selectedIndex;

  int get getSelectedIndex => selectedIndex ?? 0;

  BottomNavigation({
    this.selectedIndex,
  });

  BottomNavigation copyWith({
    int? selectedIndex,
  }) {
    return BottomNavigation(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

final bottomNavigationProvider =
    StateNotifierProvider<BottomNavigationState, BottomNavigation>((ref) {
  return BottomNavigationState();
});

class BottomNavigationState extends StateNotifier<BottomNavigation> {
  BottomNavigationState()
      : super(BottomNavigation(
          selectedIndex: 0,
        ));

  void setSelectedIndex(int selectedIndex) {
    state = state.copyWith(selectedIndex: selectedIndex);
  }
}
