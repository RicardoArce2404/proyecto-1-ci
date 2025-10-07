#!/usr/bin/env bash
javac -cp ".:../java-cup-11b-runtime.jar" *.java
&& echo "Compilation ended." \
&& java -cp ":../java-cup-11b-runtime.jar" Main \
&& echo "Exit parser."
