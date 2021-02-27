#!/bin/sh

# Make symlinks
link() {
    echo "Symlink the files in this repo to the home directory? (y/n)"
    read resp
    if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
        for file in $( ls -A | grep -vE '\.exclude*|LICENSE|bin|\.git$|\.gitignore|.*.md' ) ; do
            ln -svf "$PWD/$file" "$HOME"
        done
        echo "Symlinking complete"
    else
        echo "Symlinking canceled"
        return 1
    fi
}

install_powerlevel10k() {
    echo "Installinz zsh"
    sudo pacman -Syu zsh --noconfirm
    echo "Installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    # Set zsh as default shell
    sudo chsh -s $(which zsh)
    sudo pacman -Syu community/ttf-meslo-nerd-font-powerlevel10k
}

link
# Install yarn
sudo pacman -Syu community/yarn community/nodejs community/npm extra/vim  --noconfirm

echo "Install python tools? (Y/n)"
read install_python_tools
if [ "$install_python_tools" = 'y' -o "$install_python_tools" = 'Y' ] ; then
    sh bin/python_tools_install.arch.sh
    echo "Python tools installed"
fi

echo "Install useful utilities? (Y/n)"
read install_utilities
if [ "$install_utilities" = 'y' -o "$install_utilities" = 'Y' ] ; then
    sh utilities_install.arch.exclude.sh
    echo "Utilities installed"
fi

install_powerlevel10k

echo "Opening themes download links"
xdg-open https://draculatheme.com/gtk/
xdg-open https://www.gnome-look.org/p/1356095/
xdg-open https://www.gnome-look.org/s/Gnome/p/1332404/
