#!/usr/bin/env bash

# Make symlinks
link() {
    echo "Symlink dotfiles to home directory? [y/N]"
    read resp
    if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
		ln -svf .vimrc $HOME/
        echo "Symlinking complete"
    else
        echo "Symlinking canceled"
        return 1
    fi
}

link_configurations() {
    echo "Symlink configuration files? [y/N]"
    read resp
    if [ "resp" = 'y' -o "$resp" = 'y' ] ; then
        for file in $(ls .config -A) ; do
	    config_directory="$HOME/.config"
	    full_file_path=$(readlink -f $file)
	    prefix="/home/jonark/dotfiles/"
	    link_path=${full_file_path#$prefix}
	    echo "$PWD/.config/$file" "$HOME/.config/$link_path"
	    ln -sdvf "$PWD/.config/$file" "$HOME/.config/"
        done
	echo "Symlinking configurations complete"
    else
        echo "Symlinking configurations canceled"
    fi
}

install_fish_agnoster() {
    echo "Install fish, omf and agnoster theme? [Y/n]"
    read resp
    if [ "$resp" != 'n' -o "$resp" != 'N' ] ; then
		sudo dnf install fish
		curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
		omf install agnoster
		chsh -s $(which fish)
    fi
	echo "fish set as default shell"
}

install_fish_agnoster
link
link_configurations

sudo dnf install tilix python3-pip ranger
