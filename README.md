# 🔥 SysOps Survival Kit - Herramientas Esenciales para Emergencias en Producción

**Colección de scripts de batalla probados en entornos críticos para monitoreo, diagnóstico y respuesta rápida**

> "Cuando la producción está en llamas, este kit será tu primera línea de defensa"

## 🚀 Por qué este kit

- **Emergencias listas**: Diseñado para war rooms y crisis de producción
- **Cero dependencias**: Funciona en cualquier Linux (Alpine a RHEL)
- **Salida accionable**: Información lista para decisiones críticas
- **Prevención proactiva**: Detecta problemas antes que escalen

## 🧰 Contenido del Kit

### 🔥 Monitoreo Crítico
| Script                  | Descripción                              | Uso típico                  |
|-------------------------|------------------------------------------|-----------------------------|
| `war_room_resources.sh` | Estado RAM/CPU/Disco/Red en tiempo real  | Incidentes de rendimiento   |
| `log_hunter.sh`         | Cazador de errores en logs              | Diagnóstico rápido          |
| `deploy_check.sh`       | Verificación post-implementación        | Validación de releases      |

### 🔒 Seguridad y Auditoría
| Script                  | Descripción                              |
|-------------------------|------------------------------------------|
| `security_sentinel.sh`  | Detección SUID/permisos peligrosos       |
| `user_audit.sh`         | Actividad sospechosa de usuarios         |
| `port_scout.sh`         | Detección de puertos inusuales           |

### ⚡ Herramientas de Diagnóstico
| Script                  | Descripción                              |
|-------------------------|------------------------------------------|
| `network_forensics.sh`  | Análisis rápido de tráfico               |
| `io_pressure.sh`        | Diagnóstico de presión de E/S            |
| `service_triage.sh`     | Verificación de servicios críticos       |

## 🛠️ Instalación Rápida

```bash
# Clonar repositorio
git clone https://github.com/tuusuario/SysOps-Survival-Kit.git
cd SysOps-Survival-Kit

# Dar permisos de ejecución
chmod +x scripts/*.sh

# Ejecutar directamente:
./scripts/war_room_resources.sh

# O instalar globalmente:
sudo cp scripts/*.sh /usr/local/bin/
