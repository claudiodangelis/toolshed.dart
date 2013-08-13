library hop_runner;

import 'dart:io';
import 'package:hop/hop.dart';
import 'package:args/args.dart';
import 'package:toolshed/create_project_tasks.dart';

void main() {
  
  addTask('cpa', createChromePackagedApp());
  addTask('cla', createCommandLineApp());
  addTask('wa', createWebApp());
  addTask('pa', createPolymerApp());
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
  },description:"Create a Chrome Packaged App project.");
}

Task createCommandLineApp() {
  return new Task.sync((TaskContext ctx) {
    CommandLineApp cla = new CommandLineApp(ctx.arguments.rest[0], new Directory("."));
    cla.build(ctx);
    return true;
  },description:"Create a Command Line App project.");
}

Task createWebApp() {
  return new Task.sync((TaskContext ctx) {
    WebApp wa = new WebApp(ctx.arguments.rest[0], new Directory("."));
    wa.build(ctx);
    return true;
  },description:"Create a Web App project.");
}

Task createPolymerApp() {
  return new Task.sync((TaskContext ctx) {
    PolymerApp pa = new PolymerApp(ctx.arguments.rest[0], new Directory("."));
    pa.build(ctx);
    return true;
  },description:"Create a Polymer Web App project.");
}