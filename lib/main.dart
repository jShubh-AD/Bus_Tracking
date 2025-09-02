import 'package:bus_tracking/core/share_prederence/share_preferences.dart';
import 'package:bus_tracking/features/dashboard/presentation/bloc/dashboard_cubit.dart';
import 'package:bus_tracking/features/dashboard/presentation/view/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await SharePreference.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<DashboardCubit>(create: (context) => DashboardCubit()),
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home:  Homepage()
    );
  }
}
