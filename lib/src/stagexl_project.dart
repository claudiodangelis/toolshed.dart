part of project;

class StageXLApp {
  String _name;
  Directory _dir;
  bool _isBlank;
  StageXLApp(String name, Directory dir){
    _name = name;
    _dir = dir;
  }
  void build(TaskContext ctx) {
    _isBlank = ctx.arguments["blank"];
    Map _project = {
      "pubspec.yaml":_pubspec(),
      "web/${_name}.html":_html(),
      "web/${_name}.dart":_main(),
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

  String _pubspec(){
    return
"""
name: ${_name}
description: A sample StageXL application
dependencies:
  browser: any
  hop: any
  stagexl: any
""";
  }

  String _main() {
    String _sampleContent = '';
    if(!_isBlank) {
      _sampleContent =
"""
  // setup the Stage and RenderLoop 
  var canvas = html.query('#stage');
  var stage = new Stage('myStage', canvas);
  stage.align=StageAlign.TOP_LEFT;
  stage.scaleMode=StageScaleMode.NO_SCALE;
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);
  
  // add Hello World text
  var fmt = new TextFormat("Arial", 18, 0x000000);
  var tf = new TextField();
  tf.defaultTextFormat = fmt;
  tf.text = "Hello world from StageXL";
  tf.width = 500;
  stage.addChild(tf);

  // draw a red circle
  var shape = new Shape();
  shape.graphics.circle(100, 100, 60);
  shape.graphics.fillColor(Color.Red);
  stage.addChild(shape);
""";
    }
    return
"""
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

void main() {
$_sampleContent
}
""";
  }

  String _html() {
    String _sampleContent = '';
    if(!_isBlank) {
      _sampleContent = '\n    <canvas id="stage" width="800" height="600"></canvas>';
    }
    return
"""
<!DOCTYPE html>

<html>
  <head>
    <meta charset="utf-8">
    <title>${_name}</title>    
  </head>
  <body>$_sampleContent

    <script type="application/dart" src="${_name}.dart"></script>
    <script src="packages/browser/dart.js"></script>
  </body>
</html>
""";
  }

  String _hop(){
    return
"""
library hop_runner;

import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';

void main() {
  var paths = ['web/${_name}.dart']; 

  addTask('docs', createDartDocTask(paths, linkApi: true));
  
  addTask('analyze_libs', createAnalyzerTask(paths));
  
  addTask('dart2js', createDartCompilerTask(paths, liveTypeAnalysis: true));

  addTask('cs', createProcessTask("/Applications/dart/chromium/Content Shell.app/Contents/MacOS/Content Shell",args:["--dump-render-tree","web/${_name}.html"], description:"Run in content_shell."));  

  addTask('run', createProcessTask("/Applications/dart/chromium/Chromium.app/Contents/MacOS/Chromium",args:["web/${_name}.html"], description:"Run in Chromium."));

  runHop();
}
""";
  }
}