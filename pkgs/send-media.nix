{
    openssh,
    rsync,
    writeShellApplication,
    fileWatcherService ? "media-mover.service",
    destinationPath ? "/home/admin/public",
    sshAddress ? "", # user@host, set via .override
}:
writeShellApplication {
    name = "send-media";
    runtimeInputs = [openssh rsync];
    text = ''
        if [ "$#" -lt 2 ]; then
            echo "usage: send-media <path> <target-subdir>"
            echo "example: send-media movie.mkv movies        (sends file)"
            echo "example: send-media ./folder movies          (sends folder as subfolder)"
            echo "example: send-media ./folder/ stash          (sends folder contents, trailing /)"
            exit 1
        fi

        SRC="$1"
        DEST_SUBDIR="$2"

        # rsync convention: trailing slash = send contents, no slash = send folder itself
        rsync -avP --remove-source-files --mkpath \
            "$SRC" "${sshAddress}:${destinationPath}/$DEST_SUBDIR/"
        ssh "${sshAddress}" sudo systemctl start "${fileWatcherService}"

        # clean up empty directories left behind by --remove-source-files
        SRC_DIR="$1"
        if [ -d "$SRC_DIR" ]; then
            find "$SRC_DIR" -type d -empty -delete 2>/dev/null || true
        else
            find "$(dirname "$SRC_DIR")" -type d -empty -delete 2>/dev/null || true
        fi
    '';
}
