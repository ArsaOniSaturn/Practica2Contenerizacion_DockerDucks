# Docker Ducks — guía de reproducción

API REST para registrar rescates de fauna silvestre y priorizarlos automáticamente como `Critical`, `High` o `Medium`. Esta guía permite ejecutar la práctica localmente, en Docker y en Kubernetes sin asumir que las evidencias, el video, el PDF o la entrega ya estén completos.

## Integrantes

| Nombre completo | Usuario GitHub |
|---|---|
| Juan David Velasquez Murillo | `Juandavm12` |
| Alejandra Madrid Calderon | `alejamc14` |
| Sara Regino Ferraro | `ArsaOniSaturn` |
| Jose David Vasquez | `jvas04` |
| Paula Andrea Calderon Quintero | `paucq` |

## Ruta rápida

1. Instalá .NET 8, Docker Desktop, Kubernetes habilitado en Docker Desktop y `kubectl`.
2. Ejecutá la API localmente o construí la imagen Docker.
3. Aplicá Kubernetes en el orden indicado y accedé mediante `port-forward`.
4. Consultá la [lista de evidencias](docs/evidencias/README.md) antes de capturar material o preparar el PDF.

## Funcionalidad de la API

Cada reporte recibe una prioridad determinística:

| Regla | Prioridad |
|---|---|
| `condition` es `Critical` o `immediateDanger` es `true` | `Critical` |
| `condition` es `Injured` y no hay peligro inmediato | `High` |
| `condition` es `Stable` y no hay peligro inmediato | `Medium` |

Los campos de texto, `condition` y una `quantity` mayor que cero son obligatorios. La cola se ordena por prioridad (`Critical`, `High`, `Medium`) y luego por el reporte más antiguo.

| Método | Endpoint | Resultado esperado |
|---|---|---|
| `POST` | `/api/rescue-reports` | Crea un reporte y responde `201 Created`. |
| `GET` | `/api/rescue-reports/queue` | Devuelve la cola priorizada. |
| `GET` | `/api/rescue-reports/{id}` | Devuelve un reporte o `404 Not Found`. |
| `GET` | `/health` | Expone el estado de salud. |
| `GET` | `/swagger` | Abre la interfaz Swagger. |

Ejemplo válido para `POST /api/rescue-reports`:

```json
{
  "animalDescription": "Zarigüeya adulta",
  "municipalitySector": "Parque del barrio",
  "situationDescription": "Presenta una lesión en una pata",
  "condition": "Injured",
  "immediateDanger": false,
  "quantity": 1
}
```

> **Limitación:** los reportes se guardan solo en memoria. Se pierden al reiniciar la API, el contenedor o el pod.

## Ejecución local

Desde la raíz del repositorio:

```bash
dotnet restore DockerDucks.sln
dotnet run --project src/DockerDucks.Api --urls http://localhost:8080
dotnet test DockerDucks.sln --no-restore
```

Con la aplicación en ejecución, verificá `http://localhost:8080/health` y `http://localhost:8080/swagger`.

## Docker

Construí la imagen versionada:

```bash
docker build -t practica2-api:v1 .
docker images practica2-api:v1
```

Iniciá y listá el contenedor:

```bash
docker run -d -p 8080:8080 --name practica2-api practica2-api:v1
docker ps --filter "name=practica2-api"
```

En otra terminal, verificá `http://localhost:8080/health` y `http://localhost:8080/swagger`. Para limpieza opcional, detené y eliminá el contenedor cuando ya no necesites las evidencias:

```bash
docker stop practica2-api
docker rm practica2-api
```

## Kubernetes

Aplicá los manifiestos **en este orden**: primero el namespace, luego el deployment y por último el service.

```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

Comprobá el despliegue:

```bash
kubectl rollout status deployment/docker-ducks-api -n practica2
kubectl get pods -n practica2
kubectl get services -n practica2
```

Acceso verificado para la práctica: mantené este comando abierto y navegá a `http://localhost:18081/swagger`; también podés comprobar salud en `http://localhost:18081/health`.

```bash
kubectl port-forward -n practica2 service/docker-ducks-api 18081:8080
```

El Service también declara NodePort `30080`, pero su acceso depende del entorno; si `localhost:30080` no responde, usá `port-forward` como ruta de acceso.

| Elemento | Propósito |
|---|---|
| Namespace `practica2` | Aísla los recursos de la práctica. |
| Imagen `practica2-api:v1` | Identifica la versión local que debe desplegarse. |
| `imagePullPolicy: IfNotPresent` | Reutiliza la imagen local si ya está disponible en el clúster. |
| Requests y limits | Reservan y acotan CPU y memoria del contenedor. |
| Readiness y liveness probes | Consultan `/health` para publicar tráfico y detectar fallas. |

## Entregables pendientes

- Video: `Pendiente de publicación`.
- Agregá al colaborador `oalarconpe`.
- Verificá que los enlaces y el PDF sean accesibles antes de enviarlos por Teams.
- Registrá las capturas y el contenido del PDF en la [lista de evidencias](docs/evidencias/README.md).
