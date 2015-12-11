# .zshrc

# Source global definitions
if [ -f /etc/zshrc ]; then
	. /etc/zshrc
fi
if [ -f ~/dotfiles/.rc ]; then
	. ~/dotfiles/.rc
fi

autoload -Uz colors && colors
autoload -Uz vcs_info
autoload -Uz add-zsh-hook
autoload -Uz is-at-least

zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*' max-exports 3
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f%m"
zstyle ':vcs_info:*' actionformats "%F{green}%c%u[%b|%F{red}%a%f]%f%m"

if is-at-least 4.3.10; then
	# git 用のフォーマット
	zstyle ':vcs_info:git:*' check-for-changes true
	zstyle ':vcs_info:git:*' stagedstr "+"    # %c で表示する文字列
	zstyle ':vcs_info:git:*' unstagedstr "!"  # %u で表示する文字列
fi

if is-at-least 4.3.11; then
	zstyle ':vcs_info:git+set-message:*' hooks \
		git-hook-begin \
		git-untracked \
		git-st\
		git-stash-count

	# フックの最初の関数
	# git の作業コピーのあるディレクトリのみフック関数を呼び出すようにする
	# (.git ディレクトリ内にいるときは呼び出さない)
	function +vi-git-hook-begin() {
		if [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]]; then
			# 0以外を返すとそれ以降のフック関数は呼び出されない
			return 1
		fi

		return 0
	}

	# untracked ファイル表示
	function +vi-git-untracked() {
		if [ -n "$(git ls-files --others --exclude-standard)" ]; then
			# unstaged (%u) に追加
			hook_com[unstaged]+='?'
		fi
	}

	# push していないコミットの件数表示
	function +vi-git-push-status() {
		if [[ "${hook_com[branch]}" != "master" ]]; then
			# master ブランチでない場合は何もしない
			return 0
		fi

		# push していないコミット数を取得する
		local -a ahead
		ahead=$(git rev-list origin/master..master 2>/dev/null \
			| wc -l \
			| tr -d ' ')

		if [[ "$ahead" -gt 0 ]]; then
			# misc (%m) に追加
			hook_com[misc]+="p${ahead}"
		fi
	}

	# リモートブランチ名とコミットの差を表示
	function +vi-git-st() {
		local ahead behind remote
		local -a gitstatus

		remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
			--symbolic-full-name 2>/dev/null)/refs\/remotes\/}

		# リモートトラッキングブランチがある場合のみ実行
		if [[ -n ${remote} ]] ; then
			ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
			(( $ahead )) && gitstatus+=( "${c3}+${ahead}${c2}" )

			behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
			(( $behind )) && gitstatus+=( "${c4}-${behind}${c2}" )

			hook_com[branch]="${hook_com[branch]} (${remote}${(j:/:)gitstatus})"
		fi
	}

	# stash 件数表示
	function +vi-git-stash-count() {
		local -a stash
		stash=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
		if [[ "${stash}" -gt 0 ]]; then
			# misc (%m) に追加
			hook_com[misc]+="s${stash}"
		fi
	}
fi

function _update_vcs_info_msg() {
    local -a messages

    LANG=en_US.UTF-8 vcs_info

	vcs_info_msg=""
    if [[ -n "$vcs_info_msg_0_" ]]; then
		# vcs_info で情報を取得した場合
		[[ -n "$vcs_info_msg_0_" ]] && messages+=( "%F{green}${vcs_info_msg_0_}%f" )
		[[ -n "$vcs_info_msg_1_" ]] && messages+=( "%F{yellow}${vcs_info_msg_1_}%f" )
		[[ -n "$vcs_info_msg_2_" ]] && messages+=( "%F{red}${vcs_info_msg_2_}%f" )

		# 間にスペースを入れて連結する
		vcs_info_msg="${(j: :)messages}"
	fi

	RPROMPT="$vcs_info_msg%{$reset_color%}"
}
add-zsh-hook precmd _update_vcs_info_msg

style_user="%F{214}"
style_host="%F{011}"
style_path="%F{green}"
style_chars="%F{white}"
if [[ -n "$SSH_TTY" ]] || [[ -n "$SSH_CLIENT" ]]; then
    # connected via ssh
    style_host="%F{197}"
elif [[ "$USER" == "root" ]]; then
    # logged in as root
    style_user="%F{197}"
fi

# Build the prompt
PS1="${style_user}%n%f" # Username
PS1+="${style_chars}@%f" # @
PS1+="${style_host}%m%f" # Host
PS1+="${style_chars}:%f" # :
PS1+="${style_path}%/%f" # Working directory
PS1+="${style_chars}\$%f " # $ (and reset color)

# カーソルが右まで来たらRPROMPTを消す
setopt transient_rprompt

# 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups
# ヒストリを共有
setopt share_history

# 補完
autoload -Uz compinit && compinit
# 補完候補を一覧表示
setopt auto_list
# TAB で順に補完候補を切り替える
setopt auto_menu
# 補完候補一覧でファイルの種別をマーク表示
setopt list_types
# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash
# スペルチェック
setopt correct
# ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
setopt mark_dirs
# 最後のスラッシュを自動的に削除しない
setopt noautoremoveslash

