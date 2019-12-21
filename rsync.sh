rsync -chavzpglP --quiet --log-file=/tmp/rlog.gold2.$DATE --delete --delete-during /gold2 root@x.x.x.x:/

# RSYNC Usage:
# rsync [-chavzpgl --stats --log-file=/tmp/rlog.xx --delete [SRC]user@host:[DEST ]
# --delete option - This means if the file doesnot exist on source and delete
# on the destination server
# -c --checksum skip based on checksum, not mod-time & size
# -h --human-readable        output numbers in a human-readable format
# -a --archive               archive mode; equals -rlptgoD (no -H,-A,-X)
# -v --verbose               increase verbosity
# -z --compress              compress file data during the transfer
# -p --perms                 preserve permissions
# -g --group                 preserve group
# -l --links                 copy symlinks as symlinks
# -P                         same as --partial --progress
