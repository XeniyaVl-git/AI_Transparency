import 'package:go_router/go_router.dart';
import 'package:metrik_viewer_x/viewerapp/views/views.dart';

final routes = GoRouter(
  // initialLocation: '/auth',
  routes: [
    GoRoute(
      path: '/',
      name: 'main_page',
      builder: (context, state) => const MainView(),
      routes: [
        GoRoute(
          path: 'detail',
          name: 'detail_view',
          builder: (context, state) => const DetailView(),
          routes: [
        
      ]
    ),
      ],
    ),
  ],
);
