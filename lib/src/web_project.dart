part of project;

class WebApp {
  String _name;
  Directory _dir;
  WebApp(String name, Directory dir){
    _name = name;
    _dir = dir;
  }
  void build(TaskContext ctx) {
    Map _project = {
      "pubspec.yaml":_pubspec(),
      "web/${_name}.css":_css(),
      "web/${_name}.html":_html(),
      "web/${_name}.json":_json(),
      "web/${_name}.dart":_main(),
      "web/server.dart":_server(),
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
description: A sample web application
dependencies:
  browser: any
  hop: any
""";
  }

  String _css() {
    return
"""

body {
  background-color: #F8F8F8;
  font-family: 'Open Sans', sans-serif;
  font-size: 14px;
  font-weight: normal;
  line-height: 1.2em;
  margin: 15px;
}

h1, p {
  color: #333;
}

#sample_container_id {
  width: 100%;
  height: 400px;
  position: relative;
  border: 1px solid #ccc;
  background-color: #fff;
}

#sample_text_id {
  font-size: 24pt;
  text-align: center;
  margin-top: 140px;
}
""";
  }

  String _main() {
    return
"""
import 'dart:html';

void main() {
  query("#sample_text_id")
    ..text = "Click me!"
    ..onClick.listen(reverseText);
  
  HttpRequest request = new HttpRequest();
  request.open("GET", "${_name}.json");
  request.onLoad.listen((response){
    if(request.status == 200){
      print(request.responseText);
    }
  });
  request.send();
}

void reverseText(MouseEvent event) {
  var text = query("#sample_text_id").text;
  var buffer = new StringBuffer();
  for (int i = text.length - 1; i >= 0; i--) {
    buffer.write(text[i]);
  }
  query("#sample_text_id").text = buffer.toString();
}
""";
  }

  String _html() {
    return
"""
<!DOCTYPE html>

<html>
  <head>
    <meta charset="utf-8">
    <title>${_name}</title>
    <link rel="stylesheet" href="${_name}.css">
  </head>
  <body>
    <h1>${_name}</h1>
    
    <p>Hello world from Dart!</p>
    
    <div id="sample_container_id">
      <p id="sample_text_id"></p>
    </div>

    <script type="application/dart" src="${_name}.dart"></script>
    <script src="packages/browser/dart.js"></script>
  </body>
</html>
""";
  }

  String _json() {
    return
"""
{"foo":"bar"}
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

  String _server(){
    return
"""
import 'dart:io';
import 'package:path/path.dart' as Path;

_sendNotFound(HttpResponse response) {
  response.statusCode = HttpStatus.NOT_FOUND;
  response.close();
}

startServer(String basePath) {
  HttpServer.bind('127.0.0.1', 8080).then((server) {
    server.listen((HttpRequest request) {
      final path = Path.normalize(request.uri.path);
      if (!Path.isAbsolute(path)) {
        _sendNotFound(request.response);
        return;
      }
      // PENDING: Do more security checks here?
      final String stringPath =
          path == '/' ? '/${_name}.html' : path;
      final File file = new File('\${basePath}\${stringPath}');
      file.exists().then((bool found) {
        if (found) {
          file.openRead()
              .pipe(request.response)
              .catchError((e) { });
        } else {
          _sendNotFound(request.response);
        }
      });
    });
  });
}

main() {
  // Compute base path for the request based on the location of the
  // script and then start the server.
  File script = new File(new Options().script);
  startServer(script.directory.path);
}
""";
  }
}