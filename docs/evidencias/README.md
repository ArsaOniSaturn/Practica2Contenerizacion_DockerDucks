# Evidencias de Docker y Kubernetes

Usá esta lista para organizar las capturas legibles y preparar el PDF de la práctica. Las evidencias Docker y Kubernetes indicadas en las tablas fueron capturadas y verificadas; el video, el PDF y la entrega final conservan sus estados explícitos más adelante.

## Datos de referencia

| Dato | Valor |
|---|---|
| Imagen | `practica2-api:v1` |
| Namespace | `practica2` |
| Service | `docker-ducks-api` |
| Puerto de la API | `8080` |
| Puerto local por port-forward | `18081` |
| NodePort | `30080` (dependiente del entorno) |

## Capturas de Docker

| Orden | Archivo recomendado | Comando o acción | Debe verse | Estado |
|---:|---|---|---|---|
| 1 | `01-docker-desktop-image.png` | Abrir Docker Desktop > Images. | La imagen `practica2-api:v1`, su etiqueta y tamaño. | Capturada y verificada |
| 2 | `02-docker-desktop-container.png` | Ejecutar el contenedor y abrir Docker Desktop > Containers. | El contenedor `practica2-api` en ejecución y el mapeo `8080:8080`. | Capturada y verificada |
| 3 | `03-terminal-docker-images-ps.png` | Ejecutar `docker images practica2-api:v1` y `docker ps --filter "name=practica2-api"`. | La imagen, el nombre del contenedor, el estado y los puertos publicados. | Capturada y verificada |
| 4 | `04-api-swagger-docker-1.png` y `04-api-swagger-docker-2.png` | Abrir `http://localhost:8080/swagger` y ejecutar `POST /api/rescue-reports`. | El request y la respuesta `201` con prioridad calculada en la interfaz Swagger. | Capturadas y verificadas |

## Capturas de Kubernetes

| Orden | Archivo recomendado | Comando o acción | Debe verse | Estado |
|---:|---|---|---|---|
| 1 | `05-k8s-pods.png` | Ejecutar `kubectl get pods -n practica2 -o wide`. | El pod de `docker-ducks-api` en estado `Running`/`Ready`, sin ocultar namespace ni reinicios. | Capturada y verificada |
| 2 | `06-k8s-service.png` | Ejecutar `kubectl get services -n practica2`. | El Service `docker-ducks-api`, el puerto `8080` y NodePort `30080` si el entorno lo muestra. | Capturada y verificada |
| 3 | `07-k8s-port-forward-api.png` | Mantener `kubectl port-forward -n practica2 service/docker-ducks-api 18081:8080` y abrir `http://localhost:18081/health`. | La terminal con el reenvío activo y la respuesta `Healthy` accesible por el puerto `18081`. | Capturada y verificada |
| 4 | `08-k8s-yaml-excerpts-1.png` y `08-k8s-yaml-excerpts-2.png` | Mostrar extractos legibles de `k8s/namespace.yaml`, `k8s/deployment.yaml` y `k8s/service.yaml`. | Namespace `practica2`, imagen `practica2-api:v1`, `IfNotPresent`, recursos, probes y Service `docker-ducks-api`. | Capturadas y verificadas |

> El NodePort `30080` depende de la red local. Si no está disponible, la evidencia de acceso debe usar el `port-forward` en `18081`.

## Orden sugerido para el video

No se asignan responsables todavía; confirmá los roles con el equipo antes de grabar.

1. Persona 1 presenta el objetivo y el flujo de priorización.
2. Persona 2 muestra el `POST` y la cola de reportes en Swagger.
3. Persona 3 muestra la imagen y el contenedor en Docker Desktop.
4. Persona 4 aplica los manifiestos y muestra pods y Service.
5. Persona 5 demuestra el acceso por `port-forward` y cierra con las limitaciones.

Video: `Pendiente de publicación`.

## Mapa para el PDF

| Sección | Contenido a incorporar | Estado |
|---|---|---|
| Proceso | Explicar el flujo: API local, imagen Docker, contenedor, namespace, deployment, Service y acceso por `port-forward`. | Pendiente de redacción |
| Problemas y soluciones | Documentar: `SIGBUS` de Docker corregido al reiniciar Docker Desktop; aplicar primero el namespace; NodePort no disponible y uso de `port-forward`; assets de NuGet de Windows corregidos con restore en Linux. | Pendiente de redacción |
| Responsabilidades | Registrar los aportes del equipo cuando estén confirmados. | Pendiente de confirmación |
| Reflexión técnica | Explicar aprendizajes y límites técnicos en un máximo de una página. | Pendiente de redacción |

## Lista de revisión antes de compartir

- [ ] Cada imagen es legible, tiene contexto suficiente y no expone datos privados, credenciales ni tokens.
- [ ] Las capturas muestran comandos, recursos y puertos necesarios sin información sensible.
- [ ] Los enlaces del README, el video cuando exista y el PDF abren para quienes deban revisarlos.
- [ ] El PDF conserva texto seleccionable, títulos claros y una reflexión técnica de máximo una página.
- [ ] Se agregó el colaborador `oalarconpe` y se verificó el acceso antes de enviar por Teams.
- [ ] No se presenta ninguna captura, enlace, video, PDF o entrega pendiente como si estuviera completada.
