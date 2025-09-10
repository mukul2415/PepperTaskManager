import 'package:get_it/get_it.dart';
import 'package:pepper_cloud_task_manager/features/task/data/datasources/task_local_datasource.dart';
import 'package:pepper_cloud_task_manager/features/task/data/datasources/task_remote_datasource.dart'; // Import remote
import 'package:pepper_cloud_task_manager/features/task/data/repositories/task_repository_impl.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/repositories/task_repository.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/usecases/add_task.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/usecases/delete_task.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/usecases/get_all_tasks.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/usecases/mark_task_completed.dart';
import 'package:pepper_cloud_task_manager/features/task/domain/usecases/update_task.dart';
import 'package:pepper_cloud_task_manager/features/task/presentation/bloc/task_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {

  // Blocs
  sl.registerFactory(() => TaskBloc(
    addTask: sl(),
    getAllTasks: sl(),
    updateTask: sl(),
    deleteTask: sl(),
    markTaskCompleted: sl(),
  ));

  // Use cases
  sl.registerLazySingleton(() => AddTask(sl()));
  sl.registerLazySingleton(() => GetAllTasks(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));
  sl.registerLazySingleton(() => MarkTaskCompleted(sl()));

  // Repositories
  sl.registerLazySingleton<TaskRepository>(
          () => TaskRepositoryImpl(localDataSource: sl(), remoteDataSource: sl())); // Inject remote

  // Data sources
  sl.registerLazySingleton<TaskLocalDataSource>(
          () => TaskLocalDataSourceImpl());
  sl.registerLazySingleton<TaskRemoteDataSource>(
          () => TaskRemoteDataSourceImpl()); // Register remote

}