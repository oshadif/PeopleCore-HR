import{Router}from"express";import{pool}from"../db.js";import{requireAuth}from"../middleware/auth.js";const r=Router();
r.get("/departments",requireAuth,async(req,res)=>res.json((await pool.query("SELECT * FROM departments ORDER BY name")).rows));
r.get("/job-titles",requireAuth,async(req,res)=>res.json((await pool.query("SELECT j.*,d.name department_name FROM job_titles j LEFT JOIN departments d ON d.id=j.department_id ORDER BY j.title")).rows));
r.get("/leave-types",requireAuth,async(req,res)=>res.json((await pool.query("SELECT * FROM leave_types ORDER BY name")).rows));
export default r;