#!/bin/sh

# Make symlinks
link() {
    echo "Symlink the files in this repo to the home directory? (y/n)"
    read resp
    if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
        for file in $( ls -A | grep -vE '\.exclude*|\.git$|\.gitignore|.*.md' ) ; do
            ln -sv "$PWD/$file" "$HOME"
        done
        echo "Symlinking complete"
    else
        echo "Symlinking canceled"
        return 1
    fi
}

install_powerlevel10k() {
    #sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed 's:env zsh::g' | sed 's:chsh -s .*$::g')"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>! ~/.zshrc
}

install_powerlevel10k
link

