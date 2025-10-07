#!/usr/bin/env bash
echo "Compilando clases base..."
javac -cp ".:../java-cup-11b-runtime.jar" TablaSimbolos.java ManejadorErrores.java
