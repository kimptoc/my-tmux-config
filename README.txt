tmux full bundle

Contents:
- .tmux.conf
- .tmux/scripts/cpu.sh
- .tmux/scripts/mem.sh
- .tmux/scripts/battery.sh
- .tmux/scripts/uptime.sh
- .tmux/scripts/load.sh
- .tmux/scripts/net.sh

Install:
  cp .tmux.conf ~/
  mkdir -p ~/.tmux/scripts
  cp .tmux/scripts/*.sh ~/.tmux/scripts/
  chmod +x ~/.tmux/scripts/*.sh

Reload:
  tmux source-file ~/.tmux.conf

If NET still looks wrong on your machine:
  ip route
  cat /proc/net/dev
