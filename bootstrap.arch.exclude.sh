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
    if [ "resp" != 'n' -o "$resp" != 'N' ] ; then
        for file in $(ls .config -A) ; do
	    config_directory="$HOME/.config"
	    full_file_path=$(readlink -f $file)
	    prefix="/home/jonark/dotfiles/"
	    link_path=${full_file_path#$prefix}
	    echo "$PWD/.config/$file" "$HOME/.config/$link_path"
	    ln -sdvf "$PWD/.config/$file" "$HOME/.config/"
        done
	ln -svf "$PWD/.config/i3/config" "$HOME/.config/i3/config"
	echo "Symlinking configurations complete"
    else
        echo "Symlinking configurations canceled"
    fi
}

install_powerlevel10k() {
    echo "Install zsh and powerlevel10k? [Y/n]"
    read resp
    if [ "$resp" != 'n' -o "$resp" != 'N'] ; then
        sudo pacman -Sy zsh --noconfirm
        echo "Installing oh-my-zsh"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
        # Set zsh as default shell
        sudo chsh -s $(which zsh)
        chsh -s $(which zsh)
        yay -S ttf-meslo-nerd-font-powerlevel10k
    fi
}

install_powerlevel10k
link
link_configurations
echo "Install Vim plugins dependencies? [Y/n]"
read resp
if [ "$resp" != 'n' -o "$resp" != 'N'] ; then
    # Install yarn
    sudo pacman -Syu community/yarn community/nodejs community/npm extra/vim  --noconfirm
fi

echo "Opening themes download links"
xdg-open https://draculatheme.com/gtk/
xdg-open https://www.gnome-look.org/p/1356095/
xdg-open https://www.gnome-look.org/s/Gnome/p/1332404/
