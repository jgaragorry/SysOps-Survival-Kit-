#!/bin/bash
echo -e "\n\e[1;42m🚀 DEPLOY HEALTH CHECK $(date)\e[0m"

# Servicios claves con nombres alternativos
services=("nginx" "apache2" "httpd" "postgres" "postgresql" "mysqld" "app-server")

# Verificar servicios usando diferentes métodos
for s in "${services[@]}"; do
    # Método 1: systemd
    if systemctl is-active "$s" >/dev/null 2>&1; then
        echo "✅ $s: RUNNING (systemd)"
        continue
    fi
    
    # Método 2: service
    if service "$s" status >/dev/null 2>&1; then
        echo "✅ $s: RUNNING (service)"
        continue
    fi
    
    # Método 3: procesos
    if pgrep -x "$s" >/dev/null; then
        echo "✅ $s: RUNNING (process)"
        continue
    fi
done

# Endpoints HTTP con validación de conectividad
endpoints=("http://localhost/health" "http://localhost:8080/status" "https://localhost/ready")

for e in "${endpoints[@]}"; do
    # Verificar si el endpoint es accesible
    if curl --output /dev/null --silent --head --fail --max-time 3 "$e"; then
        code=$(curl -s -o /dev/null -w "%{http_code}" "$e")
        [ "$code" == "200" ] && echo "🌐 $e: 200 OK" || echo "⚠️  $e: HTTP $code"
    else
        echo "🔴 $e: UNREACHABLE"
    fi
done

# Latencia de disco con validación
disk_paths=("/" "/var" "/home" "/tmp" "/data")
echo -e "\n⏱️  DISK LATENCY:"

if ! command -v ioping &> /dev/null; then
    echo "ℹ️  ioping not installed. Install with: sudo apt-get install ioping"
else
    for path in "${disk_paths[@]}"; do
        if [ -d "$path" ]; then
            echo -n "  $path: "
            ioping -c 3 "$path" 2>/dev/null | grep 'min/avg/max' | awk '{print $8 " ms"}'
        else
            echo "  ⚠️ $path: Not found"
        fi
    done
fi

# Verificación de puertos críticos
ports=("80" "443" "22" "5432" "3306")
echo -e "\n🔌 CRITICAL PORTS:"
for p in "${ports[@]}"; do
    if ss -tuln | grep ":$p" >/dev/null; then
        echo "  ✅ Port $p: LISTENING"
    else
        echo "  🔴 Port $p: CLOSED"
    fi
done
