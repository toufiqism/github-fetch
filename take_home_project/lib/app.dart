import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'di/injection.dart';
import 'domain/usecases/search_repositories.dart';
import 'presentation/bloc/repo_list_cubit.dart';
import 'presentation/bloc/theme_cubit.dart';
import 'presentation/pages/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit(sl())),
        BlocProvider(create: (_) => RepoListCubit(searchRepositories: sl<SearchRepositories>())),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GitHub Repository Explorer',
          themeMode: mode,
          theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey)),
          darkTheme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey, brightness: Brightness.dark)),
          home: const HomePage(),
        ),
      ),
    );
  }
}

