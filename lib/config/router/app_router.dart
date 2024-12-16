import 'package:go_router/go_router.dart';
import 'package:topsis/presentation/screens/screens.dart';


final appRouter = GoRouter(
  initialLocation: '/',
  routes: [

    GoRoute(
      path: '/',
      name: MenuScreen.name,
      builder: (context, state) => const MenuScreen(),
    ),
    GoRoute(
      path: '/data',
      name: DataViewScreen.name,
      builder: (context, state) => const DataViewScreen(),
    ),
    GoRoute(path: '/features',
      name: FeatureWeightsScreen.name,
      builder: (context, state) => const FeatureWeightsScreen(),
    ),
    GoRoute(path:'/results',
      name: ResultsScreen.name,
      builder: (context, state) => const ResultsScreen(),
    ),
  ],
);