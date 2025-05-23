all: link brew config

link:
	@.bin/link.sh

brew:
	@brew bundle --global

config:
	@.config/link.sh