function ytdl-playlist
    if test (count $argv) -eq 0
        echo "Usage: ytdl-playlist <playlist_url> <mode>"
        echo "Mode options: video | audio"
        return 1
    end

    set playlist_url $argv[1]
    set mode $argv[2]

    if test "$mode" != "video" -a "$mode" != "audio"
        set mode "video"
    end

    if test "$mode" = "video"
        set ytdl_args -o "%(uploader)s/%(playlist)s/%(playlist_index)03d - %(title)s.%(ext)s" -f "bestvideo"
    else
        set ytdl_args -o "%(uploader)s/%(playlist)s/%(playlist_index)03d - %(title)s.%(ext)s" -f "bestaudio" -x
    end

    yt-dlp $ytdl_args $playlist_url
end

