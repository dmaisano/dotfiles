#!/usr/bin/fish

# ensure script is run as root user
# if not fish_is_root_user
#   sudo (status filename) $argv
#   exit $status
# end

# set fish as default shell
if string match -r -v -q '.*fish.*' "$SHELL"
  chsh -s (which fish)
end

rm -rf "$HOME/.config/starship.toml"
rm -rf "$HOME/.config/fish"
rm -rf "$HOME/.config/omf"
rm -rf "$HOME/.local/share/omf"
rm -rf "$HOME/.fnm"

mkdir -p "$HOME/.config/fish/completions"
mkdir -p "$HOME/.config/fish/conf.d"

eval fish "$PWD/scripts/fnm_install.fish"

curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install > omf_install
fish omf_install --noninteractive --path=~/.local/share/omf --config=~/.config/omf &
wait $last_pid

eval "source \"$HOME/.local/share/omf/init.fish\""

ln -sfn "$PWD/.config/omf/bundle" "$HOME/.config/omf/bundle"
ln -sfn "$PWD/.config/omf/channel" "$HOME/.config/omf/channel"
ln -sfn "$PWD/.config/omf/theme" "$HOME/.config/omf/theme"

eval "omf install"

eval "omf reload"

curl -sS https://starship.rs/install.sh | sh &
wait $last_pid
ln -sfn "$PWD/.config/starship.toml" "$HOME/.config/starship.toml"
ln -sfn "$PWD/.config/fish/config.fish" "$HOME/.config/fish/config.fish"

eval fish
