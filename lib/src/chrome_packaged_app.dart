part of project;

class ChromePackagedApp {
  String _name;
  Directory _dir;
  ChromePackagedApp(String name, Directory dir){
    _name = name;
    _dir = dir;
  }

  void build(TaskContext ctx) {
    Map _project = {
      "pubspec.yaml":_pubspec(),
      "app/background.js":_background(),
      "app/${_name}.css":_css(),
      "app/${_name}.dart":_main(),
      "app/${_name}.html":_html(),
      "app/${_name}.png":_icon(),
      "app/manifest.json":_manifest(),
      "tool/hop_runner.dart":_hop(),
      "build.dart":_build(),
      "README.md":_readme()
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
name: $_name
description: A sample chrome packaged application
dependencies:
  browser: any
  js: any
  hop: any
""";
  }
  
  String _background() {
    return 
"""
chrome.app.runtime.onLaunched.addListener(function(launchData) {
  chrome.app.window.create('${_name}.html', {
    'id': '_mainWindow', 'bounds': {'width': 800, 'height': 600 }
  });
});
""";
  }
  
  String _css(){
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

import 'package:js/js.dart' as js;

int boundsChange = 100;

/**
 * For non-trivial uses of the Chrome apps API, please see the 'chrome'
 * package.
 * 
 * http://pub.dartlang.org/packages/chrome
 * http://developer.chrome.com/apps/api_index.html
 */
void main() {
  query("#sample_text_id")
    ..text = "Click me!"
    ..onClick.listen(resizeWindow);
}

void resizeWindow(MouseEvent event) {
  var appWindow = js.context.chrome.app.window.current();
  var bounds = appWindow.getBounds();
  
  bounds.width += boundsChange;
  bounds.left -= boundsChange ~/ 2;
  
  appWindow.setBounds(bounds);
  
  boundsChange *= -1;
}
""";
  }
  
  List<int> _icon() {
      String icon64 = 
"""
iVBORw0KGgoAAAANSUhEUgAAANwAAADcCAYAAAAbWs+BAAAACXBIWXMAAAsTAAALEwEAmpwYAAAC
bmlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczpt
ZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNS4xLjIiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0
dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRl
c2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczp4bXA9Imh0dHA6Ly9ucy5h
ZG9iZS5jb20veGFwLzEuMC8iPgogICAgICAgICA8eG1wOkNyZWF0b3JUb29sPkFjb3JuIHZlcnNp
b24gMy4yLjE8L3htcDpDcmVhdG9yVG9vbD4KICAgICAgPC9yZGY6RGVzY3JpcHRpb24+CiAgICAg
IDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSIiCiAgICAgICAgICAgIHhtbG5zOnRpZmY9Imh0
dHA6Ly9ucy5hZG9iZS5jb20vdGlmZi8xLjAvIj4KICAgICAgICAgPHRpZmY6Q29tcHJlc3Npb24+
NTwvdGlmZjpDb21wcmVzc2lvbj4KICAgICAgICAgPHRpZmY6WVJlc29sdXRpb24+NzI8L3RpZmY6
WVJlc29sdXRpb24+CiAgICAgICAgIDx0aWZmOlhSZXNvbHV0aW9uPjcyPC90aWZmOlhSZXNvbHV0
aW9uPgogICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4K
0LCDxgAAGbZJREFUeAHtXcuPHMd97tmlSEoUxaEe0cuyRnFiJI4VD5NDEiCAZg9+IA6Q5S1wDtz9
C0jlnuwS8DkkT7kE2OEhCRAg4BLRwTBgcHQyECDRBPLBoSNzbEVy9LA4FB/iQ7ud75utEWdnu7uq
Z6p7anq/Anpnu+rXv/rV96uv69ndtTiOIwUhIATKQWChnGyUixAQAkRAhFM9EAIlIiDClQi2shIC
IpzqgBAoEQERrkSwlZUQEOFUB4RAiQiIcCWCrayEgAinOiAESkRAhCsRbGUlBEQ41QEhUCICIlyJ
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
""";
      icon64 = icon64.replaceAll(" ", "");
      return crypto.CryptoUtils.base64StringToBytes(icon64);
  }
  
  String _manifest(){
    return
"""
{
  "name": "${_name}",
  "version": "1",
  
  "manifest_version": 2,
  
  "icons": {"128": "${_name}.png"},
  
  "app": {
    "background": {
      "scripts": ["background.js"]
    }
  }
}
""";
  }
  
  String _build(){
    return
"""
import "dart:io";

/**
 * This build script watches for changes to any .dart files and copies the root
 * packages directory to the app/packages directory. This works around an issue
 * with Chrome apps and symlinks and allows you to use pub with Chrome apps.
 */
void main() {
  List<String> args = new Options().arguments;

  bool fullBuild = args.contains("--full");
  bool dartFilesChanged = args.any((arg) {
    return !arg.startsWith("--changed=app/packages") && arg.endsWith(".dart");
  });

  if (fullBuild || dartFilesChanged || args.isEmpty) {
    copyDirectory(directory('packages'), directory('app/packages'));
  }
}

Path directory(String path) => new Path(path);

void copyDirectory(Path srcDirPath, Path destDirPath) {
  Directory srcDir = new Directory.fromPath(srcDirPath);
  
  for (FileSystemEntity entity in srcDir.listSync()) {
    String name = new Path(entity.path).filename;
    
    if (entity is File) {
      copyFile(srcDirPath.join(new Path(name)), destDirPath);
    } else {
      copyDirectory(
          srcDirPath.join(new Path(name)),
          destDirPath.join(new Path(name)));
    }
  }
}

void copyFile(Path srcFilePath, Path destDirPath) {
  File srcFile = new File.fromPath(srcFilePath);
  File destFile = new File.fromPath(
      destDirPath.join(new Path(srcFilePath.filename)));
  
  if (!destFile.existsSync() || srcFile.lastModifiedSync() != destFile.lastModifiedSync()) {
    new Directory.fromPath(destDirPath).createSync(recursive: true);
    
    destFile.writeAsBytesSync(srcFile.readAsBytesSync());
  }
}

""";
  }
  
  String _readme(){
    return
"""
For more information about packaged apps, see
http://developer.chrome.com/apps/about_apps.html.

`web/manifest.json` describes the Chrome packaged application.

`web/background.js` is the entry point to the Chrome app; it launches
`web/cpa.html`.
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
    
    <!-- Currently, when deploying your Chrome app, you'll need to compile -->
    <!-- the Dart code to Javascript, remove the 'type' attribute below, and -->
    <!-- change the 'src' reference to the .dart.js file. -->
    <script src="${_name}.dart" type="application/dart"></script>
    
    <script src="packages/browser/dart.js"></script>
    <script src="packages/browser/interop.js"></script>
    <script src="packages/js/dart_interop.js"></script>
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
  var paths = ['app/${_name}.dart']; 

  addTask('docs', createDartDocTask(paths, linkApi: true));
  
  addTask('analyze_libs', createAnalyzerTask(paths));
  
  addTask('dart2js', createDartCompilerTask(paths, liveTypeAnalysis: true, allowUnsafeEval:false));
  
  runHop();
}
""";
  }
}