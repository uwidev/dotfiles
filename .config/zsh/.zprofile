# Auto-sourced at boot by a login shell after `~/.zshenv`
#
# Place tty environmental variables (envars) here, not .zshenv.
# See https://www.reddit.com/r/zsh/comments/sslfdf/move_most_things_to_zprofile_ie_why_use_zshenv/
#
# Graphical/compositor-specific envars should be placed in ~/.config/uwsm/env or
# ~/.config/uwsm/env-${desktop}. This is because Wayland compositor sessions are
# managed via universal wayland session manager (uwsm), and does not inherit
# variables defined here.
#
# ENVARS DEFINED HERE DO NOT PERSIST TO SYSTEMD-WRAPPED COMPOSITORS!!!

# Safe PATH operations
source ~/.env_functions

##################
### Set envars ###
##################
# Base XDGs
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

# Safely export XDG user dirs from user config
cat $HOME/.config/user-dirs.dirs |
sed '/^[A-Za-z_][A-Za-z0-9_]*=[^=]/!d' |
while IFS='\n' read -r line; do
    eval "export $line";
done

# Cleaning up home according to xdg-ninja
# Enforce applications to use dirs defined in env vars not clutter home dir
export ANDROID_USER_HOME="$XDG_DATA_HOME"/android
export HISTFILE="$XDG_STATE_HOME"/bash/history
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export X_CURSOR_PATH=/usr/share/icons:"$XDG_DATA_HOME"/icons
export LESSHISTFILE="$XDG_STATE_HOME"/less/history
export ZSH="$XDG_DATA_HOME"/oh-my-zsh
export NPM_USER_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
export WINEPREFIX="$XDG_DATA_HOME"/wine
export CUDA_CACHE_PATH="$XDG_DATA_HOME"/nv
export DOTNET_CLI_HOME="XDG_DATA_HOME"/dotnet
export NUGET_PACKAGES="$XDG_CACHE_HOME"/NuGetPackages
export PYENV_ROOT="$XDG_DATA_HOME"/pyenv
export PYTHONSTARTUP="$HOME"/python/pythonrc

# May cause problems with socket file, see archwiki.
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
# END xdg-ninja

export EDITOR=nvim
# export HYPRLAND_NO_SD_NOTIFY=1

# # For Firefox Nvidia VA-API Hardware Acceleration
# # See https://wiki.hyprland.org/Nvidia/#va-api-hardware-video-acceleration
# export MOZ_DISABLE_RDD_SANDBOX=1
# export LIBVA_DRIVER_NAME=nvidia
# export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/10_nvidia.json

#export ELECTRON_OZONE_PLATFORM_HINT=auto

# Vulkan use nvidia
# See https://wiki.archlinux.org/title/Vulkan#NVIDIA_-_vulkan_is_not_working_and_can_not_initialize
# export VK_DRIVER_FILES=/usr/share/vulkan/icd.d/nvidia_icd.json

################
### Sourcing ###
################
pathprepend "$XDG_DATA_HOME"/cargo/bin
pathprepend ~/.local/bin

# pyenv compatibility
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# # Nvidia
# export LIBVA_DRIVER_NAME=nvidia
# export GBM_BACKEND=nvidia-drm  # REMOVE IF FIREFOX CRASHES
# export __GLX_VENDOR_LIBRARY_NAME=nvidia
# export NVD_BACKEND=direct
# export VK_DRIVER_FILES=/usr/share/vulkan/icd.d/nvidia_icd.json

# #####################
# # From Hyprland env #
# #####################
#
# # XCursor fallback if app doesn't support server-side cursors
# export XCURSOR_PATH=~/.local/share/icons:/usr/share/icons
# export XCURSOR_THEME=Posy_Cursor_Black
# export XCURSOR_SIZE=32
#
# # Qt Theming Variables
# export QT_QPA_PLATFORM="wayland;xcb"
# export QT_QPA_PLATFORMTHEME=qt6ct
# export QT_STYLE_OVERRIDE=kvantum
# export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
#
# # QT_AUTO_SCREEN_SCALE_FACTOR=1
# # QT_ENABLE_HIGHDPI_SCALING=1
#
# # Fixes
# # Fix gamma correction for Electron applications
# # See https://wiki.archlinux.org/title/Font_configuration#Text_is_blurry
# export FREETYPE_PROPERTIES="cff:no-stem-darkening=0 autofitter:no-stem-darkening=0"
#
# # Force applications to use wayland
# export GDB_BACKEND=wayland,x11,*
# export SDL_VIDEODRIVER=wayland
# export CLUTTER_BACKEND=wayland
#
# # nvidia enablers
# LIBVA_DRIVER_NAME=nvidia
# __GLX_VENDOR_LIBRARY_NAME=nvidia
#
# # Fix electron apps... or at least try to
# ELECTRON_OZONE_PLATFORM_HINT=auto
#
# # Themeing
# # Cursor
# export HYPRCURSOR_THEME=Posys-Cursor-Scalable-Black
# export HYPRCURSOR_SIZE=24

###########################
### Desktop Environments ###
###########################

# Deprecated, simpler but less powerful setup for launching compositors
# # Make sure we're on the login shell and not ver ssh
# if [ -n "$(echo $0 | sed -n '/^-/p')" ] \
#   && [ -z "$(env | grep SSH_CONNECTION)" ] \
#   && [ $(tty | grep tty1) ]; then
#     Hyprland
# fi

# Place compositor into session.slice instead of default app.slice
USWM_USER_SESSION_SLICE=true

# # uwsm check may-start auto checks
# # Allows for selection of compositor
# if uwsm check may-start && uwsm select; then
#     exec systemd-cat -t uwsm_start uwsm start default
# fi

# Faster variant, cannot drop to tty
if uwsm check may-start; then
    exec uwsm start hyprland.desktop
fi
