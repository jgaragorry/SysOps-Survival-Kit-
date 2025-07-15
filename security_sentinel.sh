#!/bin/bash
echo -e "\n\e[1;41m🔒 SECURITY AUDIT $(date)\e[0m"

# SUID peligrosos (excluyendo comunes)
echo -e "\n\e[33m🔎 RISKY SUID/SGID:\e[0m"
find / -type f \( -perm -4000 -o -perm -2000 \) 2>/dev/null | grep -vE '/usr/(bin|sbin)/' | xargs ls -lh | awk '{print "⚠️  " $9}'

# Archivos críticos con permisos inseguros
echo -e "\n\e[33m📂 UNSAFE PERMISSIONS:\e[0m"
paths=("/etc/passwd" "/etc/shadow" "/etc/sudoers" "/crontab")
for p in "${paths[@]}"; do
  perms=$(stat -c "%a %n" "$p" 2>/dev/null)
  if [[ $perms =~ 7[0-7][0-7] ]]; then 
    echo "❌ $perms → WORLD WRITABLE!"
  fi
done

# Últimos logins root
echo -e "\n\e[33m👑 ROOT LOGINS (last 24h):\e[0m"
lastlog | grep root | grep "$(date +'%b %d')" | awk '{print "🕵️  " $1 " from " $3}'
