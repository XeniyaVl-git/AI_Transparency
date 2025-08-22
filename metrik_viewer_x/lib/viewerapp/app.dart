import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart' show GlobalLoaderOverlay;
import 'package:metrik_viewer_x/viewerapp/bloc/viewer_bloc.dart';
import 'package:metrik_viewer_x/viewerapp/routes.dart';

class ViewerApp extends StatelessWidget {
  const ViewerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ViewerBloc(),
      child: GlobalLoaderOverlay(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          locale: const Locale('ru', 'RU'),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(27, 148, 111, 1.0),
              dynamicSchemeVariant: DynamicSchemeVariant.content,
            ),
            useMaterial3: true,
          ),
          routerConfig: routes,
        ),
      ),
    );
  }
}
