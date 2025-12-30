-- ========================================
-- QUIZ APP - USEFUL DATABASE QUERIES
-- ========================================

-- Switch to the quizapp database
USE quizapp;

-- ========================================
-- BASIC QUERIES - View All Data
-- ========================================

-- View all tables in the database
SHOW TABLES;

-- View all teachers
SELECT * FROM teachers;

-- View all students
SELECT * FROM students;

-- View all quizzes
SELECT * FROM quizzes;

-- View all questions
SELECT * FROM questions;

-- View all options
SELECT * FROM options;

-- View all student scores
SELECT * FROM student_scores;

-- ========================================
-- DETAILED QUERIES - Get Specific Information
-- ========================================

-- Get all questions for a specific quiz (replace quiz_id with actual ID)
SELECT 
    q.title AS quiz_title,
    qu.question_text,
    qu.correct_answer
FROM quizzes q
JOIN questions qu ON q.id = qu.quiz_id
WHERE q.id = 1;

-- Get all questions with their options for a specific quiz
SELECT 
    q.title AS quiz_title,
    qu.question_text,
    o.option_text,
    qu.correct_answer
FROM quizzes q
JOIN questions qu ON q.id = qu.quiz_id
JOIN options o ON qu.id = o.question_id
WHERE q.id = 1
ORDER BY qu.id, o.id;

-- Get student scores for a specific quiz
SELECT 
    s.name AS student_name,
    q.title AS quiz_title,
    ss.score
FROM student_scores ss
JOIN students s ON ss.student_id = s.id
JOIN quizzes q ON ss.quiz_id = q.id
WHERE q.id = 1;

-- Get all scores for a specific student
SELECT 
    s.name AS student_name,
    q.title AS quiz_title,
    ss.score
FROM student_scores ss
JOIN students s ON ss.student_id = s.id
JOIN quizzes q ON ss.quiz_id = q.id
WHERE s.name = 'student1';

-- Get average score per quiz
SELECT 
    q.title AS quiz_title,
    AVG(ss.score) AS average_score,
    COUNT(ss.id) AS number_of_attempts
FROM student_scores ss
JOIN quizzes q ON ss.quiz_id = q.id
GROUP BY q.id, q.title;

-- Get top performing students
SELECT 
    s.name AS student_name,
    AVG(ss.score) AS average_score,
    COUNT(ss.id) AS quizzes_taken
FROM student_scores ss
JOIN students s ON ss.student_id = s.id
GROUP BY s.id, s.name
ORDER BY average_score DESC;

-- Count questions per quiz
SELECT 
    q.title AS quiz_title,
    COUNT(qu.id) AS number_of_questions
FROM quizzes q
LEFT JOIN questions qu ON q.id = qu.quiz_id
GROUP BY q.id, q.title;

-- ========================================
-- INSERT QUERIES - Add New Data
-- ========================================

-- Add a new teacher
INSERT INTO teachers (name, password) 
VALUES ('teacher2', 'pass456');

-- Add a new student
INSERT INTO students (name, password) 
VALUES ('student3', 'pass123');

-- Add a new quiz
INSERT INTO quizzes (title) 
VALUES ('Java Programming Quiz');

-- Add a question to a quiz (replace quiz_id with actual ID)
INSERT INTO questions (quiz_id, question_text, correct_answer) 
VALUES (1, 'What is polymorphism?', 'Multiple forms of a single entity');

-- Add options for a question (replace question_id with actual ID)
INSERT INTO options (question_id, option_text) VALUES
(1, 'Multiple forms of a single entity'),
(1, 'Single form of multiple entities'),
(1, 'Data hiding'),
(1, 'Code reusability');

-- Record a student's quiz score
INSERT INTO student_scores (student_id, quiz_id, score) 
VALUES (1, 1, 85);

-- ========================================
-- UPDATE QUERIES - Modify Existing Data
-- ========================================

-- Update a teacher's password
UPDATE teachers 
SET password = 'newpass123' 
WHERE name = 'teacher1';

-- Update a student's password
UPDATE students 
SET password = 'newpass456' 
WHERE name = 'student1';

-- Update a quiz title
UPDATE quizzes 
SET title = 'Updated Quiz Title' 
WHERE id = 1;

-- Update a student's score
UPDATE student_scores 
SET score = 90 
WHERE student_id = 1 AND quiz_id = 1;

-- ========================================
-- DELETE QUERIES - Remove Data
-- ========================================

-- Delete a specific teacher
DELETE FROM teachers 
WHERE name = 'teacher2';

-- Delete a specific student
DELETE FROM students 
WHERE name = 'student3';

-- Delete a quiz (will also delete associated questions and options due to CASCADE)
DELETE FROM quizzes 
WHERE id = 2;

-- Delete all scores for a specific student
DELETE FROM student_scores 
WHERE student_id = 1;

-- ========================================
-- SEARCH QUERIES - Find Specific Data
-- ========================================

-- Find quizzes by title (partial match)
SELECT * FROM quizzes 
WHERE title LIKE '%Java%';

-- Find students by name
SELECT * FROM students 
WHERE name LIKE '%student%';

-- Find questions containing specific text
SELECT * FROM questions 
WHERE question_text LIKE '%polymorphism%';

-- Find students who scored above a certain threshold
SELECT 
    s.name AS student_name,
    q.title AS quiz_title,
    ss.score
FROM student_scores ss
JOIN students s ON ss.student_id = s.id
JOIN quizzes q ON ss.quiz_id = q.id
WHERE ss.score >= 80;

-- ========================================
-- STATISTICS QUERIES - Analytics
-- ========================================

-- Total number of quizzes
SELECT COUNT(*) AS total_quizzes FROM quizzes;

-- Total number of students
SELECT COUNT(*) AS total_students FROM students;

-- Total number of teachers
SELECT COUNT(*) AS total_teachers FROM teachers;

-- Total quiz attempts
SELECT COUNT(*) AS total_attempts FROM student_scores;

-- Highest score achieved
SELECT 
    s.name AS student_name,
    q.title AS quiz_title,
    ss.score AS highest_score
FROM student_scores ss
JOIN students s ON ss.student_id = s.id
JOIN quizzes q ON ss.quiz_id = q.id
ORDER BY ss.score DESC
LIMIT 1;

-- Quiz with most attempts
SELECT 
    q.title AS quiz_title,
    COUNT(ss.id) AS attempt_count
FROM student_scores ss
JOIN quizzes q ON ss.quiz_id = q.id
GROUP BY q.id, q.title
ORDER BY attempt_count DESC
LIMIT 1;

-- Students who haven't taken any quiz
SELECT s.name 
FROM students s
LEFT JOIN student_scores ss ON s.id = ss.student_id
WHERE ss.id IS NULL;

-- ========================================
-- UTILITY QUERIES - Database Management
-- ========================================

-- View table structure
DESCRIBE teachers;
DESCRIBE students;
DESCRIBE quizzes;
DESCRIBE questions;
DESCRIBE options;
DESCRIBE student_scores;

-- Count records in each table
SELECT 'teachers' AS table_name, COUNT(*) AS record_count FROM teachers
UNION ALL
SELECT 'students', COUNT(*) FROM students
UNION ALL
SELECT 'quizzes', COUNT(*) FROM quizzes
UNION ALL
SELECT 'questions', COUNT(*) FROM questions
UNION ALL
SELECT 'options', COUNT(*) FROM options
UNION ALL
SELECT 'student_scores', COUNT(*) FROM student_scores;

-- Check for orphaned records (questions without a quiz)
SELECT * FROM questions 
WHERE quiz_id NOT IN (SELECT id FROM quizzes);

-- Check for orphaned options (options without a question)
SELECT * FROM options 
WHERE question_id NOT IN (SELECT id FROM questions);

-- ========================================
-- BACKUP QUERIES - Export Data
-- ========================================

-- Create a complete quiz with questions and options
-- (This is a template - modify values as needed)
START TRANSACTION;

INSERT INTO quizzes (title) VALUES ('Sample Quiz');
SET @quiz_id = LAST_INSERT_ID();

INSERT INTO questions (quiz_id, question_text, correct_answer) 
VALUES (@quiz_id, 'What is Java?', 'Programming Language');
SET @question_id = LAST_INSERT_ID();

INSERT INTO options (question_id, option_text) VALUES
(@question_id, 'Programming Language'),
(@question_id, 'Coffee Brand'),
(@question_id, 'Operating System'),
(@question_id, 'Database');

COMMIT;
