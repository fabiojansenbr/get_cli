import 'dart:io';

import 'package:get_cli/core/structure.dart';
import 'package:get_cli/samples/impl/get_app_pages.dart';
import 'package:recase/recase.dart';

Future<void> createAppPage() async {
  await AppPagesSample().create();
}

Future<void> addAppPage(String name) async {
  File appPagesFile =
      File(Structure.replaceAsExpected(path: 'lib/routes/app_pages.dart'));
  if (!await appPagesFile.exists()) {
    appPagesFile = File(
        Structure.replaceAsExpected(path: 'lib/app/routes/app_pages.dart'));
    if (!await appPagesFile.exists()) {
      await AppPagesSample().create();
    }
  }
  var lines = await appPagesFile.readAsLinesSync();

  while (lines.last.isEmpty) {
    lines.removeLast();
  }

  /* 
  Verificar se as utimas linha segue o padrão esperado.
  exemplo: 
        ), // finalizar o getPage 
      ]; // finalizar o array de pages
    } // finaliza a classe

    exemplos de fora do padrão:
    ),];} // tudo na mesma linha
  */
  if (lines.last.trim() != '}') {
    lines.last = lines.last.replaceAll('}', '');
    lines.add('}');
  }
  int indexClassRoutes =
      lines.indexWhere((element) => element.contains('class AppPages'));
  int index =
      lines.indexWhere((element) => element.contains('];'), indexClassRoutes);
  if (lines[index].trim() != '];') {
    lines[index] = lines[index].replaceAll('];', '');
    index++;
    lines.insert(index, '  ];');
  }

  String nameSnakeCase = name.snakeCase;
  String namePascalCase = name.pascalCase;
  String line = '''    GetPage(
      name: Routes.${nameSnakeCase.toUpperCase()}, 
      page:()=> ${namePascalCase}Page(), 
      binding: ${namePascalCase}Binding(),
    ),''';
  String import = Directory(Structure.replaceAsExpected(
              path: Directory.current.path + '/lib/pages/'))
          .existsSync()
      ? 'pages'
      : 'modules';
  lines.insert(index, line);
  lines.insert(0,
      '''import '../$import/$nameSnakeCase/${nameSnakeCase}_binding.dart';''');
  lines.insert(
      0, '''import '../$import/$nameSnakeCase/${nameSnakeCase}_page.dart';''');

  await appPagesFile.writeAsStringSync(lines.join('\n'));
}
