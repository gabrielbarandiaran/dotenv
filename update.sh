#!/bin/bash

echo "🔄 Updating Homebrew..."
brew update
brew upgrade
brew cleanup

echo "🔄 Updating global npm packages..."
npm update -g

echo "🔄 Updating Go tools..."
# Reinstall with latest versions (Go install will overwrite old binary in $GOPATH/bin):
go install github.com/ramya-rao-a/go-outline@latest
go install github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest
go install github.com/acroca/go-symbols@latest
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest

echo "✅ All tools updated!"
