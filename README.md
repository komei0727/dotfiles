# シンボリックリンクの配置
ホームディレクトリにこのレポジトリを置き以下のコマンドを実行
```
$ cd ~/dotfiles
$ ./deploy.sh
```

# zshrc
## zinitのインストール
- プラグイン管理のためのツール
- `sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
`を実行
- `source ~/.zshrc'を実行するとプラグインがインストールされる

## powerlevel10k
- ターミナルの見た目を変えるプラグイン
- Nerd Fontsという種類のフォントを設定する必要がある
- おすすめは[HackGenNerd Console](https://qiita.com/tawara_/items/374f3ca0a386fab8b305)
- 使用しているターミナルでフォントを変更
- windows terminalの場合は[これ](https://marumalog.hatenablog.jp/entry/2020/12/13/162203)

# vimrc
## plug.vimのインストール
- [公式リポジトリ](https://github.com/junegunn/vim-plug)を参照
## PlugInstall
- vimを起動しコマンドで`:PlugInstall`と叩くとプラグインがインストールされる