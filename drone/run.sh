#!/bin/bash
dart tool/hop_runner.dart analyze_hop
rm -rf test
mkdir test
cd test

mkdir cla
cd cla
dart ../../tool/hop_runner.dart cla cla
pub install
dart tool/hop_runner.dart analyze_libs

cd ..
mkdir cpa
cd cpa
dart ../../tool/hop_runner.dart cpa cpa
pub install
dart tool/hop_runner.dart analyze_libs