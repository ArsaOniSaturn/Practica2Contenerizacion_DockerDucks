# Build Wildlife Rescue Deployment

## Objective

Build and document a small ASP.NET Core REST API that registers wildlife rescue reports, assigns a business priority, and exposes a prioritized response queue. Package the API for Docker and deploy it to local Kubernetes according to the course practice.

## Problem and rationale

A generic animal CRUD would satisfy HTTP mechanics but would not demonstrate a meaningful applied capability. This feature focuses on one coherent workflow: rescue intake and automatic triage. The scope remains intentionally small because the assignment evaluates containerization and orchestration rather than a complete rescue-management platform.

## Scope

- Accept wildlife rescue reports with animal, location, condition, danger, and quantity data.
- Assign `Critical`, `High`, or `Medium` priority using deterministic business rules.
- Retrieve one report and list the queue ordered by priority and report time.
- Expose a health endpoint for Docker and Kubernetes checks.
- Provide automated tests for priority rules and API behavior.
- Provide a multi-stage Dockerfile and `.dockerignore`.
- Provide Kubernetes Namespace, Deployment, and Service manifests.
- Document reproducible commands and maintain an evidence checklist.

## Out of scope

- Generic update/delete operations.
- Rescue-team assignment.
- Full case-status workflows.
- Dashboards and analytics.
- External databases or production persistence.
- Cloud deployment.
- Video recording and final PDF generation during the source implementation phase.

## Constraints

- Runtime: .NET 8 / ASP.NET Core.
- Repository: `Practica2Contenerizacion_DockerDucks`.
- Branch: `feat/wildlife-rescue-prioritization`.
- Course namespace: `practica2`.
- Image tag: `practica2-api:v1`.
- Kubernetes image pull policy: `IfNotPresent`.
- Kubernetes resources must define CPU and memory requests and limits.
- Docker Desktop and its local Kubernetes cluster are available through WSL; direct NodePort access was not reachable, so the verified access method is `kubectl port-forward`.
- Do not fabricate screenshots or successful runtime evidence.

## Testing mode

- Mode: strict TDD.
- Source: explicit user choice.
- Runner: `dotnet test` with the Homebrew .NET 8 SDK.
- Required evidence for behavior work: observed RED, GREEN, and post-refactor GREEN.

## Delivery strategy

- Strategy: `ask-on-risk`.
- Initial forecast: approximately 360–400 authored changed lines, excluding generated build artifacts.
- Observed WRD-01 staged size: 567 added lines including the ODD tracker and generated solution/template files.
- Chain strategy: `feature-branch-chain`, selected by the user after the running count exceeded approximately 400 lines.
- Planned slices: WRD-01 API/tests; WRD-02 and WRD-03 deployment artifacts; WRD-04 documentation/evidence preparation.
- Push and pull request creation are not authorized.

## Tasks

- [x] **WRD-01 — Build the rescue intake API with strict TDD**
  - Route: delegated writer in the repository's dedicated Pi session.
  - Trigger: multi-file implementation and preparation; direct subagent dispatch was unavailable across independent Git repositories.
  - Implemented the solution, API, deterministic priority rules, thread-safe in-memory repository, endpoints, health check, OpenAPI, and automated tests.
  - TDD evidence: initial `dotnet test` failed on missing rescue types; minimum implementation passed 12/12 tests; explicit priority-rank refactor also passed 12/12.
  - Final independent verification: restore succeeded; 12/12 tests passed; build completed with 0 warnings and 0 errors.
  - Parent spot-check: `dotnet test DockerDucks.sln --no-restore` passed 12/12.
  - Commit: `b46c7fc` (`feat: add wildlife rescue prioritization API`).
  - Native assessment/review: native review declined for this candidate without creating a lineage; native assessment was schema-incompatible/unassessable, so the required independent verifier and parent spot-check form the verification record.

- [x] **WRD-02 — Containerize the verified API**
  - Route: delegated to `gentle-ai-worker`; independently verified by `gentle-ai-verify`.
  - Trigger: two non-trivial deployment files plus live Docker runtime verification.
  - Added a multi-stage .NET 8 Dockerfile and focused `.dockerignore`, using container port 8080 and non-root user 1654.
  - Live checks: `docker build -t practica2-api:v1 .` passed; image inspection passed; an ephemeral container served health, OpenAPI, report creation/retrieval, and the priority queue; 12/12 .NET tests passed.
  - Image evidence: `sha256:1dc4d45834d0c202f2026402bf3d66fe7bcf495d06177a26c1281426c092c824`, `8080/tcp`, `dotnet DockerDucks.Api.dll`, working directory `/app`.
  - Parent spot-check: image metadata confirmed the non-root user, exposed port, entrypoint, and work directory.
  - Runtime note: Docker Desktop required one user-performed restart after BuildKit/CLI `SIGBUS` failures; no Docker data reset or prune was used.
  - Commit: `957c826` (`build: containerize wildlife rescue API`).
  - Native assessment/review: RDD was off and native assessment was schema-incompatible/unassessable; the required high-risk fallback was satisfied by writer verification, independent live Docker verification, and the parent image-metadata spot-check.

- [x] **WRD-03 — Define the local Kubernetes deployment**
  - Route: delegated to `gentle-ai-worker`; independently verified by `gentle-ai-verify` against the live Docker Desktop cluster.
  - Trigger: three Kubernetes manifests plus live cluster mutation and HTTP verification.
  - Added Namespace, Deployment, and NodePort Service with coherent labels/selectors, `practica2-api:v1`, `IfNotPresent`, named port 8080, health probes, and required CPU/memory requests and limits.
  - Live checks: rollout succeeded; one pod is Ready/Running with zero restarts; Service exposes `8080:30080`; health, Swagger, POST 201, GET by id, and queue passed through `kubectl port-forward` on localhost:18081.
  - Parent spot-check: `kubectl get pods -n practica2 -o wide` and `kubectl get svc -n practica2` confirmed the running pod and Service.
  - Operational notes: apply `namespace.yaml` before Deployment and Service to avoid namespace-creation ordering; direct NodePort `localhost:30080` was not reachable from WSL/Windows, so documentation must use port-forward.
  - Known API documentation note: Swagger lists POST response 200 while runtime correctly returns 201; this does not block deployment acceptance and must be documented or corrected separately.
  - Commit: `27d9c56` (`deploy: add local Kubernetes manifests`).
  - Native assessment/review: RDD was off and native assessment was schema-incompatible/unassessable; writer validation, independent live-cluster verification, and the parent pod/Service spot-check satisfy the required high-risk fallback.

- [x] **WRD-04 — Document reproduction and evidence capture**
  - Route: delegated to `gentle-ai-worker`; independently verified by `gentle-ai-verify`.
  - Trigger: README plus evidence documentation.
  - Rewrote the Spanish README with the five confirmed members, API rules/endpoints, local/Docker/Kubernetes reproduction commands, verified ports, pending video state, collaborator reminder, and in-memory limitation.
  - Added `docs/evidencias/README.md` with every required Docker/Kubernetes capture, recommended filenames, pending statuses, five-person video order, PDF mapping, real incident history, and privacy/readability checks.
  - Checks: documentation-to-artifact consistency passed; internal paths resolve; `git diff --check` passed independently and in the parent spot-check.
  - Pending delivery facts remain explicit: screenshots, responsibility assignments, video URL, PDF, collaborator confirmation, and Teams submission.
  - Commit: `5a93d2d` (`docs: add reproduction and evidence guides`).
  - Native assessment/review: RDD was off and native assessment was schema-incompatible/unassessable; writer checks, independent documentation verification, and the parent diff-check satisfy the required high-risk fallback.

- [x] **EVD-01 — Capture Docker and Kubernetes visual evidence**
  - Route: inline, guided with the user because screenshots required the real Docker Desktop, terminal, and browser UI; runtime checks were independently delegated to `gentle-ai-verify`.
  - Captured all eight evidence items as ten PNG files: six single-image items and two split request/response or YAML-excerpt items.
  - Opened and verified every saved image for readability, required visible content, and absence of credentials or private notifications.
  - Updated `docs/evidencias/README.md` only after each corresponding image was observed.
  - Corrected a captured Swagger UI compatibility defect by upgrading Swashbuckle from 6.6.2 to 7.3.0; 12/12 tests, build, rebuilt Docker image, HTTP checks, and the final browser render passed.
  - Refreshed Docker Desktop kind's separate containerd image store before the final Kubernetes rollout; the corrected pod remained Running/Ready with zero restarts and the Service remained `8080:30080`.
  - Checks: file presence and image readability passed; checklist-to-filename consistency passed; Docker and Kubernetes runtime evidence passed.
  - Commits: `37a880e` (`fix: support OpenAPI 3.0.4 in Swagger UI`) and `5c85a64` (`docs: add verified deployment evidence`).
  - Native assessment/review: RDD was off and assessment was unassessable because the evidence images were untracked; the returned high-risk fallback was satisfied by writer/runtime checks, independent test/build/runtime and image verification, correction of the verifier's two documentation findings, final independent PASS, and parent visual spot-checks.

## Acceptance criteria

- A valid report receives a deterministic priority according to the documented rules.
- Invalid report data returns an appropriate client error.
- A report can be retrieved by identifier.
- The queue is ordered first by priority and then by oldest report time.
- OpenAPI/Swagger documents the public endpoints.
- `/health` returns a successful health response.
- Automated tests pass under .NET 8.
- Docker and Kubernetes artifacts satisfy every static requirement from the assignment.
- The README provides exact commands and ports without claiming unexecuted runtime success.
- The evidence checklist covers Docker Desktop, image/container terminal output, API access, pods, services, Kubernetes API access, and YAML excerpts.

## Progress and evidence

- 2026-09-28: Assignment and initial repository inspected.
- 2026-09-28: User selected ASP.NET Core on .NET 8.
- 2026-09-28: User approved the narrowed rescue intake and automatic prioritization capability.
- 2026-09-28: User authorized the feature branch and local work-unit commits, but not push or PR creation.
- 2026-09-28: User selected strict TDD with `dotnet test`.
- 2026-09-28: Homebrew .NET SDK 8.0.131 installed and verified.
- 2026-09-28: WRD-01 completed through strict RED/GREEN/refactor with 12 focused tests.
- 2026-09-28: Independent verification found ASP.NET Core test-package patch skew; `Microsoft.AspNetCore.Mvc.Testing` was aligned to 8.0.31.
- 2026-09-28: An interrupted NuGet download had produced multiple zero-byte manifests. Only user-authorized, confirmed relevant package-version directories were removed and redownloaded; the unrelated malformed `Microsoft.OpenApi` 1.6.14 cache entry was preserved.
- 2026-09-28: Final restore, test, build, and parent spot-check passed with 0 warnings and 0 errors.
- 2026-09-28: The WRD-01 staged slice contained 567 additions including planning and generated template files; the user selected `feature-branch-chain` for future review slices.
- 2026-09-28: WRD-01 was committed as `b46c7fc`. Native review was declined without lineage creation; assessment remained unassessable, so the successful independent verification and parent spot-check satisfy the returned high-risk fallback plan.
- 2026-09-28: WRD-02 added the Dockerfile and `.dockerignore`; the user also added `odd/` to `.gitignore`, which was explicitly preserved.
- 2026-09-28: Initial Docker verification was blocked by repeated Docker Desktop/WSL `SIGBUS` failures. A user-performed Docker Desktop restart restored the client/daemon without destructive cleanup.
- 2026-09-28: Image `practica2-api:v1` built successfully and passed live non-root container checks for health, Swagger, report creation/retrieval, and queue behavior; 12/12 tests remained green.
- 2026-09-28: WRD-02 was committed as `957c826`; native assessment was unassessable with RDD off, and the completed independent verifier plus parent spot-check satisfied the returned high-risk fallback plan.
- 2026-09-28: Docker Desktop Kubernetes was enabled with context `docker-desktop`; client-side validation and 12/12 .NET tests passed after regenerating Linux NuGet assets that had been overwritten with Windows paths.
- 2026-09-28: WRD-03 deployed Namespace, Deployment, Service, and one healthy pod. Direct NodePort access failed, but the course-accepted port-forward path passed health, Swagger, report creation/retrieval, and queue checks. Live resources remain running for screenshots.
- 2026-09-28: WRD-03 was committed as `27d9c56`; native assessment remained unassessable with RDD off, and the completed writer checks, independent verifier, and parent spot-check satisfied the returned fallback plan.
- 2026-09-28: Remote `origin/main` README commit `e4edacc` was merged as `66ea1ff`, preserving the five confirmed team members and GitHub accounts before the documentation rewrite.
- 2026-09-28: WRD-04 produced the Spanish reproduction README and evidence guide. Independent verification caught and confirmed correction of an unmapped root URL; final documentation verification and parent diff-check passed.
- 2026-09-28: WRD-04 was committed as `5a93d2d`; native assessment remained unassessable with RDD off, and writer checks, independent verification, and the parent spot-check satisfied the returned fallback plan.
- 2026-09-29: EVD-01 captured and visually verified all eight Docker/Kubernetes evidence items as ten PNG files.
- 2026-09-29: Evidence capture exposed a real Swagger UI/OpenAPI 3.0.4 incompatibility. Swashbuckle 7.3.0 fixed the browser render; 12/12 tests, build, Docker rebuild, and HTTP checks passed.
- 2026-09-29: Docker Desktop kind reused its old internal image with `IfNotPresent`; importing `practica2-api:v1` into the node's `k8s.io` containerd store and restarting the Deployment produced a corrected Running/Ready pod with zero restarts.
- 2026-09-29: EVD-01 passed final independent verification after correcting two documentation inconsistencies and recapturing Docker evidence 01–03 against the final image and container; commits `37a880e` and `5c85a64` preserve the fix and evidence.

## Next step

Confirm team responsibilities, record and publish the video, add its real URL to the README, and prepare the final PDF from the verified evidence.
