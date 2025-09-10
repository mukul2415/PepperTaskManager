import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pepper_cloud_task_manager/app/router/app_router.dart';
import 'package:pepper_cloud_task_manager/di/injector.dart';
import 'package:pepper_cloud_task_manager/features/task/presentation/bloc/task_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
          create: (context) => sl<TaskBloc>()..add(const GetTasksEvent()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Task Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}