#!/bin/bash

tmux attach -d -t 'Main' && exit
tmux new-session -d -s 'Main'
tmux new-window -t 'Main' -d
tmux attach -t 'Main'
