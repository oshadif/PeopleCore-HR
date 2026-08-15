<div align="center">

# 👥 PeopleCore HR

### Full-Stack Human Resource Management System

A portfolio-grade HR platform for employee administration, attendance, leave, payroll, recruitment, performance reviews, role-based access, audit logging, backups and offline-friendly workflows.

![React](https://img.shields.io/badge/React-18-61DAFB?logo=react&logoColor=black)
![Node.js](https://img.shields.io/badge/Node.js-Express-339933?logo=nodedotjs&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-4169E1?logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)
![JWT](https://img.shields.io/badge/Auth-JWT-black?logo=jsonwebtokens)

</div>

---

## Overview

**PeopleCore HR** is a full-stack human-resource management application designed to demonstrate practical enterprise software engineering. It combines employee records, attendance, leave, payroll, recruitment and performance workflows with role-based security and auditability.

## Core Features

### Employee Management
- Employee profiles and employee numbers
- Departments and job titles
- Employment status and type
- Contact and emergency-contact information
- Salary records

### Attendance
- Employee clock-in / clock-out
- Daily attendance records
- Overtime tracking
- HR attendance management

### Leave Management
- Leave types and allowances
- Employee leave requests
- HR/admin approval and rejection flows
- Role-aware leave visibility

### Payroll
- Monthly payroll runs
- Base salary calculation
- Overtime calculation
- Tax calculation
- Employee payslips

### Recruitment
- Job openings
- Departments and locations
- Applicant tracking
- Recruitment-stage updates

### Performance
- Performance review periods
- Goals, skills and attendance scores
- Overall performance scoring
- Strengths and improvement notes

### Administration & Governance
- Admin / HR / employee roles
- JWT authentication
- Audit logs for important mutations
- Dashboard statistics
- Database backup and restore scripts
- Offline-friendly frontend shell

## Architecture

```text
React + Vite SPA
      │
      │ REST / JSON + JWT
      ▼
Node.js + Express API
      │
      ▼
PostgreSQL
```

## Tech Stack

| Layer | Technologies |
|---|---|
| Frontend | React, React Router, Vite |
| Backend | Node.js, Express.js |
| Database | PostgreSQL, pg |
| Authentication | JWT, bcryptjs |
| Deployment | Docker, Docker Compose |
| Operations | Backup / restore shell & PowerShell scripts |

## Quick Start

```bash
git clone https://github.com/oshadif/PeopleCore-HR.git
cd PeopleCore-HR
docker compose up --build
```

Local services:
- Frontend: `http://localhost:5176`
- Backend: `http://localhost:4003`

## Demo Accounts

**Admin:** `admin@demo.com` / `admin123`  
**HR Manager:** `hr@demo.com` / `hr123`  
**Employee:** `employee@demo.com` / `employee123`

> Demo credentials are for local portfolio use only.

## Security Notes

- Real secrets must never be committed.
- Replace the demo JWT secret in production.
- Replace all demo passwords before real use.
- Use HTTPS, rate limiting and secure database credentials in production.
- Payroll logic is demonstrative and should be adapted for applicable payroll/tax law before real-world use.

## Roadmap

- [ ] Production cloud deployment
- [ ] Automated test suite
- [ ] CI/CD
- [ ] Employee document upload workflows
- [ ] Advanced payroll rules
- [ ] Leave-balance calculations
- [ ] Reporting and analytics exports
- [ ] Email notifications
- [ ] Mobile-responsive refinements

## Author

**Oshadi Vidumini Fernando**  
Software Engineer · Full-Stack & Mobile Developer  
GitHub: [@oshadif](https://github.com/oshadif)
