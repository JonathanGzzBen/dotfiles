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
    sudo apt install zsh -y
    echo "Installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    # Set zsh as default shell
    chsh -s $(which zsh)
}

sudo apt update
install_powerlevel10k
link

echo "Install python tools? (Y/n)"
read install_python_tools
if [ "$install_python_tools" = 'y' -o "$install_python_tools" = 'Y' ] ; then
    sh bin/python_tools_install.sh
    echo "Python tools installed"
fi

echo "Install useful utilities? (Y/n)"
read install_utilities
if [ "$install_utilities" = 'y' -o "$install_utilities" = 'Y' ] ; then
    sh utilities_install.exclude.sh
    echo "Utilities installed"
fi

