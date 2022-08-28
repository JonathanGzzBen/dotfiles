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

link_configurations() {
    echo "Symlink configuration files? [Y/n]"
    read resp
    if [ "resp" != 'n' -a "$resp" != 'N' ] ; then
        for file in $(ls .config -A) ; do
	    config_directory="$HOME/.config"
	    full_file_path=$(readlink -f $file)
	    prefix="/home/jonark/dotfiles/"
	    link_path=${full_file_path#$prefix}
	    echo "$PWD/.config/$file" "$HOME/.config/$link_path"
	    ln -sdvf "$PWD/.config/$file" "$HOME/.config/"
        done
	ln -svf "$PWD/.config/i3/config" "$HOME/.config/i3/config"
    ln -svf "$PWD/.config/Thunar/uca.xml" "$HOME/.config/Thunar/uca.xml"
    ln -svf "$PWD/.config/gtk-3.0/bookmarks" "$HOME/.config/gtk-3.0/bookmarks"
    ln -svf "$PWD/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
    mkdir "$HOME/sublime-text/Packages" -p
    ln -sf "$PWD/.config/sublime-text/Installed Packages" "$HOME/.config/sublime-text/Installed Packages"
    ln -sf "$PWD/.config/sublime-text/Packages/User" "$HOME/.config/sublime-text/Packages/User"
	echo "Symlinking configurations complete"
    else
        echo "Symlinking configurations canceled"
    fi
}

install_fish_agnoster() {
    echo "Install fish? and oh my fish? [Y/n]"
    read resp
    if [ "$resp" != 'n' -a "$resp" != 'N' ] ; then
        yay -S ttf-meslo-nerd-font-powerlevel10k powerline-fonts fish --noconfirm
        curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install > install
        fish install --path=~/.local/share/omf --config=~/.config/omf
        rm install
		chsh -s $(which fish)
    fi
	echo "fish set as default shell"
}

link
link_configurations

echo "Install Neovim? [Y/n]"
read resp
if [ "$resp" != 'n' -a "$resp" != 'N' ] ; then
    # Install yarn
    yay -S nodejs yarn npm neovim --noconfirm
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi

install_fish_agnoster

echo "Copy bin directory? [Y/n]"
read resp
if [ "$resp" != 'n' -a "$resp" != 'N' ] ; then
    echo "Copying bin to $HOME/bin"
    cp bin "$HOME/bin" -r
fi

yay -Sy emacs discount unzip

echo "Open theming links? [Y/n]"
read resp
if [ "$resp" != 'n' -a "$resp" != 'N' ] ; then
    echo "Opening themes download links"
    xdg-open https://draculatheme.com/gtk/
    xdg-open https://www.gnome-look.org/p/1356095/
    xdg-open https://www.gnome-look.org/s/Gnome/p/1332404/
fi
