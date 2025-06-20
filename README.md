# dotfiles

[![Test Dotfiles Setup](https://github.com/ktakabay/dotfiles/actions/workflows/test.yml/badge.svg)](https://github.com/ktakabay/dotfiles/actions/workflows/test.yml)

macOS、Linux、WSL環境に対応した開発環境構築用dotfilesです。

## 🚀 クイックスタート

以下のコマンドを実行するだけで、開発環境が自動構築されます：

```bash
curl -fsSL https://raw.githubusercontent.com/ktakabay/dotfiles/main/install.sh | bash
```

または、手動でクローンしてインストール：

```bash
git clone https://github.com/ktakabay/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## 📋 含まれるもの

### シェル環境
- **ZSH** + [Powerlevel10k](https://github.com/romkatv/powerlevel10k) テーマ
- **[Sheldon](https://github.com/rossmacarthur/sheldon)** によるプラグイン管理

### 開発ツール
- **[Homebrew](https://brew.sh/)** パッケージマネージャー
- **[mise](https://github.com/jdx/mise)** ランタイムバージョン管理（Node.js、Python）
- **[tmux](https://github.com/tmux/tmux)** カスタム設定付き
- **[Neovim](https://neovim.io/)** デフォルトエディタ
- **[fzf](https://github.com/junegunn/fzf)** ファジーファインダー
- モダンなCLIツール: bat、eza、fd、navi

### 設定管理
- プラットフォーム別設定（macOS、Linux、WSL）
- 階層的な設定システム（共通設定 → プラットフォーム固有設定）
- 自動シンボリックリンク管理

## 🛠️ 手動インストール手順

自動インストールが失敗した場合は、以下の手順で実行してください：

1. **Homebrewのインストール**（未インストールの場合）：
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Sheldonのインストール**：
   ```bash
   curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
     | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
   ```

3. **セットアップの実行**：
   ```bash
   cd ~/dotfiles
   make all
   ```

## 🏗️ アーキテクチャ

### ディレクトリ構造
```
.
├── .bin/              # メインのdotfilesとBrewfiles
│   ├── .zshrc
│   ├── .vimrc
│   ├── .gitconfig
│   ├── .Brewfile.darwin
│   └── .Brewfile.linux
├── .config/           # XDG設定ディレクトリ
│   ├── common/        # 共通設定
│   ├── darwin/        # macOS固有設定
│   ├── linux/         # Linux固有設定
│   └── wsl/           # WSL固有設定
├── zsh/               # ZSH設定
└── install.sh         # インストールスクリプト
```

### プラットフォーム検出
セットアップは自動的にプラットフォームを検出します：
- **macOS**: Darwin固有の設定を使用
- **Linux**: 標準的なLinux設定
- **WSL**: Linux設定 + WSL固有設定（Windows統合）

## 🎯 カスタムコマンド

### tmux活用自作コマンド
- `claude-tilex` - 複数のtmuxペインでgit worktreeを作成（並列Claude作業用）
- `create_session_with_ghq` - ghqリポジトリでtmuxセッションを作成
- `navipopup` - naviチートシートのtmuxポップアップ

## 🔧 環境変数

以下の環境変数でインストールをカスタマイズできます：

- `DOTFILES_DIR` - dotfilesディレクトリ（デフォルト: `~/dotfiles`）
- `DOTFILES_REPO` - リポジトリURL
- `SHELDON_INSTALL_DIR` - Sheldonインストール先（デフォルト: `~/.local/bin`）
- `SKIP_CHSH` - ZSHへのシェル変更をスキップ（1に設定）
- `WINDOWS_USER` - WSL統合用Windowsユーザー名（デフォルト: `User`）

例：
```bash
SKIP_CHSH=1 DOTFILES_DIR=/custom/path ./install.sh
```

## 📝 インストール後の設定

インストール後に以下を実行してください：

1. **ターミナルを再起動**または以下を実行：
   ```bash
   exec zsh
   ```

2. **Powerlevel10kの設定**：
   ```bash
   p10k configure
   ```

3. **miseでランタイムをインストール**：
   ```bash
   mise install
   ```

## 🧪 テスト

このリポジトリにはmacOSとLinux環境の自動テストが含まれています：

```bash
# ローカルでテストを実行
make test

# テスト結果を確認
# https://github.com/ktakabay/dotfiles/actions
```
