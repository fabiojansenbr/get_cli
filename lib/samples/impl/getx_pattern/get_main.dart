import 'package:get_cli/samples/interface/sample_interface.dart';

class GetXMainSample extends Sample {
  GetXMainSample() : super('lib/main.dart', overwrite: true);

  @override
  Future<String> get content async => '''import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
  ''';
}
