setopt   notify autolist
setopt   longlistjobs pushd_silent
setopt   histignoredups
setopt   extendedglob rcquotes mailwarning csh_null_glob
setopt   always_to_end list_packed inc_append_history
setopt   hist_expire_dups_first
#setopt   warn_create_global
unsetopt bgnice equals

setopt promptsubst

export HISTSIZE=10000
export SAVEHIST=10000
export AWS_VAULT_BACKEND=secret-service
export AWS_KEYCLOAK_BACKEND=secret-service
