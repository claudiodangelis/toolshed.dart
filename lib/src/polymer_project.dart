part of project;

class PolymerApp {
  String _name;
  Directory _dir;
  PolymerApp(String name, Directory dir){    
    _name = name;
    _dir = dir; 
  }
  void build(TaskContext ctx) {
    Map _project = {
      "pubspec.yaml":_pubspec(),
      "web/${_name}.css":_css(),
      "web/${_name}.html":_html(),
      "web/${_name}.dart":_main(),
      "web/xclickcounter.dart":_elementdart(),
      "web/xclickcounter.html":_elementhtml(),
      "web/server.dart":_server(),
      "tool/hop_runner.dart":_hop(),
      "build.dart":_build()
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
  polymer: any
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
  query("#counter_template").model = 5;
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
    <title>Sample app</title>
    <link rel="stylesheet" href="${_name}.css">
    
    <!-- import the click-counter -->
    <link rel="import" href="xclickcounter.html">
  </head>
  <body>
    <h1>${_name}</h1>
    
    <p>Hello world from Dart!</p>
    
    <div id="sample_container_id">      
      <template id="counter_template" bind>     
        <my-clickcounter id="click_counter" count="{{}}"></my-clickcounter>
      </template>           
    </div>
 
    <script type="application/dart" src="${_name}.dart"></script>
    <script src="packages/polymer/boot.js"></script>
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
  
  addTask('dart2js', createDartCompilerTask(paths, liveTypeAnalysis: true, rejectDeprecatedFeatures: true));

  // For OSX only, replace with your favorite operating system path
  addTask('cs', createProcessTask("/Applications/dart/chromium/Content Shell.app/Contents/MacOS/Content Shell",args:["--dump-render-tree","web/out/${_name}.html"], description:"Run in content_shell."));  

  // For OSX only, replace with your favorite operating system path
  addTask('run', createProcessTask("/Applications/dart/chromium/Chromium.app/Contents/MacOS/Chromium",args:["web/out/${_name}.html"], description:"Run in Chromium."));

  runHop();
}
/*  
 *  TEMPLATE Hop Task
*/

Task createTemplateHopTask() {
  return new Task.sync((TaskContext ctx) {
    ctx.info(ctx.arguments.rest.toString());
    return true;
  });
}

""";
  }
  
  String _server(){
    return
"""
import 'dart:io';

_sendNotFound(HttpResponse response) {
  response.statusCode = HttpStatus.NOT_FOUND;
  response.close();
}

startServer(String basePath) {
  HttpServer.bind('127.0.0.1', 8080).then((server) {
    server.listen((HttpRequest request) {
      final Path path = new Path(request.uri.path).canonicalize();
      if (!path.isAbsolute) {
        _sendNotFound(request.response);
        return;
      }
      // PENDING: Do more security checks here?
      final String stringPath =
          path.toString() == '/' ? '/index.html' : path.toString();
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
  
  String _build(){
return
"""
import 'dart:io';
import 'package:polymer/component_build.dart';
 
// Ref: http://www.dartlang.org/articles/dart-web-components/tools.html
main() {
  build(new Options().arguments, ['web/${_name}.html']);
}
""";
  }
  
  String _elementdart(){
    return
"""
import 'package:polymer/polymer.dart';
 
@CustomTag("my-clickcounter")
class MyClickcounter extends PolymerElement 
                        with ObservableMixin {
  @observable
  int count = 0;
 
  void increment() {
    count++;
  }
}
""";
  }

  String _elementhtml(){
    return
"""
<!DOCTYPE html>
 
<html>
  <body>
    <polymer-element name="my-clickcounter" attributes="count">
      <template>
        <div>
          <button on-click="increment">Click me</button><br />
          <span>(click count: {{ count }})</span>
        </div>
      </template>
      <script type="application/dart" src="xclickcounter.dart"></script>
    </polymer-element>
  </body>
</html>
""";
  }
}