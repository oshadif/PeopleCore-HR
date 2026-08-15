CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS departments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(120) UNIQUE NOT NULL,
  manager_name VARCHAR(120),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS job_titles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  department_id UUID REFERENCES departments(id) ON DELETE SET NULL,
  title VARCHAR(120) NOT NULL,
  grade VARCHAR(30),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS employees (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  department_id UUID REFERENCES departments(id) ON DELETE SET NULL,
  job_title_id UUID REFERENCES job_titles(id) ON DELETE SET NULL,
  employee_number VARCHAR(50) UNIQUE NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100),
  email VARCHAR(180) UNIQUE NOT NULL,
  phone VARCHAR(50),
  date_of_birth DATE,
  hire_date DATE NOT NULL,
  employment_type VARCHAR(40) NOT NULL DEFAULT 'full_time',
  status VARCHAR(30) NOT NULL DEFAULT 'active',
  address TEXT,
  emergency_contact_name VARCHAR(120),
  emergency_contact_phone VARCHAR(50),
  base_salary NUMERIC(14,2) NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  employee_id UUID REFERENCES employees(id) ON DELETE SET NULL,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(180) UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role VARCHAR(30) NOT NULL DEFAULT 'employee',
  active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS attendance (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
  attendance_date DATE NOT NULL,
  clock_in TIMESTAMPTZ,
  clock_out TIMESTAMPTZ,
  status VARCHAR(30) NOT NULL DEFAULT 'present',
  overtime_hours NUMERIC(8,2) NOT NULL DEFAULT 0,
  notes TEXT,
  UNIQUE(employee_id, attendance_date)
);

CREATE TABLE IF NOT EXISTS leave_types (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) UNIQUE NOT NULL,
  annual_allowance NUMERIC(8,2) NOT NULL DEFAULT 0,
  paid BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS leave_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
  leave_type_id UUID NOT NULL REFERENCES leave_types(id),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  days NUMERIC(8,2) NOT NULL,
  reason TEXT,
  status VARCHAR(30) NOT NULL DEFAULT 'pending',
  approved_by UUID REFERENCES users(id),
  approved_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS payroll_runs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  period_month INTEGER NOT NULL,
  period_year INTEGER NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'draft',
  processed_by UUID REFERENCES users(id),
  processed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(period_month, period_year)
);

CREATE TABLE IF NOT EXISTS payslips (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  payroll_run_id UUID NOT NULL REFERENCES payroll_runs(id) ON DELETE CASCADE,
  employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
  base_salary NUMERIC(14,2) NOT NULL,
  overtime_pay NUMERIC(14,2) NOT NULL DEFAULT 0,
  allowances NUMERIC(14,2) NOT NULL DEFAULT 0,
  deductions NUMERIC(14,2) NOT NULL DEFAULT 0,
  tax NUMERIC(14,2) NOT NULL DEFAULT 0,
  net_salary NUMERIC(14,2) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS job_openings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  department_id UUID REFERENCES departments(id) ON DELETE SET NULL,
  title VARCHAR(150) NOT NULL,
  description TEXT,
  employment_type VARCHAR(40),
  location VARCHAR(120),
  status VARCHAR(30) NOT NULL DEFAULT 'open',
  closing_date DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS applicants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  job_opening_id UUID NOT NULL REFERENCES job_openings(id) ON DELETE CASCADE,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100),
  email VARCHAR(180) NOT NULL,
  phone VARCHAR(50),
  status VARCHAR(40) NOT NULL DEFAULT 'applied',
  score INTEGER NOT NULL DEFAULT 0,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS performance_reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
  reviewer_id UUID REFERENCES users(id),
  review_period VARCHAR(80) NOT NULL,
  goals_score INTEGER,
  skills_score INTEGER,
  attendance_score INTEGER,
  overall_score NUMERIC(5,2),
  strengths TEXT,
  improvements TEXT,
  comments TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS employee_documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
  document_type VARCHAR(80) NOT NULL,
  file_name VARCHAR(180) NOT NULL,
  file_path TEXT,
  expiry_date DATE,
  uploaded_by UUID REFERENCES users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  action VARCHAR(80) NOT NULL,
  entity_type VARCHAR(80),
  entity_id UUID,
  method VARCHAR(10),
  path TEXT,
  ip_address VARCHAR(80),
  after_data JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO departments(name,manager_name) VALUES
('Engineering','Alex Morgan'),
('Human Resources','Mia Wilson'),
('Sales','Ethan Clark'),
('Finance','Olivia Brown')
ON CONFLICT(name) DO NOTHING;

INSERT INTO job_titles(department_id,title,grade)
SELECT id,'Software Engineer','G5' FROM departments WHERE name='Engineering'
UNION ALL
SELECT id,'HR Executive','G4' FROM departments WHERE name='Human Resources'
UNION ALL
SELECT id,'Sales Executive','G4' FROM departments WHERE name='Sales'
UNION ALL
SELECT id,'Accountant','G4' FROM departments WHERE name='Finance';

INSERT INTO employees(department_id,job_title_id,employee_number,first_name,last_name,email,phone,date_of_birth,hire_date,employment_type,status,address,emergency_contact_name,emergency_contact_phone,base_salary)
SELECT d.id,j.id,'EMP-001','Daniel','Stone','employee@demo.com','+1-555-1001','1995-04-15',CURRENT_DATE-500,'full_time','active','12 Lake Road','Sarah Stone','+1-555-9001',4500
FROM departments d JOIN job_titles j ON j.department_id=d.id WHERE d.name='Engineering' AND j.title='Software Engineer'
ON CONFLICT(employee_number) DO NOTHING;

INSERT INTO employees(department_id,job_title_id,employee_number,first_name,last_name,email,phone,date_of_birth,hire_date,employment_type,status,address,emergency_contact_name,emergency_contact_phone,base_salary)
SELECT d.id,j.id,'EMP-002','Mia','Wilson','hr@demo.com','+1-555-1002','1991-08-20',CURRENT_DATE-900,'full_time','active','22 Green Street','Liam Wilson','+1-555-9002',5200
FROM departments d JOIN job_titles j ON j.department_id=d.id WHERE d.name='Human Resources' AND j.title='HR Executive'
ON CONFLICT(employee_number) DO NOTHING;

INSERT INTO users(employee_id,name,email,password_hash,role)
SELECT id,'Demo Employee','employee@demo.com',crypt('employee123',gen_salt('bf')),'employee'
FROM employees WHERE employee_number='EMP-001'
ON CONFLICT(email) DO NOTHING;

INSERT INTO users(employee_id,name,email,password_hash,role)
SELECT id,'Demo HR Manager','hr@demo.com',crypt('hr123',gen_salt('bf')),'hr'
FROM employees WHERE employee_number='EMP-002'
ON CONFLICT(email) DO NOTHING;

INSERT INTO users(name,email,password_hash,role)
VALUES('Demo Admin','admin@demo.com',crypt('admin123',gen_salt('bf')),'admin')
ON CONFLICT(email) DO NOTHING;

INSERT INTO leave_types(name,annual_allowance,paid) VALUES
('Annual Leave',14,TRUE),
('Sick Leave',7,TRUE),
('Casual Leave',5,TRUE),
('Unpaid Leave',0,FALSE)
ON CONFLICT(name) DO NOTHING;

INSERT INTO attendance(employee_id,attendance_date,clock_in,clock_out,status,overtime_hours,notes)
SELECT id,CURRENT_DATE-1,(CURRENT_DATE-1)+TIME '08:55',(CURRENT_DATE-1)+TIME '17:30','present',0.5,'Normal workday'
FROM employees
ON CONFLICT(employee_id,attendance_date) DO NOTHING;

INSERT INTO leave_requests(employee_id,leave_type_id,start_date,end_date,days,reason,status)
SELECT e.id,l.id,CURRENT_DATE+7,CURRENT_DATE+8,2,'Family event','pending'
FROM employees e,leave_types l WHERE e.employee_number='EMP-001' AND l.name='Annual Leave';

INSERT INTO job_openings(department_id,title,description,employment_type,location,status,closing_date)
SELECT id,'Frontend Developer','React developer for enterprise web applications.','full_time','Remote','open',CURRENT_DATE+30
FROM departments WHERE name='Engineering';
