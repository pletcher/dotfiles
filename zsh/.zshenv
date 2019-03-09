BIN=/bin
CABAL=$HOME/.cabal/bin
CARGO=$HOME/.cargo/bin
GO=$HOME/go/bin
GO_BIN=/usr/local/go/bin
JVM_BIN=/usr/lib/jvm/default/bin
LOCAL_BIN=$HOME/.local/bin
NIMBLE=$HOME/.nimble/bin
YARN_MODULES=$HOME/.config/yarn/global/node_modules/.bin
PYENV=$HOME/.pyenv/shims
RBENV_BIN=$HOME/.rbenv/bin
RBENV_SHIMS=$HOME/.rbenv/shims
SBIN=/usr/local/sbin
USR_LOCAL_BIN=/usr/local/bin
USR_BIN=/usr/bin
YARN=$HOME/.yarn/bin

export N_PREFIX=$HOME/.n

N="$N_PREFIX/bin"

typeset -U path
path=(
	$RBENV_SHIMS
	$RBENV_BIN
	$CARGO
	$CABAL
	$GO
	$GO_BIN
	$NIMBLE
	$N
	$YARN
	$YARN_MODULES
	$PYENV
	$LOCAL_BIN
	$USR_LOCAL_BIN
	$USR_BIN
	$BIN
	/usr/lib/jvm/default/bin
	/usr/bin/site_perl
	/usr/bin/vendor_perl
	/usr/bin/cor_perl
	/var/lib/snapd/snap/bin
	$SBIN
	$path[@]
)

