import 'dart:io';

import 'package:cli_menu/cli_menu.dart';
import 'package:get_cli/commands/impl/create/create.dart';
import 'package:get_cli/commands/interface/command.dart';
import 'package:get_cli/common/utils/logger/LogUtils.dart';
import 'package:get_cli/core/generator.dart';
import 'package:get_cli/core/structure.dart';
import 'package:get_cli/functions/routes/get_add_route.dart';
import 'package:get_cli/models/file_model.dart';
import 'package:get_cli/samples/impl/get_binding.dart';
import 'package:get_cli/samples/impl/get_controller.dart';
import 'package:get_cli/samples/impl/get_view.dart';
import 'package:recase/recase.dart';

class CreatePageCommand extends Command with CreateMixin {
  @override
  Future<void> execute() async {
    bool isProject = GetCli.arguments[1].split(':').first == 'project';
    FileModel _fileModel =
        Structure.model(isProject ? 'home' : name, 'page', true);
    if (File(_fileModel.path + '_page.dart').existsSync() ||
        File(_fileModel.path + '_binding.dart').existsSync() ||
        File(_fileModel.path + '_controller.dart').existsSync()) {
      LogService.info(
          'The page [$name] already exists, do you want to overwrite it?');
      final menu = Menu(['Yes', 'No']);
      final result = menu.choose();
      if (result.index == 0) {
        await _writeFiles(_fileModel, isProject ? 'home' : name,
            overwrite: true);
      }
    } else {
      await _writeFiles(_fileModel, isProject ? 'home' : name,
          overwrite: false);
    }
  }

  @override
  String get hint => 'Use to generate pages';

  @override
  bool validate() {
    return true;
  }

  Future<void> _writeFiles(FileModel _fileModel, String name,
      {bool overwrite = false}) async {
    String controllerDir = Directory(Structure.replaceAsExpected(
                path: Directory.current.path + '/lib/pages/'))
            .existsSync()
        ? 'pages/${name.snakeCase}/${name.snakeCase}_controller.dart'
        : 'app/modules/${name.snakeCase}/${name.snakeCase}_controller.dart';

    await BindingSample(_fileModel.path + '_binding.dart', name,
            name.pascalCase + 'Binding', controllerDir,
            overwrite: overwrite)
        .create();

    await GetViewSample(
            _fileModel.path + '_page.dart',
            name.pascalCase + 'Page',
            name.pascalCase + 'Controller',
            controllerDir,
            overwrite: overwrite)
        .create();

    await ControllerSample('lib/' + controllerDir, name, overwrite: overwrite)
        .create();

    await addRoute(name);
    LogService.success(name.pascalCase + ' page created successfully.');
    return;
  }
}
