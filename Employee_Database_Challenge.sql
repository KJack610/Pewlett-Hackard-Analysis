-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);
CREATE TABLE employees (
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);
CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE Dept_emp (
  emp_no INT NOT NULL,
 dept_no VARCHAR NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
 FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);
CREATE TABLE titles (
  emp_no INT NOT NULL,
  title VARCHAR NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no, title, from_date)
);
DROP TABLE titles CASCADE;
SELECT * FROM titles;
SELECT * FROM departments;
SELECT * FROM salaries;
SELECT * FROM Dept_emp;
SELECT * FROM Dept_manager;
SELECT * FROM employees;

--Retirement Eligibility
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';
-- RE by 1952
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';
--RE by 1953
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';
-- RE by 1954
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';
--RE by 1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement eligibility and Hire Date
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
--Original Query to Export
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Code to Export Query into a New Table
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
--TO see the query
SELECT *FROM retirement_info
--DROP the retirement_info table to be able to re create it so that it has the emp_no. Dont need to use cascade
DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;
-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;
SELECT * FROM departments;

-- Joining retirement_info and dept_emp tables
-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;
SELECT * FROM retirement_info;
 
 -- Joining retirement_info and dept_emp table Using an Alias
SELECT ri.emp_no,
    ri.first_name,
ri.last_name,
 de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;
-- -- Joining departments and dept_manager tables Using an Alias
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;
-- Use LEft Join for Retirement_info and dept_emp tables
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');
--Check the query for current_emp
SELECT * FROM current_emp;

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;
--Export in to a CSV
SELECT COUNT (ce.emp_no), de.dept_no
INTO dept_count
from current_emp as ce 
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;
SELECT * FROM dept_count;
--Create additional list 7.3.5
SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
--List for Employee Information 7.3.5
SELECT*FROM retirement_info
SELECT emp_no,
    first_name,
last_name,
    gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT e.emp_no,
    e.first_name,
e.last_name,
    e.gender,
    s.salary,
    de.to_date 
INTO emp_info1
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
 	AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	AND (de.to_date = '9999-01-01');
SELECT * FROM emp_info1
-- LIST 2: MANAGEMENT 7.3.5
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
--INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
--List 3: Departments 7.3.5
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);
SELECT * FROM dept_manager
SELECT * FROM current_emp
SELECT * FROM employees
SELECT * FROM titles
--MODULE 7 CHALLENGE STARTS HERE
--1.1: RETRIEVE FROM EMPLOYEE TABLE
SELECT emp_no,first_name, last_name
FROM employees


--1.2: RETRIEVE FROM TITLE TABLE
SELECT title, from_date, to_date
from titles
ORDER by from_date, to_date DESC;

--1.3: CREATE NEW TABLE
SELECT emp_no, first_name, last_name, birth_date, hire_date
INTO emp_intt
FROM employees;

SELECT title, from_date, to_date, emp_no
INTO titles_int
from titles
ORDER by from_date, to_date DESC;

SELECT * FROM titles_int
SELECT * FROM emp_intt

--1.4L JOIN TABLES
SELECT emp_intt.emp_no,
	emp_intt.first_name,
	emp_intt.last_name,
	emp_intt.birth_date,
	titles_int.title,
	titles_int.from_date,
  	titles_int.to_date
INTO emp_tis
FROM emp_intt
INNER JOIN titles_int
ON emp_intt.emp_no = titles_int.emp_no;
SELECT * FROM emp_tis

-- 1.5: Filter on birth_date
SELECT emp_no, first_name, last_name, title, from_date, to_date
INTO retirement_titles
FROM emp_tis
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31');
SELECT* FROM retirement_titles

--1.9: Retrieve EN, FN, LN, Title
SELECT emp_no, first_name, last_name, title
FROM retirement_titles


--1.10 Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no, first_name,last_name, title
INTO unique_titles
FROM retirement_titles
WHERE to_date >= '1999-01-01'
ORDER BY emp_no, first_name, last_name, title DESC;
SELECT* FROM unique_titles

--1.16: New Query for Retriring Titles
SELECT COUNT (emp_no), title
INTO retirement_groups
FROM unique_titles
GROUP BY title 
ORDER BY COUNT(emp_no) DESC;
SELECT*FROM retirement_groups

--DELIVERABLE #2
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, birth_date
INTO employees_1
FROM employees
SELECT*FROM employees_1

SELECT DISTINCT ON (emp_no) emp_no, from_date, to_date
INTO dept_emp1
FROM dept_emp

SELECT DISTINCT ON (emp_no) emp_no, title
INTO titles_1
FROM titles
 
--Join EM and DEPARTMENT TABLES & CREATE NEW TABLE
SELECT 	employees_1.first_name,
		employees_1.last_name,
		employees_1.birth_date,
		dept_emp1.emp_no,
		dept_emp1.from_date,
		dept_emp1.to_date
INTO employees_3
FROM employees_1
INNER JOIN dept_emp1
ON employees_1.emp_no  = dept_emp1.emp_no

SELECT*FROM employees_3

--Join EM and TITLES TABLES & CREATE NEW TABLE
SELECT  employees_3.first_name,
		employees_3.last_name,
		employees_3.birth_date,
		employees_3.from_date,
		employees_3.to_date,
		titles_1.emp_no,
		titles_1.title
INTO employees_4
FROM employees_3
INNER JOIN titles_1
ON employees_3.emp_no  = titles_1.emp_no

SELECT *FROM employees_4

SELECT emp_no,title, first_name, last_name, birth_date, from_date, to_date
INTO mentorship_eligibility
FROM employees_4
WHERE (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	AND (to_date = '9999-01-01')
ORDER BY emp_no DESC;		

SELECT * FROM mentorship_eligibility

--Analysis: QUESTION 1
--The purpose of this analysis is to determine the number of employees retiring and the number of employees
-- eligible for participation in the mentorship program.

--Analysis: QUESTION 2
-- POINT 1: Using the Join function helps to put all of the data into a single table and much easier to determine the number of employees retiring and which ones can participate in the program.
-- POINT 2: the Distinct() function helped to ensure that there were no duplicates in the data. This provides an accurate data.
-- POINT 3: Having the accurate data helps to ensure the departments the determine the exact number of positions that need to be filled.
-- POINT 4: With this information, they can determine how much money/resources need to be allocated to each department for recruiment, hiring, onboarding and mentoring program resources.

--ANALYSIS: QUESTION 3:
-- NUMBER OF ROLES: The number of roles that need to be filled is based on the needs of the organization. If the organization will need to determine what can be automated and what needs need to be an actual role.













