#!/bin/bash

VERSION="v0.1.0"


show_help() {
    echo "Usage: sysopctl [COMMAND] [OPTIONS]"
    echo "Commands:"
    echo "  service list             List all active services."
    echo "  service start <name>     Start a specified service."
    echo "  service stop <name>      Stop a specified service."
    echo "  system load              Show current system load averages."
    echo "  disk usage               Show disk usage statistics."
    echo "  process monitor          Monitor system processes."
    echo "  logs analyze             Analyze system logs."
    echo "  backup <path>           Backup specified files or directories."
    echo "  --help                   Show this help message."
    echo "  --version                Show version information."
}


show_version() {
    echo "sysopctl version $VERSION"
}


list_services() {
    systemctl list-units --type=service --state=running
}


show_load() {
    uptime
}


check_disk_usage() {
    df -h
}


monitor_processes() {
    top
}


analyze_logs() {
    journalctl -p crit -b
}


backup_files() {
    if [ -d "$1" ]; then
        rsync -a "$1" ~/backup/
        echo "Backup of $1 initiated."
    else
        echo "Invalid path: $1"
    fi
}


if [[ "$1" == "--help" ]]; then
    show_help
elif [[ "$1" == "--version" ]]; then
    show_version
elif [[ "$1" == "service" ]]; then
    case "$2" in
        list)
            list_services
            ;;
        start)
            systemctl start "$3"
            echo "Started service: $3"
            ;;
        stop)
            systemctl stop "$3"
            echo "Stopped service: $3"
            ;;
        *)
            echo "Invalid service command."
            ;;
    esac
elif [[ "$1" == "system" && "$2" == "load" ]]; then
    show_load
elif [[ "$1" == "disk" && "$2" == "usage" ]]; then
    check_disk_usage
elif [[ "$1" == "process" && "$2" == "monitor" ]]; then
    monitor_processes
elif [[ "$1" == "logs" && "$2" == "analyze" ]]; then
    analyze_logs
elif [[ "$1" == "backup" ]]; then
    backup_files "$2"
else
    echo "Invalid command. Use --help for usage information."
fi
