# Architettura

- Frontend: Vue 3 + Vite (S3/CloudFront in prod)
- Backend (v2): Spring Boot su App Runner/ECS + RDS Postgres
- PDF (v1.1): Lambda Chrome headless → S3 (presigned URL)
- IaC: Terraform
- CI/CD: GitHub Actions
