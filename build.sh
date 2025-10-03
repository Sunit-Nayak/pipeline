#!/bin/bash
# Compile Java code
mkdir -p out
javac -d out src/HelloWorld.java

# Run the app
java -cp out HelloWorld
