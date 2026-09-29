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
- Docker Desktop became available through WSL during WRD-02 and now supports live image/container verification; Kubernetes CLI availability remains to be confirmed for WRD-03.
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
  - Commit: pending.
  - Native assessment/review: pending after the work-unit commit.

- [ ] **WRD-03 — Define the local Kubernetes deployment**
  - Route: delegated to `gentle-ai-worker`.
  - Trigger: multiple Kubernetes manifests.
  - Add Namespace, Deployment, and Service resources with coherent labels/selectors, versioned image, `IfNotPresent`, health probes, and resource requests/limits.
  - Checks: structural YAML validation where available; live `kubectl` checks remain pending until Docker Desktop Kubernetes is available.
  - Commit: pending.
  - Native assessment/review: pending.

- [ ] **WRD-04 — Document reproduction and evidence capture**
  - Route: delegated to `gentle-ai-worker`.
  - Trigger: README plus evidence documentation.
  - Write the Spanish README with technology, endpoints, ports, commands, team placeholders or confirmed names, video placeholder, and exact validation steps.
  - Add a Spanish evidence checklist naming every required Docker and Kubernetes capture without fabricating results.
  - Checks: documentation-to-code consistency and link/path checks.
  - Commit: pending.
  - Native assessment/review: pending.

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

## Next step

Commit the verified WRD-02 slice, assess the committed range, then begin WRD-03 by confirming Kubernetes tooling and adding Namespace, Deployment, and Service manifests.
