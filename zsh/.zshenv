BIN=/bin
CABAL=$HOME/.cabal/bin
CARGO=$HOME/.cargo/bin
GO=$HOME/go/bin
GO_BIN=/usr/local/go/bin
JVM_BIN=/usr/lib/jvm/default/bin
LOCAL_BIN=$HOME/.local/bin
NIMBLE=$HOME/.nimble/bin
NODE_MODULES=$HOME/.node_modules/bin
YARN_MODULES=$HOME/.config/yarn/global/node_modules/.bin
export PYENV_ROOT=$HOME/.pyenv
RBENV_BIN=$HOME/.rbenv/bin
RBENV_SHIMS=$HOME/.rbenv/shims
SBIN=/usr/local/sbin
SUBLIME="/Applications/Sublime Text.app/Contents/SharedSupport/bin"
USR_LOCAL_BIN=/usr/local/bin
USR_BIN=/usr/bin
YARN=$HOME/.yarn/bin

export N_PREFIX=$HOME/.n

N="$N_PREFIX/bin"

export QMK_HOME=$HOME/code/qmk_firmware

typeset -U path
path=(
	$RBENV_SHIMS
	$RBENV_BIN
	$CARGO
	$CABAL
	$GO
	$GO_BIN
	$NIMBLE
	$NODE_MODULES
  $N
	$YARN
	$YARN_MODULES
	$PYENV_ROOT/bin
  $SUBLIME
	$LOCAL_BIN
  $USR_LOCAL_BIN
	$USR_BIN
	$BIN
	/usr/lib/jvm/default/bin
	/usr/bin/site_perl
	/usr/bin/vendor_perl
	/usr/bin/core_perl
	/var/lib/snapd/snap/bin
	$SBIN
	$path[@]
)

