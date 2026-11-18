
-- 1. Schema oluştur
CREATE SCHEMA university;

-- 2. Departments
CREATE TABLE university.departments (
    department_id BIGINT GENERATED ALWAYS AS IDENTITY,
    department_name VARCHAR(100) NOT NULL,
    office_location VARCHAR(100),

    CONSTRAINT pk_departments
        PRIMARY KEY (department_id),

    CONSTRAINT uq_departments_name
        UNIQUE (department_name)
);

-- 3. Instructors
CREATE TABLE university.instructors (
    instructor_id BIGINT GENERATED ALWAYS AS IDENTITY,
    department_id BIGINT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL,
    academic_title VARCHAR(50),

    CONSTRAINT pk_instructors
        PRIMARY KEY (instructor_id),

    CONSTRAINT uq_instructors_email
        UNIQUE (email),

    CONSTRAINT fk_instructors_department
        FOREIGN KEY (department_id)
        REFERENCES university.departments(department_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- 4. Students
CREATE TABLE university.students (
    student_id BIGINT GENERATED ALWAYS AS IDENTITY,
    department_id BIGINT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL,
    birth_date DATE,
    enrollment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT pk_students
        PRIMARY KEY (student_id),

    CONSTRAINT uq_students_email
        UNIQUE (email),

    CONSTRAINT fk_students_department
        FOREIGN KEY (department_id)
        REFERENCES university.departments(department_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_students_birth_date
        CHECK (
            birth_date IS NULL
            OR birth_date <= CURRENT_DATE
        )
);

-- 5. Courses
CREATE TABLE university.courses (
    course_id BIGINT GENERATED ALWAYS AS IDENTITY,
    department_id BIGINT NOT NULL,
    instructor_id BIGINT NOT NULL,
    course_code VARCHAR(20) NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INTEGER NOT NULL DEFAULT 3,

    CONSTRAINT pk_courses
        PRIMARY KEY (course_id),

    CONSTRAINT uq_courses_code
        UNIQUE (course_code),

    CONSTRAINT chk_courses_credits
        CHECK (credits BETWEEN 1 AND 10),

    CONSTRAINT fk_courses_department
        FOREIGN KEY (department_id)
        REFERENCES university.departments(department_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_courses_instructor
        FOREIGN KEY (instructor_id)
        REFERENCES university.instructors(instructor_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- 6. Enrollments
CREATE TABLE university.enrollments (
    student_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    enrollment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    grade NUMERIC(5,2),

    CONSTRAINT pk_enrollments
        PRIMARY KEY (student_id, course_id),

    CONSTRAINT fk_enrollments_student
        FOREIGN KEY (student_id)
        REFERENCES university.students(student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_enrollments_course
        FOREIGN KEY (course_id)
        REFERENCES university.courses(course_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_enrollments_grade
        CHECK (grade IS NULL OR grade BETWEEN 0 AND 100)
);
