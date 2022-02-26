import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_repos/navigator_service.dart';
import 'package:palette/modules/app_info/bloc/contact_us_bloc.dart';
import 'package:palette/modules/app_info/bloc/report_bug_bloc.dart';
import 'package:palette/modules/auth_module/screens/login_screen.dart';
import 'package:palette/modules/auth_module/services/firebase_auth_repo.dart';
import 'package:palette/modules/auth_module/services/notification_repository.dart';
import 'package:palette/modules/bottom_navbar/change_index_bloc/navbar_change_index_bloc.dart';
import 'package:palette/modules/chat_module/services/chat_repository.dart';
import 'package:palette/modules/explore_module/blocs/my_creations_bloc/my_creations_bulk_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/get_recipients_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/save_opportunity_bloc.dart';
import 'package:palette/modules/notifications_module/bloc/notifications_bloc.dart';
import 'package:palette/modules/notifications_module/services/notifications_repo.dart';
import 'package:palette/modules/profile_module/bloc/profile_image_bloc/profile_image_bloc.dart';
import 'package:palette/modules/profile_module/bloc/third_person_bloc/third_person_bloc.dart';
import 'package:palette/modules/profile_module/services/third_person_repository.dart';
import 'package:palette/modules/share_drawer_module/share_drawer_bloc/share_create_todo_bloc.dart';
import 'package:palette/modules/todo_module/bloc/Parent_todo_bloc/todo_parent_bloc.dart';
import 'package:palette/modules/todo_module/bloc/create_todo_local_save_bloc/create_todo_local_save_bloc.dart';
import 'package:palette/modules/todo_module/bloc/hide_bottom_navbar_bloc/hide_bottom_navbar_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_accept_reject_bulk_bloc.dart/todo_accept_reject_bulk_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_ad_bloc/todo_ad_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_filter_bloc/todo_filter_bloc.dart';
import 'package:palette/modules/todo_module/screens/todo_list_screen.dart';
import 'package:palette/modules/todo_module/services/todo_repo_admin.dart';
import 'package:palette/modules/todo_module/services/todo_repo_parents.dart';
import 'package:palette/utils/helpers.dart';
import 'package:shared_preference_app_group/shared_preference_app_group.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modules/admin_dashboard_module/bloc/student_bloc/admin_student_bloc.dart';
import 'modules/admin_dashboard_module/services/admin_repository.dart';
import 'modules/advisor_dashboard_module/bloc/student_list_bloc/advisor_student_bloc.dart';
import 'modules/advisor_dashboard_module/bloc/student_list_bloc/advisor_student_events.dart';
import 'modules/advisor_dashboard_module/services/advisor_repository.dart';
import 'modules/app_info/bloc/resource_center_bloc.dart';
import 'modules/app_info/bloc/send_feedback_bloc.dart';
import 'modules/auth_module/bloc/auth_bloc.dart';
import 'modules/auth_module/screens/splash_screen.dart';
import 'modules/auth_module/services/auth_repository.dart';
import 'modules/bottom_navbar/bloc/bottom_navbar_bloc.dart';
import 'modules/contacts_module/bloc/contacts_bloc.dart';
import 'modules/explore_module/blocs/get_my_creations_bloc/get_my_creations_bloc.dart';
import 'modules/explore_module/blocs/opportunity_bloc/add_opportunities_consideration_bloc.dart';
import 'modules/explore_module/blocs/opportunity_bloc/create_opportunity_bloc.dart';
import 'modules/explore_module/blocs/opportunity_bloc/edit_opportunity_bloc.dart';
import 'modules/explore_module/blocs/opportunity_bloc/opportunity_bulk_edit_bloc.dart';
import 'modules/explore_module/blocs/opportunity_bloc/opportunity_bulk_share_bloc.dart';
import 'modules/notifications_module/bloc/read_all_notification_bloc.dart';
import 'modules/observer_dashboard_module/bloc/student_bloc/observer_student_bloc.dart';
import 'modules/observer_dashboard_module/bloc/student_bloc/observer_student_events.dart';
import 'modules/observer_dashboard_module/services/observer_repository.dart';
import 'modules/profile_module/bloc/profile_bloc/profile_bloc.dart';
import 'modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_bloc.dart';
import 'modules/profile_module/services/profile_repository.dart';
import 'modules/share_drawer_module/services/sharedrawer_navigation_repo.dart';
import 'modules/student_recommendation_module/bloc/recommendation_bloc/consideration_bulk_bloc.dart';
import 'modules/student_recommendation_module/bloc/recommendation_bloc/recommendation_bulk_share_bloc.dart';
import 'modules/todo_module/bloc/draft_todo_publish_bloc.dart';
import 'modules/todo_module/bloc/todo_accept_reject_bloc/todo_accept_reject_bloc.dart';
import 'modules/todo_module/bloc/todo_bloc.dart';
import 'modules/todo_module/bloc/todo_bulk_bloc.dart';
import 'modules/todo_module/services/todo_repo.dart';

var prefs;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print("badgeCounterMade increase${message.messageId}");
  badgeCounter++;
  FlutterAppBadger.updateBadgeCount(badgeCounter);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Helper.setupPendoSDK();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  //await SharedPreferenceAppGroup.setAppGroup(iOSAppGroupId);
  
  prefs = await SharedPreferences.getInstance();
  ChatRepository.retrieveAndSetUsersMappingFromSharedPrefs();
  print(ChatRepository.usersUidMap);
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        FlutterAppBadger.updateBadgeCount(0);
        final context = NavigatorService.navigatorKey.currentContext!;
        final sharedrawerServices = ShareDrawerNavigationRepo.instance;
        sharedrawerServices.shareDrawerNavigationForiOS(context: context);
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _setupNotificationListeners();
  }

  _setupNotificationListeners() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    print('initialMessage?.data: ${initialMessage?.data}');
    if (initialMessage == null) return;

    if (initialMessage.data.containsKey('type') &&
        initialMessage.data['type'] == 'todo') {
      TodoRepo.instance.globalTodoNotifData = initialMessage.data;
    } else {
      NotificationRepo.instance.globalChatNotifData = initialMessage.data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
            create: (context) =>
                ProfileBloc(profileRepo: ProfileRepository.instance)),
        BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
                  authRepo: AuthRepository.instance,
                  firebaseAuthRepo: FirebaseAuthRepo.instance,
                  notificationRepo: NotificationRepo.instance,
                )),
        BlocProvider<RefreshProfileBloc>(
            create: (BuildContext context) =>
                RefreshProfileBloc(profileRepo: ProfileRepository.instance)),
        BlocProvider<ThirdPersonBloc>(
            create: (BuildContext context) => ThirdPersonBloc(
                thirdPersonRepo: ThirdPersonRepository.instance)),
        BlocProvider<BottomNavbarBloc>(
            create: (BuildContext context) => BottomNavbarBloc()),
        BlocProvider(
          create: (BuildContext context) {
            //context.read<RefreshProfileBloc>().add(RefreshUserProfileDetails());
            return ObserverStudentBloc(
                observerRepo: ObserverRepository.instance)
              ..add(ObserverGetStudentUser());
          },
        ),
        BlocProvider(
          create: (BuildContext context) {
            //context.read<RefreshProfileBloc>().add(RefreshUserProfileDetails());
            return AdminStudentBloc(adminRepo: AdminRepository.instance);
          },
        ),
        BlocProvider(
          create: (BuildContext context) {
            //context.read<RefreshProfileBloc>().add(RefreshUserProfileDetails());
            return AdviserStudentBloc(advisorRepo: AdvisorRepository.instance)
              ..add(AdvisorGetStudentUser());
          },
        ),
        BlocProvider<TodoBloc>(
            create: (BuildContext context) =>
                TodoBloc(todoRepo: TodoRepo.instance)),
        BlocProvider<TodoListBloc>(
            create: (BuildContext context) =>
                TodoListBloc(todoRepo: TodoRepo.instance)),
        BlocProvider<TodoCrudBloc>(
            create: (BuildContext context) =>
                TodoCrudBloc(todoRepo: TodoRepo.instance)),
        BlocProvider<TodoParentAdvisorBloc>(
            create: (BuildContext context) =>
                TodoParentAdvisorBloc(todoRepo: TodoRepoParents.instance)),
        BlocProvider<TodoParentCrudBloc>(
            create: (BuildContext context) =>
                TodoParentCrudBloc(todoRepo: TodoRepoParents.instance)),
        BlocProvider<TodoAdminBloc>(
            create: (BuildContext context) =>
                TodoAdminBloc(todoRepo: TodoRepoAdmins.instance)),
        BlocProvider<TodoAdminCrudBloc>(
            create: (BuildContext context) =>
                TodoAdminCrudBloc(todoRepo: TodoRepoAdmins.instance)),
        BlocProvider<ProfileImageBloc>(
          create: (BuildContext context) => ProfileImageBloc(),
        ),
        BlocProvider<TodoFilterBloc>(
            create: (BuildContext context) =>
                TodoFilterBloc(TodoFilterInitialState())),
        BlocProvider<TodoFilterBlocStudent>(
          create: (BuildContext context) =>
              TodoFilterBlocStudent(TodoFilterInitialStateStudent()),
        ),
        BlocProvider<CreateTodoLocalSaveBloc>(
          create: (BuildContext context) => CreateTodoLocalSaveBloc(),
        ),
        BlocProvider<ReportBugBloc>(
            create: (BuildContext context) => ReportBugBloc()),
        BlocProvider<ResourceCenterBloc>(
          create: (BuildContext context) => ResourceCenterBloc(),
        ),
        BlocProvider<ContactUsBloc>(
          create: (BuildContext context) => ContactUsBloc(),
        ),
        BlocProvider<SendFeedbackBloc>(
          create: (BuildContext context) => SendFeedbackBloc(),
        ),
        BlocProvider<PendoMetaDataBloc>(
          create: (BuildContext context) => PendoMetaDataBloc(),
        ),
        BlocProvider<HideNavbarBloc>(
          create: (BuildContext context) => HideNavbarBloc(),
        ),
        BlocProvider<NavBarChangeIndexBloc>(
          create: (BuildContext context) => NavBarChangeIndexBloc(),
        ),
        BlocProvider<TodoBulkBloc>(
          create: (BuildContext context) =>
              TodoBulkBloc(TodoBulkInitialState()),
        ),
        BlocProvider<OpportunityBulkEditBloc>(
          create: (BuildContext context) => OpportunityBulkEditBloc(),
        ),
        BlocProvider<OpportunityBulkShareBloc>(
          create: (BuildContext context) => OpportunityBulkShareBloc(),
        ),
        BlocProvider<RecommendationBulkShareBloc>(
          create: (BuildContext context) => RecommendationBulkShareBloc(),
        ),
        BlocProvider<ConsiderationBulkBloc>(
            create: (BuildContext context) => ConsiderationBulkBloc()),
        BlocProvider<CreateOpportunityBloc>(
            create: (context) =>
                CreateOpportunityBloc(CreateOpportunityInitialState())),
        BlocProvider<SaveOpportunityBloc>(
            create: (context) =>
                SaveOpportunityBloc(SaveOpportunityInitialState())),
        BlocProvider<GetRecipientsBloc>(
            create: (context) => GetRecipientsBloc(GetRecipientsInitialState())
              ..add(GetRecipientsForOpportunityEvent())),
        BlocProvider<EditOpportunityBloc>(
          create: (context) =>
              EditOpportunityBloc(EditOpportunityInitialState()),
        ),
        BlocProvider<MyCreationsBlukBloc>(
          create: (context) =>
              MyCreationsBlukBloc(MyCreationsBulkInitialState()),
        ),
        BlocProvider<GetMyCreationsBloc>(
            create: (context) =>
                GetMyCreationsBloc()..add(GetMyCreationsFetchEvent())),
        BlocProvider<GetContactsBloc>(
          create: (context) => GetContactsBloc(GetContactsInitialState()),
        ),
        BlocProvider<NotificationsBloc>(
            create: (context) => NotificationsBloc(
                notificationsRepository: NotificationsRepository.instance)
              ..add(FetchNotifications())),
        BlocProvider<AllNotificationsBloc>(
          create: (context) => AllNotificationsBloc(
              notificationsRepository: NotificationsRepository.instance),
        ),
        BlocProvider<AddOpportunitiesToTodoBloc>(
            create: (context) => AddOpportunitiesToTodoBloc(
                AddOpportunitiesToTodoInitialState())),
        BlocProvider<DraftTodoPublishBloc>(
          create: (context) => DraftTodoPublishBloc(
            DraftTodoPublishInitialState(),
          ),
        ),
        BlocProvider<TodoAcceptRejectBloc>(
          create: (context) => TodoAcceptRejectBloc(
            TodoAcceptRejectInitialState(),
          ),
        ),
        BlocProvider<TodoAcceptRejectBulkBloc>(
          create: (context) => TodoAcceptRejectBulkBloc(
            TodoAcceptRejectBulkInitialState(),
          ),
        ),
        BlocProvider<ShareCreateTodoBloc>(
          create: (context) => ShareCreateTodoBloc(
            ShareCreateTodoInitialState(),
          ),
        ),
      ],
      child: MaterialApp(
          navigatorKey: NavigatorService.navigatorKey,
          initialRoute: '/',
          routes: {
            '/': (context) => SplashScreen(),
            '/login': (context) => LoginScreen()
            // '/': (context) => CommentsView(),
          },
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              fontFamily: "MontserratReg",
              textSelectionTheme: TextSelectionThemeData(
                selectionHandleColor: Colors.transparent,
              ))),
    );
  }
}

class TextScaleFactorClamper extends StatelessWidget {
  final Widget child;
  final double? minScaleFactor;
  final double? maxScaleFactor;

  const TextScaleFactorClamper({
    required this.child,
    this.minScaleFactor,
    this.maxScaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final constrainedTextScaleFactor = mediaQueryData.textScaleFactor
        .clamp(minScaleFactor ?? 1.0, maxScaleFactor ?? 2.0);

    return MediaQuery(
      data: mediaQueryData.copyWith(
        textScaleFactor: constrainedTextScaleFactor,
      ),
      child: child,
    );
  }
}
