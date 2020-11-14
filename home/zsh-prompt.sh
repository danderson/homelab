function _da_dynamic_prompt() {
    local branch
    branch="$(git_current_branch)"
    if [[ -n "$branch" ]]; then
	local dirty ahead behind summary
	[ -z "$(git status --porcelain | tail -1)" ] || dirty='!'
	ahead="$(ZSH_THEME_GIT_PROMPT_AHEAD=a git_prompt_ahead)"
	behind="$(ZSH_THEME_GIT_PROMPT_AHEAD=b git_prompt_behind)"
	summary="$ahead$behind$dirty"
	if [[ -n "$summary" ]]; then
	    summary="[$summary]"
	fi
	echo -n " %F{green}${branch}${summary}%f"
    fi

    if [[ "$SHLVL" > 1 ]]; then
	pkgs="$(echo "$PATH" | tr ':' '\n' | grep /nix/store | sed 's#^/nix/store/[a-z0-9]\+-##' | sed 's#-[0-9.]\+.*$##')"
	ls="$(echo -n $pkgs | wc -w)"
	case $ls in
	    0)
		echo -n " %B%F{yellow}subshell%f%b"
		;;
	    1)
		echo -n " %B%F{yellow}$pkgs%f%b"
		;;
	    *)
		echo -n " %B%F{yellow}nix-shell%f%b"
		;;
	esac
    fi
}

function make_prompt() {
    # Root is red, remote !root is amber, local !root is green.
    local host_color
    if [[ "$USER" == "root" ]]; then
        host_color='%F{red}'
    elif [[ -n "$SSH_CLIENT" || -n "$SSH2_CLIENT" ]]; then
        host_color='%F{yellow}'
    else
        host_color='%F{green}'
    fi

    # Show local user if not dave or root
    local user
    if [[ "$USER" != "dave" && "$USER" != "root" ]]; then
        user='$host_color%n%f%F{cyan}@%f'
    fi
    local host="$host_color%m%f"
    local dir='%B%F{blue}%3~%f%b'
    echo "${user}${host} ${dir}\$(_da_dynamic_prompt)> "
}
PROMPT="$(make_prompt)"
RPROMPT=""
