part of project;

class CommandLineApp {
  String _name;
  Directory _dir;
  bool _isBlank;
  CommandLineApp(String name, Directory dir){
    _name = name;
    _dir = dir;
  }
  void build(TaskContext ctx) {
    _isBlank = ctx.arguments["blank"];
    Map _project = {
      "pubspec.yaml":_pubspec(),
      "bin/${_name}.dart":_main(),
      "tool/hop_runner.dart":_hop()
    };
    _project.forEach((k,v){
      File f = new File("${_dir.path}/$k");
      Directory dir = f.directory;
      dir.exists().then((exists){
      if(!exists) dir.createSync();
        if(v is String){
          f.writeAsStringSync(v);
        }
        if(v is List<int>){
          f.writeAsBytesSync(v);
        }
      });
      ctx.info(k);
    });
  }

  String _pubspec() {
    return
"""
name: ${_name}
description: A sample command-line application
dependencies:
  hop: any
""";
  }

  String _main() {
    String _sampleContent = '';
    if(!_isBlank) {
      _sampleContent = '\n  print("Hello, World!");\n';
    }
    return
"""
void main() {$_sampleContent}
""";
  }

  String _hop(){
    return
"""
library hop_runner;

import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';

void main() {
  var paths = ['bin/${_name}.dart']; 

  addTask('docs', createDartDocTask(paths, linkApi: true));
  
  addTask('analyze_libs', createAnalyzerTask(paths));
  
  runHop();
}
""";
  }
}