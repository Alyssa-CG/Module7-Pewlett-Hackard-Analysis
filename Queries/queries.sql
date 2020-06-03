SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';
-- "90,398 rows affected" as born between 1952-1955

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';
-- 21,209 born in 1952

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';
-- 22,857 born in 1953

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';
-- 23,228 born in 1954

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';
-- 23,104 born in 1955

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- 41,380 returned

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables with inner join
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;


-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
retirement_info.last_name,
	dept_employees.to_date
FROM retirement_info
LEFT JOIN dept_employees
ON retirement_info.emp_no = dept_employees.emp_no;

-- Performing same join with Aliases.
-- These aliases are limited to this query, not the db.
SELECT ri.emp_no,
	ri.first_name,
ri.last_name,
FROM retirement_info as ri
LEFT JOIN dept_employees as de
ON ri.emp_no = de.emp_no;
	de.to_date 
	
-- Edit to save results to new table
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_employees as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO department_retirement_count
FROM current_emp as ce
LEFT JOIN dept_employees as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_employees as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
    AND (de.to_date = '9999-01-01');

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
		
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name	
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_employees AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

-- SKILL DRILL: Create a query that will return only the information relevant to the Sales team. The requested list includes:

-- Employee numbers
-- Employee first name
-- Employee last name
-- Employee department name
-- The info is in retirement_info and dept_emp
-- Done below, 5,252 current employees in the sales dept may retire soon.

SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.dept_no	
FROM retirement_info as ri
	INNER JOIN dept_employees AS de
		ON (ri.emp_no = de.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (de.dept_no = 'd007');

SELECT * FROM retirement_info
SELECT * FROM dept_employees
SELECT * FROM departments

-- SKILL DRILL: Create another query that will return the following information for the Sales and Development teams:

-- Employee numbers
-- Employee first name
-- Employee last name
-- Employee department name

-- Hint: You’ll need to use the IN condition with the WHERE clause. See the PostgreSQL documentation (Links to an external site.) for additional information.
-- Without WHERE, IN, 13,613 current, retiring employees in either sales or devt.
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.dept_no	
FROM retirement_info as ri
	INNER JOIN dept_employees AS de
		ON (ri.emp_no = de.emp_no)
WHERE (de.to_date = '9999-01-01')
AND ((de.dept_no = 'd007') OR de.dept_no = 'd005');

-- Using WHERE, IN: 13,613 employees.

SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.dept_no	
FROM retirement_info as ri
	INNER JOIN dept_employees AS de
		ON (ri.emp_no = de.emp_no)
WHERE (de.to_date = '9999-01-01')
AND de.dept_no IN ('d005', 'd007');

--

-- CHALLENGE Table 1: Number of Retiring Employees by Title

SELECT * FROM current_emp
SELECT * FROM titles
SELECT * FROM salaries


SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	t.title,	
	t.from_date,
	s.salary
INTO retiring_titles
FROM current_emp as ce
	INNER JOIN titles AS t
		ON (ce.emp_no = t.emp_no)
	INNER JOIN salaries AS s
		ON (ce.emp_no = s.emp_no);

-- DUPLICATES:
-- Find duplicated names (by emp_no, first_name, last_name)
-- Returns count. (Here returns 20,922 duplicated employees.) 
SELECT
  emp_no,
  first_name,
  last_name,
  count(*)
FROM retiring_titles
GROUP BY
  emp_no,
  first_name,
  last_name
HAVING count(*) > 1;

-- Display duplicate rows (42,526 rows)
SELECT * FROM
  (SELECT *, count(*)
  OVER
    (PARTITION BY
     emp_no, 
	 first_name,
     last_name
    ) AS count
  FROM retiring_titles) tableWithCount
  WHERE tableWithCount.count > 1;
  
-- Remove ALMOST identical rows. 
-- We want to pick those with more recent "from_date".

SELECT DISTINCT ON (emp_no, 
					first_name, 
					last_name)
* FROM retiring_titles;

-- From quick check above, there seems to be 33,118 distinct employees. 
-- 33,118 unique employees, confirmed again below.


SELECT emp_no, 
	first_name, 
	last_name, 
	title, 
	from_date, 
	salary 
INTO retiring_titles_unique
FROM
  (SELECT emp_no, 
	first_name, 
	last_name, 
	title, 
	from_date, 
	salary,
     ROW_NUMBER() OVER 
(PARTITION BY (emp_no) 
 ORDER BY from_date DESC) rn
   FROM retiring_titles
  ) tmp WHERE rn = 1
 ORDER BY emp_no;
 