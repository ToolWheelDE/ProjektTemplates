#!/bin/bash

# Überprüfe, ob der Pfad zur Solution-Datei angegeben wurde
if [ -z "$1" ]; then
  echo "Bitte den Pfad zur Solution-Datei angeben."
  exit 1
fi

# Pfad zur Solution-Datei
solution_file="$1"

# Ausgangsverzeichnis der Suche nach .csproj-Dateien
base_dir=$(dirname "$solution_file")

# Wechsel zum Ausgangsverzeichnis
cd "$base_dir" || exit

# Erstelle die Solution-Datei, falls sie nicht existiert
if [ ! -f "$solution_file" ]; then
  dotnet new sln -n $(basename "$solution_file" .sln)
fi

# Füge alle .csproj-Dateien zur Solution-Datei hinzu
find . -name "*.csproj" -exec dotnet sln "$solution_file" add {} \;

echo "Alle .csproj-Dateien wurden zur Solution-Datei $solution_file hinzugefügt."
