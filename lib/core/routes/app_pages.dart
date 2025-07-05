import 'package:get/get.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/utils/cache_helper.dart';
import 'package:nahkum/features/Lawer/presentation/views/case_details_view.dart';
import 'package:nahkum/features/auth/presentation/bindings/forget_password_binding.dart';
import 'package:nahkum/features/auth/presentation/bindings/login_binding.dart';
import 'package:nahkum/features/auth/presentation/bindings/otp_binding.dart';
import 'package:nahkum/features/auth/presentation/bindings/register_binding.dart';
import 'package:nahkum/features/auth/presentation/bindings/reset_password_binding.dart';
import 'package:nahkum/features/chat/presentation/controller/chat_binding.dart';
import 'package:nahkum/features/chat/presentation/controller/contacts_binding.dart';
import 'package:nahkum/features/chat/presentation/screens/chat_conversation_screen.dart';
import 'package:nahkum/features/chat/presentation/screens/contacts_screens.dart';
import 'package:nahkum/features/judge/presentation/bindings/tasks_binding.dart';
import 'package:nahkum/features/lawer/presentation/bindings/agencies_binding.dart';
import 'package:nahkum/features/lawer/presentation/bindings/case_details_binding.dart';
import 'package:nahkum/features/lawer/presentation/bindings/cases_binding.dart';
import 'package:nahkum/features/lawer/presentation/bindings/clients_binding.dart';
import 'package:nahkum/features/lawer/presentation/bindings/lawyer_home_binding.dart';
import 'package:nahkum/features/lawer/presentation/bindings/my_orders_binding.dart';
import 'package:nahkum/features/lawer/presentation/views/agencies_view.dart';
import 'package:nahkum/features/lawer/presentation/views/clients_view.dart';
import 'package:nahkum/features/lawer/presentation/views/lawyer_home_view.dart';
import 'package:nahkum/features/lawer/presentation/views/my_cases_view.dart';
import 'package:nahkum/features/lawer/presentation/views/my_orders_view.dart';
import 'package:nahkum/features/auth/data/models/user/user_model.dart';
import 'package:nahkum/features/client/case_management/presentation/bindings/case_management_binding.dart';
import 'package:nahkum/features/client/case_management/presentation/views/case_management_view.dart';
import 'package:nahkum/features/client/case_offer/presentation/bindings/case_offer_binding.dart';
import 'package:nahkum/features/client/case_offer/presentation/bindings/case_offer_list_binding.dart';
import 'package:nahkum/features/client/case_offer/presentation/views/case_offer_detail_view.dart';
import 'package:nahkum/features/client/case_offer/presentation/views/case_offer_list_view.dart';
import 'package:nahkum/features/client/consultation/presentation/bindings/consultation_binding.dart';
import 'package:nahkum/features/client/consultation/presentation/views/consultation_view.dart';
import 'package:nahkum/features/client/direct_case_request/presentation/bindings/direct_case_request_binding.dart';
import 'package:nahkum/features/client/direct_case_request/presentation/views/direct_case_request_view.dart';
import 'package:nahkum/features/client/home/presentation/bindings/home_binding.dart';
import 'package:nahkum/features/client/home/presentation/views/home_view.dart';
import 'package:nahkum/features/client/home/presentation/widgets/lawyers_listing_page.dart';
import 'package:nahkum/features/client/payment/presentation/bindings/payment_binding.dart';
import 'package:nahkum/features/client/payment/presentation/views/payment_view.dart';
import 'package:nahkum/features/client/payment/presentation/views/payment_success_view.dart';
import 'package:nahkum/features/client/publish_case/presentation/bindings/publish_case_binding.dart';
import 'package:nahkum/features/client/publish_case/presentation/views/publish_case_view.dart';
import 'package:nahkum/features/auth/presentation/views/forget_password_screen.dart';
import 'package:nahkum/features/auth/presentation/views/login_screen.dart';
import 'package:nahkum/features/auth/presentation/views/otp_verification_screen.dart';
import 'package:nahkum/features/auth/presentation/views/password_reset_success_screen.dart';
import 'package:nahkum/features/auth/presentation/views/register_screen.dart';
import 'package:nahkum/features/auth/presentation/views/reset_password_screen.dart';

import 'package:nahkum/features/judge/presentation/bindings/add_task_binding.dart';
import 'package:nahkum/features/judge/presentation/bindings/blog_details_binding.dart';
import 'package:nahkum/features/judge/presentation/bindings/books_binding.dart';
import 'package:nahkum/features/judge/presentation/bindings/video_analysis_binding.dart';
import 'package:nahkum/features/judge/presentation/views/add_task_view.dart';
import 'package:nahkum/features/judge/presentation/views/blog_details_view.dart';
import 'package:nahkum/features/judge/presentation/views/blogs_view.dart';
import 'package:nahkum/features/judge/presentation/views/judge_home_view.dart';
import 'package:nahkum/features/judge/presentation/views/tasks_view.dart';
import 'package:nahkum/features/judge/presentation/views/video_analysis_view.dart';
import 'package:nahkum/features/notifications/presentation/bindings/notifications_binding.dart';
import 'package:nahkum/features/notifications/presentation/views/notifications_view.dart';
import 'package:nahkum/features/onboarding/data/models/user_role.dart';
import 'package:nahkum/features/onboarding/presentation/bindings/onboarding_binding.dart';
import 'package:nahkum/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:nahkum/features/profile/presentation/controller/profile_binding.dart';
import 'package:nahkum/features/profile/presentation/screens/profile_screen.dart';
import 'package:nahkum/features/settings/presentation/bindings/settings_binding.dart';
import 'package:nahkum/features/settings/presentation/views/settings_view.dart';
import 'package:nahkum/features/splash/presentation/bindings/splash_binding.dart';
import 'package:nahkum/features/splash/presentation/views/splash_view.dart';

class AppPages {
  static const initialRoute = Routes.SPLASH;

  static final routes = [
    GetPage(
      transition: Transition.noTransition,
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.LOGIN,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.REGISTER,
      page: () => RegisterScreen(),
      binding: RegisterBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.FORGOT_PASSWORD,
      page: () => ForgetPasswordScreen(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.OTP_VERIFICATION,
      page: () {
        final args = Get.arguments ?? {};
        final email = args['email'] ?? '';

        return OtpVerificationScreen(
          email: email,
        );
      },
      binding: OtpBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.RESET_PASSWORD,
      page: () {
        final args = Get.arguments ?? {};
        return ResetPasswordScreen(
          email: args['email'] ?? '',
        );
      },
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.PASSWORD_RESET_SUCCESS,
      page: () => const PasswordResetSuccessScreen(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.PROFILE,
      page: () => ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.CHATS,
      page: () => ContactsScreens(),
      binding: ContactsBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.CHAT_DETAIL,
      page: () => ChatConversationScreen(),
      binding: ChatBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.CONSULTATION_REQUEST,
      page: () => const ConsultationView(),
      binding: ConsultationBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.CASES,
      page: () => const CaseManagementView(),
      binding: CaseManagementBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.DIRECT_CASE_REQUEST,
      page: () => const DirectCaseRequestView(),
      binding: DirectCaseRequestBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.PUBLISH_CASE,
      page: () => const PublishCaseView(),
      binding: PublishCaseBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.LAWYERS_LISTING,
      page: () => const LawyersListingPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.CASE_OFFER_DETAIL,
      page: () => const CaseOfferDetailView(),
      binding: CaseOfferBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.CASE_DETAILS,
      page: () => const CaseOfferListView(),
      binding: CaseOfferListBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.LAWYER_HOME,
      page: () => const LawyerHomeView(),
      binding: LawyerHomeBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.LAWYER_CLIENTS,
      page: () => const ClientsView(),
      binding: ClientsBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.LAWYER_CASES,
      page: () => const MyCasesView(),
      binding: CasesBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.LAWYER_AGENCIES,
      page: () => const AgenciesView(),
      binding: AgenciesBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.LAWYER_ORDERS,
      page: () => const MyOrdersView(),
      binding: MyOrdersBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.Judge_HOME,
      page: () => const JudgeHomeView(),
      binding: TasksBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.Tasks_View,
      page: () => const TasksView(),
      binding: TasksBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.Video_Analysis_View,
      page: () => const VideoAnalysisView(),
      binding: VideoAnalysisBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.Blogs_View,
      page: () => const BlogsView(),
      binding: BooksBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.Agencies_View,
      page: () => const AgenciesView(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.blog_details,
      page: () => const BlogDetailsView(),
      binding: BlogDetailsBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.add_task,
      page: () => const AddTaskView(),
      binding: AddTaskBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.PAYMENT,
      page: () => const PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.PAYMENT_SUCCESS,
      page: () => const PaymentSuccessView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      transition: Transition.noTransition,
      name: Routes.LAWYER_CaseDetailsView,
      page: () => const CaseDetailsView(),
      binding: CaseDetailsBinding(),
    ),
  ];

  static String homeRoute() {
    UserModel user = UserModel.fromJson(cache.read(CacheHelper.user));
    if (user.role.toString() == UserRole.client.name) {
      return Routes.HOME;
    } else if (user.role.toString() == UserRole.lawyer.name) {
      return Routes.LAWYER_HOME;
    } else if (user.role.toString() == UserRole.judge.name) {
      return Routes.Judge_HOME;
    } else {
      return Routes.ONBOARDING;
    }
  }

  static String getInitialRouteAfterSplash() {
    return cache.read(CacheHelper.token) == null
        ? Routes.ONBOARDING
        : homeRoute();
  }
}
