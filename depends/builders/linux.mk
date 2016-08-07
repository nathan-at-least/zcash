build_linux_SHA256SUM = sha256sum
build_linux_DOWNLOAD = wget --progress=dot --timeout=$(DOWNLOAD_CONNECT_TIMEOUT) --tries=$(DOWNLOAD_RETRIES) -nv -O
