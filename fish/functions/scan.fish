# Leak scanning
function scan
    if command -q trufflehog
        trufflehog git file://.
    else
        echo -e "\x1b[33m/!\\ \x1b[0mWarning Trufflehog is not installed \x1b[33m/!\\ \x1b[0m"
    end
    if command -q gitleaks
        gitleaks detect --source . -v
    else
        echo -e "\x1b[33m/!\\ \x1b[0mWarning Gitleaks is not installed \x1b[33m/!\\ \x1b[0m"
    end
end
