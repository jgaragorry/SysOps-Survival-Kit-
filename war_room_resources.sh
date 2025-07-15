#!/bin/bash
echo -e "\n\e[1;41m WAR ROOM RESOURCES $(date) \e[0m"

# RAM: Top 5 procesos  
echo -e "\n\e[33m🔥 RAM TOP 5:\e[0m" 
ps -eo pid,user,%mem,cmd --sort=-%mem | head -6 | awk 'NR>1 {print "🧠 " $2 "\t" $3 "%\t" $4}'

# CPU: Procesos >30% 
echo -e "\n\e[33m🚀 CPU HEAVY (>30%):\e[0m"
ps -eo pid,user,%cpu,cmd --sort=-%cpu | awk '$3 > 30 && NR>1 {print "💻 " $2 "\t" $3 "%\t" $4}'

# DISCOS: Particiones críticas + alertas  
echo -e "\n\e[33m💾 DISK CRITICAL:\e[0m"
df -h | grep -E '/($|/var$|/data$)' | awk '{print $6 "\t" $5 "\t" $4 " free"}' | while read -r line; do
  usage=$(echo "$line" | awk -F'%' '{print $1}' | awk '{print $NF}')
  [ "$usage" -gt 85 ] && echo -n "⛔ " || echo -n "✅ "
  echo "$line"
done

# NET: Conexiones sospechosas  
echo -e "\n\e[33m🌐 NET SUSPECT:\e[0m"
netstat -tulnp 2>/dev/null | awk '$6 == "ESTABLISHED" && $5 !~ /:(80|443|22)/ {split($7, pid, "/"); print "🚨 " $5 " -> " pid[1] " (" $1 ")"}' | head -5
