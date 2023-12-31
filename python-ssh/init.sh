#!/usr/bin/env bash
pk='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDk9CHNUH1AzRQlrnUp34PbhgJKMwygmGNOKdM+DPTY7vW6Gn/AehucUleNDThiyCYeUubyG5x4uzTC6V6Y2BFxF6LxK58VjCbjaKwGTKaredqpV0frtdMvBdMAhAGO8DiSaNXJz879itr1irujXiLezjQt8N6HbuR+HiOa9ucLe8w3cBj2y3QkflTp816et7LQtEgF7GGIb26fQlsK9RZUuuLtZgyZY1RAnT/vRiD2sIaroVPeE86MmiK9wSFq3Q6ZKm+EDxI1pZgkbLezcAJHkfdtPMaSN/2ZrsdiUvtqxIj60288dllalX6t4S4kgSAvfbxlNQ4bhSUrooBo4hn2bVoYVXRmSylVcauUtBjl913xGIa7HitZ1O8KDx6enkL5AlsFEHHzl0PJuA0tYqOvfKKBa5SpOCuKUzn9qqdF31Iu0zw2WQ42Mn940YBiD+p7RqAtfFPCamoS3GkzyZAKRlSKEcmwd6WiTzXaCadV8yPixIrHmQge8yv3QImEq0k= maihb@docker'
echo $pk >~/.ssh/authorized_keys
git config --global init.defaultBranch master
git config --global user.name "maihb"
git config --global user.email "maihb@cn"

echo "alias l='ls -alFh'" >>~/.bashrc
echo "alias la='ls -A'" >>~/.bashrc
echo "alias ll='ls -CalF'" >>~/.bashrc
echo "alias ls='ls -G'" >>~/.bashrc
echo "alias lsa='ls -lah'" >>~/.bashrc
echo "alias lt='ls -arhlt'" >>~/.bashrc
echo "alias t='tail -10f'" >>~/.bashrc
echo "alias gst='git status'" >>~/.bashrc
echo "alias py='python'" >>~/.bashrc
echo "set -o vi" >>~/.bashrc
