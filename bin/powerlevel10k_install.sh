#!/bin/sh
# Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
# Open browser to install recommended fonts for powerlevel10k
xdg-open https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k

