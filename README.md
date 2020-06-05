# Pewlett Hackard Report

## Introduction

Pewlett Hackard (PH), a huge company, needs to know how many of its employees are retiring so that it can plan to hire and train new employees in a timely fashion. PostgreSQL 12 and pgAdmin v 4.14 on macOS Catalina were employed to create and evaluate a database to determine how many persons would be eligible for retirement, or potentially participating in a mentoship program.

## Summary and Challenges

To begin, the data was separated into six csv files, so relationships between the data was visualised by creating an Entity Relationship Diagram (ERD). The ERD was updated to include the new csv files created for the challenge but is included below.

#### Entity Relationship Diagram for Pewlett Hackard's Employee Data
![ERD](https://github.com/Alyssa-CG/Module7-Pewlett-Hackard-Analysis/blob/master/Challenge/ChallengeEmployeeDB.png)

Then, a database with all available employee-related information from the company was created in PostgreSQL. Next, pgAdmin was used to import, consolidate, filter and export data for our needs. The first challenge encountered along the way was compatibility issues with the software and available operating system, which took some uninstalling and reinstalling of different versions before pgAdmin imports and exports would function. After that, the data processing was straightforward until the challenge.

Trying to discern exactly what the challenge activity was asking was difficult, as it did appear to have errors. We had determined throughout this module that the employees eligible for retirement were those born between 1952 and 1955 and hired between 1985 and 1988, which made it odd to consider employees born in 1965 for mentorship. The number of individuals being hired was not discussed, and no data was provided on the topic.

If the mentorship program candidates must come from the results of the first table generated for this challenge, that is, if they must be part of the retirement-ready employees, then I believe the mentorship program candidates should be those born in 1955 not 1965. To determine mentorship eligibility, I used the following query:  
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
				
With this code, I joined the retiring_titles_unique table with the titles table to get the data from the requested columns. I did a second inner join on employees so that I would be able to filter by birth_date, and I still filtered by to_date to ensure I only pulled current employees. As the retiring_title_unique table had unique empoyee numbers (emp_no), the results of the join were also unique (which was still verified). I saved the output from this join into a table, which I then exported to a csv file.

Out of curiosity, I did still check how many current employees were born in 1965, by joining the employees and titles tables, then filtering for current employees (end date 9999-01-01) born in 1965 and found only 1,549 persons within those categories.

Full code for the final tables 1 and 2 can be found [here](https://github.com/Alyssa-CG/Module7-Pewlett-Hackard-Analysis/blob/master/Challenge/Challenge%20Tables.sql).

## Results

There were 33,118 retirement-ready PH employees. 

The number of individuals being hired was not discussed, and no data was provided on the topic, but a reasonable estimate would be up to 33,118 individuals, possibly less if retiring employees instead opt to stay to mentor new employees. The number of employees being hired may also be affected by a number of other factors, including the natural change of job responsibilities and company needs over time, the number of persons leaving the company for other reasons and growth or shrinkage of the company or branch.

Based on the assumption that mentorship-eligible employees were born in 1955, there would be 8,475 eligible employees.

Further analysis on this data set could include an evaluation of which departments would be most affected by the "silver tsunami", the potentialy significant number of retiring employees. This would help the company plan where best to prioritise their mentoring and rehiring efforts.