function read_confirm -a prompt
    while true
        read -l -P "$prompt [y/N]: " confirm
        switch $confirm
            case y Y
                return 0
            case '' n N
                return 1
        end
    end
end

