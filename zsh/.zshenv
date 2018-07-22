CABAL=$HOME/.cabal/bin
GO=$HOME/go/bin
GOBIN=/usr/local/go/bin
LOCALBIN=$HOME/.local/bin
NODE_MODULES=$HOME/.config/yarn/global/node_modules/.bin
SBIN=/usr/local/sbin
YARN=$HOME/.yarn/bin

export N_PREFIX=$HOME/.n

N="$N_PREFIX/bin"

typeset -U path
path=(
	$CABAL
	$GO
	$GOBIN
	$N
	$YARN
	$NODE_MODULES
	$LOCAL_BIN
	$SBIN
	$path[@]
)

