if status is-interactive
    # Commands to run in interactive sessions can go here
end
starship init fish | source

if status is-interactive
    alias ls='eza --icons'
    alias ll='eza -l --icons --git'
    alias cat='bat'
end
