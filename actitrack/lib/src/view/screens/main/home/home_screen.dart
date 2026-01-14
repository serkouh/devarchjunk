import 'dart:async';
import 'dart:convert';

import 'package:actitrack/src/models/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:actitrack/src/config/constants/assets.dart';
import 'package:actitrack/src/config/constants/enums.dart';
import 'package:actitrack/src/config/constants/fake_data.dart';
import 'package:actitrack/src/config/constants/palette.dart';
import 'package:actitrack/src/state/providers/tasks/tasks_provider.dart';
import 'package:actitrack/src/utils/helpers/funcs.dart';
import 'package:actitrack/src/view/screens/main/home/local_widgets/tabbar_task_status_filter.dart';
import 'package:actitrack/src/view/screens/main/home/local_widgets/task_card.dart';
import 'package:actitrack/src/view/widgets/drawers/left/left_drawer.dart';
import 'package:actitrack/src/view/widgets/drawers/right/right_drawer.dart';
import 'package:actitrack/src/view/widgets/internet_checker.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:actitrack/src/models/zone.dart' as z;

import '../../../../models/target_location.dart';
import '../../../../services/http_client.dart';
import '../../../../services/service_locator.dart';
import '../../../../utils/logging/logger.dart';
import 'local_widgets/flyers_type_filter.dart';
import 'local_widgets/total_tasks_card.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  void _scrollToSelectedContent(GlobalKey key) {
    final keyContext = key.currentContext;
    if (keyContext != null) {
      Future.delayed(const Duration(milliseconds: 200)).then((_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final box = keyContext.findRenderObject() as RenderBox?;
          final position = box?.localToGlobal(Offset.zero);
          if (position != null) {
            final screenHeight = MediaQuery.of(context).size.height;
            final target = _scrollController.offset +
                position.dy -
                (screenHeight / 2) +
                (box!.size.height / 2);
            _scrollController.animateTo(target,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut);
          }
        });
      });
    }
  }

  late TasksProvider tasksProviderloading;

  Timer? _timer;
  List<Task> finishedTasks = [];
  List<Task> tasksProvider = [];
  List<Task> unfinishedTasks = [];
  List<GlobalKey> _taskCardKeys = [];
  @override
  void initState() {
    super.initState();
    // Set up the timer to trigger periodic UI updates
    _startTimer();
  }

  Future<List<Task>> loadTasks() async {
    // Load tasks from the API
    final response =
        await serviceLocator<AppHttpClient>().getRequest("/animateur/tasks");
    // final response = await http.get(Uri.parse("https://actitrack.nuancestraiteur.com/api/animateur/tasks"), headers: {
    //   'Content-Type': 'application/json',
    // });

    if (response.statusCode == 200) {
      List<Task> tasks = [];

      final data = List.from(jsonDecode(response.body)['data']);
      MyLogger.info(data);
      for (var task in data) {
        // Task _task = Task.fromJson(task);
        Task? _task = await fetchTaskTargetLocationsAndZone(task);
        /* if (otherData != null) {
          _task.locations = otherData.$1;
          _task.zone = otherData.$2;
        }*/
        if (_task != null) {
          tasks.add(_task);
        }
      }
      MyLogger.info('Tasks loaded successfully $tasks');
      return tasks;
    }
    return <Task>[];
    // return dummyTasksData;
  }

  Future<Task?> fetchTaskTargetLocationsAndZone(taskId) async {
    // Load tasks from the API
    final response = await serviceLocator<AppHttpClient>()
        .getRequest("/animateur/tasks/${taskId['id']}");
    MyLogger.info(response.body);
    if (response.statusCode == 200) {
      List<TargetLocation> locs = [];
      Task temp = Task.fromJson(jsonDecode(response.body));
      final data =
          List.from(jsonDecode(response.body)['task']['taskLocations']);
      for (var loc in data) {
        MyLogger.info("---------------");

        locs.add(TargetLocation.fromJson(loc));
      }
      temp.locations = locs;
      temp.zone = z.Zone.fromJson(jsonDecode(response.body)['task']['zone']);
      return temp;
    }
    return null;
    // return dummyTasksData;
  }

  Future<void> _startTimer() async {
    tasksProvider = await loadTasks();
    finishedTasks =
        tasksProvider.where((task) => task.status == "success").toList();
    unfinishedTasks =
        tasksProvider.where((task) => task.status != "success").toList();
    setState(() {});
    _timer = Timer.periodic(Duration(seconds: 10), (_) async {
      tasksProvider = await loadTasks();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    tasksProviderloading = Provider.of<TasksProvider>(context);
    _taskCardKeys = List.generate(tasksProvider.length, (index) => GlobalKey());

    return PopScope(
      canPop: false,
      child: Scaffold(
        key: _scaffoldStateKey,
        drawer: CustomLeftDrawer(
          scaffoldStateKey: _scaffoldStateKey,
        ),
        //endDrawer: const CustomRightDrawer(),
        body: InternetConnectivityChecker(
          actionButtonLabel: "revérifier",
          enableDefaultOfflineWidget: false,
          actionCallback: () {},
          child: DefaultTabController(
            length: 4,
            initialIndex: 0,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  elevation: 2,
                  pinned: true,
                  floating: true,
                  forceElevated: true,
                  title: const Text(
                    "ActiTrack",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: IconButton(
                    icon: SvgPicture.asset(
                      Assets.kSvg_BurgerMenu,
                      width: 25.w,
                    ),
                    onPressed: () {
                      _scaffoldStateKey.currentState?.openDrawer();
                    },
                  ),
                  actions: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            _scaffoldStateKey.currentState?.openEndDrawer();
                          },
                          child: Container(
                            width: 30.h,
                            height: 30.h,
                            padding: EdgeInsets.all(6.h),
                            margin: EdgeInsets.only(right: 10.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // color: Colors.red,
                              color: const Color(0xFFF5F5F5),
                              border: Border.all(
                                width: 0.5.w,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.2),
                              ),
                            ),
                            child: SvgPicture.asset(
                              Assets.kSvg_Notification,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  expandedHeight: 220.h,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TotalTasksCard(
                          acomplis: finishedTasks.length.toString(),
                          left: unfinishedTasks.length.toString(),
                        ),
                      ],
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(55.h),
                    child: const TabbarTaskStatusFilter(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Gap(20.h),
                      // FlyerTypeFilter(
                      //   loading: tasksProvider.loading,
                      // ),
                      // Gap(35.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (tasksProviderloading.loading)
                              Shimmer.fromColors(
                                baseColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                highlightColor: Colors.white,
                                child: Container(
                                  width: 120.w,
                                  height: 6.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              )
                            else
                              Text(
                                tasksProviderloading.tasks.isEmpty
                                    ? ""
                                    : tasksProviderloading.currentStatus ==
                                            TaskStatus.today
                                        ? "Objet à distribuer aujourd'hui"
                                        : tasksProviderloading.currentStatus ==
                                                TaskStatus.tomorrow
                                            ? "Objet à distribuer demain"
                                            : tasksProviderloading
                                                        .currentStatus ==
                                                    TaskStatus.completed
                                                ? "Objets distribué"
                                                : "Objets annulés",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Gap(10.h),
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
                      //   child: TaskCard(task: dummyTasksData.first),
                      // ),
                      if (tasksProviderloading.loading)
                        // use shimmer loading to rempresent the tasks Loading
                        Column(
                          children: List.generate(3, (index) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
                              child: Shimmer.fromColors(
                                baseColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                highlightColor: Colors.white,
                                child: Container(
                                  height: 78.h,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            );
                          }),
                        )
                      else if (tasksProvider.isEmpty)
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            margin: EdgeInsets.symmetric(horizontal: 40.w),
                            child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(16.w, 40.h, 16.w, 40.h),
                              child: Column(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Image.asset(
                                        Assets.kPng_Brochure,
                                        width: 100.w,
                                      ),
                                      Positioned(
                                        bottom: -10,
                                        right: -10,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            CupertinoIcons.xmark_circle_fill,
                                            color: Colors.black,
                                            size: 50.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap(20.h),
                                  Text(
                                    tasksProviderloading.currentStatus ==
                                            TaskStatus.today
                                        ? "Aucun flyer à livrer aujourd'hui"
                                        : tasksProviderloading.currentStatus ==
                                                TaskStatus.tomorrow
                                            ? "Aucun flyer à livrer demain"
                                            : tasksProviderloading
                                                        .currentStatus ==
                                                    TaskStatus.completed
                                                ? "Aucun flyer livré"
                                                : "Aucun flyer annulé",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: tasksProvider.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
                              child: TaskCard(
                                status: tasksProviderloading.currentStatus,
                                key: _taskCardKeys[index],
                                task: tasksProvider[index],
                                onExpansionChanged: (expanded) {
                                  if (expanded) {
                                    _scrollToSelectedContent(
                                        _taskCardKeys[index]);
                                  }
                                },
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
