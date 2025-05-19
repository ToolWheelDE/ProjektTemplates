#!/bin/bash

# Funktion zur Anzeige der Hilfe
show_help() {
  echo "Verwendung: $0 <PfadZurSlnDatei> [-Path=Suchverzeichnis]"
  exit 1
}

# Überprüfe, ob mindestens ein Argument übergeben wurde
if [ $# -lt 1 ]; then
  show_help
fi

# Erstes Argument ist der Pfad zur SLN-Datei
solution_file="$1"
shift

# In absoluten Pfad umwandeln
solution_file=$(realpath "$solution_file")

# Standard: Verzeichnis der SLN-Datei
search_path=$(dirname "$solution_file")

# Verarbeite optionale Parameter
for arg in "$@"; do
  case $arg in
    -Path=*)
      search_path="${arg#*=}"
      shift
      ;;
    *)
      echo "Unbekannter Parameter: $arg"
      show_help
      ;;
  esac
done

# Erstelle das Verzeichnis, falls es nicht existiert
mkdir -p "$(dirname "$solution_file")"

# Erstelle die SLN-Datei, falls sie nicht existiert
if [ ! -f "$solution_file" ]; then
  echo "SLN-Datei existiert nicht. Erstelle neue SLN-Datei..."
  dotnet new sln -n "$(basename "$solution_file" .sln)" -o "$(dirname "$solution_file")"
fi

# Füge alle .csproj-Dateien zur SLN-Datei hinzu
find "$search_path" -name "*.csproj" -exec dotnet sln "$solution_file" add {} \;

echo "Alle .csproj-Dateien im Verzeichnis '$search_path' wurden zur Solution-Datei '$solution_file' hinzugefügt."
