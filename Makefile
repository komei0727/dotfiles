all: link brew config

link:
	@.bin/link.sh

brew:
	@if [ "$$(uname)" = "Darwin" ]; then \
		echo "Installing packages for macOS..."; \
		brew bundle --file=.bin/.Brewfile.darwin; \
	else \
		echo "Installing packages for Linux/WSL..."; \
		brew bundle --file=.bin/.Brewfile.linux; \
	fi

config:
	@.config/link.sh