library hop_runner;

import 'dart:io';
import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';
import 'package:args/args.dart';
import 'package:toolshed/create_project_tasks.dart';

void main() {

  addTask('cpa', createChromePackagedApp());
  addTask('cla', createCommandLineApp());
  addTask('wa', createWebApp());
  addTask('pa', createPolymerApp());
  addTask('sxla', createStageXLApp());

  var pathS = [
	'lib/create_project_tasks.dart',
	'lib/src/chrome_packaged_app.dart',
	'lib/src/command_line_app.dart',
	'lib/src/polymer_project.dart',
	'lib/src/web_project.dart',
	'lib/src/stagexl_project.dart'
  ];

  addTask('analyze_hop', createAnalyzerTask(pathS));
  runHop(paranoid:false);
}

Task createHelloHopTask() {
  return new Task.sync((TaskContext ctx) {
    ctx.info(ctx.arguments.rest.toString());
    Directory dir = new Directory(".");
    print(dir.listSync().toString());
    return true;
  });
}

Task createHello2HopTask() {
  return new Task.sync((TaskContext ctx) {
    ctx.info(ctx.arguments.rest.toString());
    Directory dir = new Directory(".");
    print(dir.listSync().toString());
    return true;
  });
}

Task createChromePackagedApp() {
  return new Task.sync((TaskContext ctx) {
    ChromePackagedApp cpa = new ChromePackagedApp(ctx.arguments.rest[0], new Directory("."));
    cpa.build(ctx);
    return true;
  },description:"Create a Chrome Packaged App project.", config:_parserConfig);
}

Task createCommandLineApp() {
  return new Task.sync((TaskContext ctx) {
    CommandLineApp cla = new CommandLineApp(ctx.arguments.rest[0], new Directory("."));
    cla.build(ctx);
    return true;
  },description:"Create a Command Line App project.", config:_parserConfig);
}

Task createWebApp() {
  return new Task.sync((TaskContext ctx) {
    WebApp wa = new WebApp(ctx.arguments.rest[0], new Directory("."));
    wa.build(ctx);
    return true;
  },description:"Create a Web App project.", config:_parserConfig);
}

Task createPolymerApp() {
  return new Task.sync((TaskContext ctx) {
    PolymerApp pa = new PolymerApp(ctx.arguments.rest[0], new Directory("."));
    pa.build(ctx);
    return true;
  },description:"Create a Polymer Web App project.", config:_parserConfig);
}

Task createStageXLApp() {
  return new Task.sync((TaskContext ctx) {
    StageXLApp sxla = new StageXLApp(ctx.arguments.rest[0], new Directory("."));
    sxla.build(ctx);
    return true;
  },description:"Create a StageXL App project.", config:_parserConfig);
}

void _parserConfig(ArgParser parser) {
  parser.addFlag("blank", abbr:"b", help: "Create project skeleton, no sample content.");
}