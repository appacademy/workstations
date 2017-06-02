ADMIN_ROOT="/Users/appacademy/.workstation-admin"

# normalize path
echo "$PATH" | grep "/usr/local/bin" > /dev/null || export PATH="/usr/local/bin:$PATH"

# load standard terminal profile
source /Users/appacademy/.bash_profile

admin() {
  if [[ $# = '0' ]]; then
    cd "$ADMIN_ROOT"
  elif [[ $# = '1' ]] && [[ -d "$ADMIN_ROOT/$1" ]]; then
    cd "$ADMIN_ROOT/$1"
  else
    "$ADMIN_ROOT/$@"
  fi
}
