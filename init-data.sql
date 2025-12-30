-- Initial data for Quiz Application
USE quizapp;

-- Insert sample teachers
INSERT INTO teachers (name, password) VALUES 
('Dr. Smith', 'teacher123'),
('Prof. Johnson', 'prof456');

-- Insert sample students
INSERT INTO students (name, password) VALUES 
('Alice', 'student123'),
('Bob', 'student456'),
('Charlie', 'student789');

-- Note: Sample quizzes can be added by teachers through the application
