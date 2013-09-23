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
dart build.dart
dart tool/hop_runner.dart analyze_libs

cd ..
mkdir wa
cd wa
dart ../../tool/hop_runner.dart wa wa
pub install
dart tool/hop_runner.dart analyze_libs

cd ..
mkdir sxla
cd sxla
dart ../../tool/hop_runner.dart sxla sxla
pub install
dart tool/hop_runner.dart analyze_libs

cd ..
mkdir pa
cd pa
dart ../../tool/hop_runner.dart pa pa
pub install
dart build.dart
dart tool/hop_runner.dart analyze_libs

# Testing blank projects
mkdir cla_blank
cd cla_blank
dart ../../tool/hop_runner.dart cla --blank cla
pub install
dart tool/hop_runner.dart analyze_libs

cd ..
mkdir cpa_blank
cd cpa_blank
dart ../../tool/hop_runner.dart cpa --blank cpa
pub install
dart build.dart
dart tool/hop_runner.dart analyze_libs

cd ..
mkdir wa_blank
cd wa_blank
dart ../../tool/hop_runner.dart wa --blank wa
pub install
dart tool/hop_runner.dart analyze_libs

cd ..
mkdir sxla_blank
cd sxla_blank
dart ../../tool/hop_runner.dart sxla --blank sxla
pub install
dart tool/hop_runner.dart analyze_libs

cd ..
mkdir pa_blank
cd pa_blank
dart ../../tool/hop_runner.dart pa --blank pa
pub install
dart build.dart
dart tool/hop_runner.dart analyze_libs
