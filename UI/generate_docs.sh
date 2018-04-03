#!/bin/sh

rm -rf Code/LayerKit
rm -rf Docs/
mkdir Code/LayerKit
cp Pods/LayerKit/LayerKit.framework/Headers/* Code/LayerKit/
jazzy
