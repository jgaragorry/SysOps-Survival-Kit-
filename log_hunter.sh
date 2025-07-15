#!/bin/bash
echo -e "\n\e[1;41m🪓 LOG HUNTER $(date +'%Y-%m-%d %H:%M')\e[0m"

# Función mejorada para búsqueda de logs
critical_logs() {
    local title="$1"
    local pattern="$2"
    local log_path="$3"
    
    echo -e "\n\e[33m🔍 $title:\e[0m"
    
    # Verificar si el log existe
    if [ ! -e "$log_path" ]; then
        echo "  ⚠️ Log not found: $log_path"
        return
    fi
    
    # Manejar logs binarios y comprimidos
    if file "$log_path" | grep -q "gzip compressed"; then
        zcat "$log_path" | grep -aiE "$pattern" | tail -n 8 | sed 's/^/  ▸ /'
    elif file "$log_path" | grep -q "binary"; then
        journalctl -q -b -S "24 hours ago" -u "$(basename "$log_path" .log)" | grep -aiE "$pattern" | tail -n 8 | sed 's/^/  ▸ /'
    else
        grep -aiE "$pattern" "$log_path" | tail -n 8 | sed 's/^/  ▸ /'
    fi
}

# Configuración de logs principales
declare -A LOG_CONFIG=(
    ["AUTH_FAILURES"]="failed|invalid|denied /var/log/auth.log"
    ["SSH_ATTEMPTS"]="sshd.*(invalid|failed) /var/log/auth.log"
    ["APP_ERRORS"]="error|exception|timeout|fatal /var/log/app.log"
    ["CRON_FAILS"]="cron.*(FAILED|status:1|error) /var/log/syslog"
    ["KERNEL_PANIC"]="kernel.*(panic|oops|segfault) /var/log/kern.log"
    ["SYSTEMD_FAILS"]="systemd.*(failed|dependency) /var/log/syslog"
    ["HIGH_LOAD"]="load average /var/log/syslog"
)

# Búsqueda en logs configurados
for key in "${!LOG_CONFIG[@]}"; do
    pattern="${LOG_CONFIG[$key]% *}"
    log_path="${LOG_CONFIG[$key]##* }"
    critical_logs "$key" "$pattern" "$log_path"
done

# Búsqueda adicional en logs recientes
echo -e "\n\e[33m🔥 RECENT SYSTEM ERRORS (last 30 min):\e[0m"
find /var/log -type f -mmin -30 \( -name "*.log" -o -name "messages" \) -exec grep -aiE 'err|fail|crit|alert|emerg' {} + | tail -n 5 | sed 's/^/  ▸ /'

# Verificación de logs rotados
echo -e "\n\e[33m🔄 ROTATED LOGS CHECK:\e[0m"
logrotate -d /etc/logrotate.conf 2>&1 | grep -q "error" && echo "  ❌ Logrotate errors detected!" || echo "  ✅ Logrotate configuration OK"
