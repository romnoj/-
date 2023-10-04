# Enable consistent sourcing on MacOS/Linux
emulate sh -c '. "$HOME/.profile"'
SKIP_PROFILE=1

CARGO_BIN="$HOME/.cargo/bin"
GO_BIN="$HOME/.golang/bin"

PATH="$CARGO_BIN:$GO_BIN:$PATH"
export PATH

export EDITOR="$CARGO_BIN/hx"
