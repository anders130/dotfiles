#!/usr/bin/fish

function dlh --argument url
    if test -z "$url"
        echo "Usage: dlh <URL>"
        return 1
    end

    # Extract scheme (http/https) and host from the URL
    set -l scheme (echo "$url" | sed -E 's#^([^:]+)://.*#\1#')
    set -l host (echo "$url" | sed -E 's#^[^:]+://([^/]+).*#\1#')
    set -l base_domain (echo "$host" | sed -E 's#^[^.]+\.([^.]+\.[^.]+)$#\1#')
    set -l referer_url "$scheme"://"$base_domain"/

    yt-dlp "$url" \
        --add-header "Accept: */*" \
        --add-header "Accept-Language: en-US,en;q=0.8,hu;q=0.7" \
        --add-header "Cache-Control: no-cache" \
        --add-header "Connection: keep-alive" \
        --add-header "Pragma: no-cache" \
        --add-header "Range: bytes=0-" \
        --add-header "Referer: $referer_url" \
        --add-header "Sec-Fetch-Dest: video" \
        --add-header "Sec-Fetch-Mode: no-cors" \
        --add-header "Sec-Fetch-Site: same-site" \
        --add-header "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0" \
        --add-header "sec-ch-ua-mobile: ?0"
end
