if [ -z "$SKIP_PROFILE" ]; then
	emulate sh -c '. "$HOME/.profile"'
else
	SKIP_PROFILE=
fi

# Assure autocomplete works in Ubuntu.
skip_global_compinit=1
