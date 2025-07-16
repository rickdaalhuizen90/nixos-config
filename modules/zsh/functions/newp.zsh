newp() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: newp <template> <project_name>"
    echo "Available templates: phoenix, symfony, android-re"
    return 1
  fi

  local template_name=$1
  local project_name=$2

  echo "Creating new project '$project_name' from template '$template_name'..."
  nix flake new -t ~/.nixos-config#"${template_name}" "${project_name}"
  echo "Done. Change into '$project_name' and run 'direnv allow'."
}

