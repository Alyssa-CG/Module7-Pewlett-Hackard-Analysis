-- CHALLENGE Table 1: Number of Retiring Employees by Title

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
-- 33,118 unique employees, confirmed again below when partitioned into
-- TABLE 1 (retiring_titles_unique).


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

 -- CHALLENGE Table 2: Mentorship Eligibility
-- A table of employees from within the TABLE 1 identified retiring group, born in 1955.

SELECT rt.emp_no,
	rt.first_name,
	rt.last_name,
	t.title,	
	t.from_date,
	t.to_date
INTO mentorship_eligibility
FROM retiring_titles_unique AS rt
	INNER JOIN titles AS t
		ON (rt.emp_no = t.emp_no)
	INNER JOIN employees AS e
		ON (rt.emp_no = e.emp_no)
		WHERE (e.birth_date BETWEEN '1955-01-01' AND '1955-12-31')
		AND (t.to_date = '9999-01-01');

-- Based on this query, 8,475 eligible for mentorship.		
