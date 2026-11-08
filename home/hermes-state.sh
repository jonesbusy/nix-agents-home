$DRY_RUN_CMD mkdir -p "$HOME/.hermes"
$DRY_RUN_CMD chmod 700 "$HOME/.hermes"
if [ ! -e "$HOME/.hermes/.env" ]; then
  $DRY_RUN_CMD touch "$HOME/.hermes/.env"
  $DRY_RUN_CMD chmod 600 "$HOME/.hermes/.env"
fi
