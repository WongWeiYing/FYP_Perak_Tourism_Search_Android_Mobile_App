import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_perak/data/merchant_data.dart';
import 'package:go_perak/data/user_data.dart';
import 'package:go_perak/data/users_role_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentUserProvider =
    StateNotifierProvider<CurrentUserState, CurrentUserData>((ref) {
  return CurrentUserState();
});

class CurrentUserState extends StateNotifier<CurrentUserData> {
  CurrentUserState() : super(CurrentUserData());

  void setRole(String role) {
    state = state.copyWith(role: role);
  }

  void setUserID(String userID) {
    state = state.copyWith(userID: userID);
  }

  void setFcmToken(String? fcmToken) {
    state = state.copyWith(fcmToken: fcmToken);
  }
}

final userDetailsProvider = FutureProvider<UserData>((ref) async {
  final currentUser = ref.watch(currentUserProvider);
  final snapshot = await FirebaseFirestore.instance
      .collection('Users')
      .doc(currentUser.userID)
      .get();

  print(snapshot.data());

  return UserData.fromJson(snapshot.data()!, currentUser.userID);
});

final merchantDetailsProvider = FutureProvider<MerchantData>((ref) async {
  final currentUser = ref.watch(currentUserProvider);

  print('Current user id ${currentUser.userID}');
  final snapshot = await FirebaseFirestore.instance
      .collection('Merchants')
      .doc(currentUser.userID)
      .get();

  return MerchantData.fromJson(snapshot.data()!, currentUser.userID);
});

final profilePicUploadingProvider = StateProvider<bool>((ref) => false);

final uploadingProvider = StateProvider<bool>((ref) => false);
