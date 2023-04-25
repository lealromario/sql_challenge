CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "emp_title_id" VARCHAR   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INT   NOT NULL
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL
);

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR   NOT NULL
);

CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "titles" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

--1.List the employee number, last name, first name, sex, and salary of each employee
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees AS e 
JOIN salaries AS s
ON e.emp_no=s.emp_no
ORDER BY e.emp_no;

--2. List the first name, last name, and hire date for the employees who were hired in 1986
SELECT e.first_name, e.last_name, e.hire_date
FROM employees AS e
WHERE e.hire_date > '1986-01-01'::date AND e.hire_date < '1987-01-01'::date
limit 10;

--3. List the manager of each department along with their department number, department name, 
-- employee number, last name, and first name.
SELECT dm.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name
FROM dept_manager as dm
INNER JOIN departments as d
	ON dm.dept_no=d.dept_no
LEFT JOIN employees as e
	ON dm.emp_no=e.emp_no;
	
--4.List the department number for each employee along with that employee’s employee number,
-- last name, first name, and department name.
SELECT d.dept_no, e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees as e
JOIN dept_emp as de
	ON e.emp_no=de.emp_no
JOIN departments as d
	ON de.dept_no=d.dept_no;
	
--5.List first name, last name, and sex of each 
--employee whose first name is Hercules and whose last name begins with the letter B.
SELECT e.first_name, e.last_name, e.sex
FROM employees as e
WHERE e.first_name = 'Hercules' AND e.last_name LIKE 'B%';

--6. List each employee in the Sales department, including their employee number,
--last name, and first name.
SELECT d.dept_name, e.emp_no, e.last_name, e.first_name
FROM employees as e
JOIN dept_emp as de
	ON e.emp_no=de.emp_no
JOIN departments as d
	ON d.dept_no=de.dept_no
	WHERE d.dept_name = 'Sales';
	
-- 7. List each employee in the Sales and Development departments, 
-- including their employee number, last name, first name, and department name.

SELECT d.dept_name, e.emp_no, e.last_name, e.first_name
FROM employees AS e
JOIN dept_emp AS de
	ON e.emp_no=de.emp_no
JOIN departments AS d
	ON de.dept_no=de.dept_no
WHERE d.dept_name = 'Sales' OR d.dept_name = 'Development';

-- 8.List the frequency counts, in descending order, 
--of all the employee last names (that is, how many employees share each last name).
SELECT e.last_name, COUNT(*)
FROM employees AS e
GROUP BY e.last_name
ORDER BY COUNT (*) DESC;

