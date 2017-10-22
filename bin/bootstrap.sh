host="$1"
if [[ ! "$host" ]]; then
    echo "Missing host!"
    exit 1
fi

ssh_call() {
    ssh -A "$host" "$@"
}

ssh_call passwd
# ssh_call apt install python
