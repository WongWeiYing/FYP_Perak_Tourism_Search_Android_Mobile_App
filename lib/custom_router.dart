import 'package:flutter/material.dart';
import 'package:go_perak/screens/chat_list_page.dart';
import 'package:go_perak/screens/chat_room_page.dart';
import 'package:go_perak/screens/dashboard_page.dart';
import 'package:go_perak/screens/login/face_capture_page.dart';
import 'package:go_perak/screens/login/forgot_password_page.dart';
import 'package:go_perak/screens/login/login_page.dart';
import 'package:go_perak/screens/login/disclaimer_page.dart';
import 'package:go_perak/screens/login/merchant_detail_page.dart';
import 'package:go_perak/screens/login/scan_ic_page.dart';
import 'package:go_perak/screens/login/select_role.dart';
import 'package:go_perak/screens/login/sign_up_page.dart';
import 'package:go_perak/screens/map_page.dart';
import 'package:go_perak/screens/merchant/merchant_edit_business_detail_page.dart';
import 'package:go_perak/screens/merchant/merchant_home_page.dart';
import 'package:go_perak/screens/merchant/merchant_options_page.dart';
import 'package:go_perak/screens/splash_page.dart';
import 'package:go_perak/screens/user/activities/activity_detail_page.dart';
import 'package:go_perak/screens/user/activities/activity_list_page.dart';
import 'package:go_perak/screens/user/activities/activity_rating_list_pgae.dart';
import 'package:go_perak/screens/user/activities/activity_write_review_page.dart';
import 'package:go_perak/screens/user/chatgpt_page.dart';
import 'package:go_perak/screens/user/edit_info_form_page.dart';
import 'package:go_perak/screens/user/edit_user_info_page.dart';
import 'package:go_perak/screens/user/food/food_detail_page.dart';
import 'package:go_perak/screens/user/food/food_rating_list_page.dart';
import 'package:go_perak/screens/user/food/food_write_review_page.dart';
import 'package:go_perak/screens/user/full_screen_page.dart';
import 'package:go_perak/screens/user/places/place_list_page.dart';
import 'package:go_perak/screens/user/places/place_detail_page.dart';
import 'package:go_perak/screens/user/food/food_list_page.dart';
import 'package:go_perak/screens/user/home_page.dart';
import 'package:go_perak/screens/user/places/place_rating_list_page.dart';
import 'package:go_perak/screens/user/places/place_write_review_page.dart';
import 'package:go_perak/screens/user/profile_page.dart';
import 'package:go_perak/page_base/rating_list_page.dart';
import 'package:go_perak/screens/user/search_page.dart';
import 'package:go_perak/screens/user/searching_page.dart';

class CustomRouter {
  static const String splash = '/';
  static const String login = '/login';

  //Sign Up
  static const String disclaimer = '/disclaimer';
  static const String scanIc = '/iCScan;';
  static const String faceCapture = '/faceCapture;';
  static const String signUp = '/signUp;';
  static const String selectRole = '/selectRole;';
  static const String forgotPass = '/forgotPassword;';

  static const String search = '/user/search';
  static const String rating = '/user/rating';
  static const String chatRoom = '/chatRoom';
  static const String chatList = '/chatList';
  static const String chatgpt = '/chatgpt';
  static const String fullScreenImage = '/fullScreenImage';
  static const String map = '/map';

  //User
  static const String dahsboard = '/dahsboard';
  static const String home = '/user/home';
  static const String profile = '/user/profile';
  static const String editUserInfo = '/user/editUserInfo';
  static const String editInfoForm = '/user/editInfoForm';
  static const String exploreSearch = '/user/exploreSearch';

  //User/Places
  static const String placeRatingList = '/user/place/placeRatingList';
  static const String placeWriteReview = '/user/places/placeWriteReview';
  static const String placeList = '/user/placeList';
  static const String placeDetail = '/user/places/detail';

  //User/Food
  static const String foodList = '/user/foodList';
  static const String foodDetail = '/user/food/foodDetail';
  static const String foodWriteReview = '/user/food/foodWriteReview';
  static const String foodRatingList = '/user/food/foodRatingList';

  //User/Activities
  static const String activityList = '/user/activityList';
  static const String activityDetail = '/user/activity/activityDetail';
  static const String activityWriteReview =
      '/user/activity/activityWriteReview';
  static const String activityRatingList = '/user/activity/activityRatingList';

  //Merchant
  static const String mMerchantDetail = 'login/merchantDetail;';
  static const String merchantHome = 'merchant/merchantHome;';
  static const String merchantOptions = 'merchant/merchantOptions;';
  static const String merchantEditDetails = 'merchant/merchantEditDetails;';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '');
    //final query = uri.queryParameters;

    switch (uri.path) {
      case splash:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const SplashPage());
      case login:
        return MaterialPageRoute(
            settings: settings, builder: (_) => LoginPage());
      case home:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const HomePage());
      case search:
        return MaterialPageRoute(settings: settings, builder: (_) => Search());
      case foodList:
        return MaterialPageRoute(
            settings: settings, builder: (_) => FoodListPage());
      case dahsboard:
        return MaterialPageRoute(
            settings: settings, builder: (_) => DashboardPage());
      case disclaimer:
        return MaterialPageRoute(
            settings: settings, builder: (_) => DisclaimerPage());
      case scanIc:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ICScanPage());
      case faceCapture:
        final faceCapturePage = settings.arguments as FaceCapturePage;
        return MaterialPageRoute(
            settings: settings, builder: (_) => faceCapturePage);
      case signUp:
        final signUpPage = settings.arguments as SignUpPage;
        return MaterialPageRoute(
            settings: settings, builder: (_) => signUpPage);

      case forgotPass:
        return MaterialPageRoute(
            settings: settings, builder: (_) => ForgotPasswordPage());
      case placeDetail:
        final placeDetailPage = settings.arguments as PlaceDetailPage;
        return MaterialPageRoute(
            settings: settings, builder: (_) => placeDetailPage);
      case rating:
        final ratingPage = settings.arguments as RatingListPageBase;
        return MaterialPageRoute(
            settings: settings, builder: (_) => ratingPage);
      case placeList:
        return MaterialPageRoute(
            settings: settings, builder: (_) => PlaceListPage());
      case activityList:
        return MaterialPageRoute(
            settings: settings, builder: (_) => ActivityListPage());
      case selectRole:
        return MaterialPageRoute(
            settings: settings, builder: (_) => SelectRolePage());
      case mMerchantDetail:
        return MaterialPageRoute(
            settings: settings, builder: (_) => MerchantDetailPage());
      case profile:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ProfilePage());
      case placeWriteReview:
        final placeWriteReview = settings.arguments as PlaceWriteReviewPage;
        return MaterialPageRoute(
            settings: settings, builder: (_) => placeWriteReview);
      case foodDetail:
        final foodDetailPage = settings.arguments as FoodDetailPage;
        return MaterialPageRoute(
            settings: settings, builder: (_) => foodDetailPage);
      case activityDetail:
        final activityDetailPage = settings.arguments as ActivityDetailPage;
        return MaterialPageRoute(
            settings: settings, builder: (_) => activityDetailPage);
      case foodWriteReview:
        final foodWriteReview = settings.arguments as FoodWriteReviewPage;
        return MaterialPageRoute(
            settings: settings, builder: (_) => foodWriteReview);
      case foodRatingList:
        final foodRatingList = settings.arguments as FoodRatingListPage;
        return MaterialPageRoute(
            settings: settings, builder: (_) => foodRatingList);
      case activityWriteReview:
        final activityWriteReview =
            settings.arguments as ActivityWriteReviewPage;
        return MaterialPageRoute(
            settings: settings, builder: (_) => activityWriteReview);
      case activityRatingList:
        final activityRatingList = settings.arguments as ActivityRatingListPage;
        return MaterialPageRoute(
            settings: settings, builder: (_) => activityRatingList);
      case placeRatingList:
        final placeRatingList = settings.arguments as PlaceRatingListPage;
        return MaterialPageRoute(
            settings: settings, builder: (_) => placeRatingList);
      case merchantHome:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const MerchantHomePage());
      case editUserInfo:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const EditUSerInfoPage());
      case editInfoForm:
        final editInfoFormPage = settings.arguments as EditInfoFormPage;
        return MaterialPageRoute(
            settings: settings, builder: (_) => editInfoFormPage);
      case merchantOptions:
        final merchantOptionsPage = settings.arguments as MerchantOptionsPage;
        return MaterialPageRoute(
            settings: settings, builder: (_) => merchantOptionsPage);
      case merchantEditDetails:
        final merchantEditDetailsPage =
            settings.arguments as MerchantEditBusinessDetailPage;
        return MaterialPageRoute(
            settings: settings, builder: (_) => merchantEditDetailsPage);

      case chatRoom:
        final chatRoomPage = settings.arguments as ChatRoomPage;
        return MaterialPageRoute(
            settings: settings, builder: (_) => chatRoomPage);
      case chatList:
        final chatListPage = settings.arguments as ChatListPage;
        return MaterialPageRoute(
            settings: settings, builder: (_) => chatListPage);
      case exploreSearch:
        return MaterialPageRoute(
            settings: settings, builder: (_) => ExploreSearchPage());

      case chatgpt:
        return MaterialPageRoute(
            settings: settings, builder: (_) => ChatgptPage());
      case map:
        final mapPage = settings.arguments as MapPage;
        return MaterialPageRoute(settings: settings, builder: (_) => mapPage);

      case fullScreenImage:
        final fullScreenImagePage = settings.arguments as FullScreenImagePage;
        return MaterialPageRoute(
            settings: settings, builder: (_) => fullScreenImagePage);

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
