## dotfiles盆栽

## 利用方法
### 1. sheldonとHomebrewのインストール
- shelldon
```
% curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
    | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
```
- Homebrew
```
% /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. 環境構築
下記コマンドで一括で環境構築が可能
```
% make all
```