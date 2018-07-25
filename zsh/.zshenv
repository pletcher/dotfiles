CABAL=$HOME/.cabal/bin
GO=$HOME/go/bin
GO_BIN=/usr/local/go/bin
LOCAL_BIN=$HOME/.local/bin
NODE_MODULES=$HOME/.config/yarn/global/node_modules/.bin
SBIN=/usr/local/sbin
YARN=$HOME/.yarn/bin

export N_PREFIX=$HOME/.n

N="$N_PREFIX/bin"

typeset -U path
path=(
	$CABAL
	$GO
	$GO_BIN
	$N
	$YARN
	$NODE_MODULES
	$LOCAL_BIN
	$SBIN
	$path[@]
)

