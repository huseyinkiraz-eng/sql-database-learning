# 🎓 Bölüm 1: Üniversite Veritabanı Tasarımı (University Database Schema)

Bu modülde ilişkisel veritabanı (RDBMS) temelleri, tablo ilişkileri (`1:N`, `M:N`), veri tipleri ve referential integrity kuralları (`ON DELETE RESTRICT / CASCADE`) kullanılarak PostgreSQL üzerinde bir üniversite veritabanı şeması tasarlanmıştır.

## 📐 Entity-Relationship (ER) Diyagramı

```mermaid
erDiagram
    DEPARTMENTS ||--o{ INSTRUCTORS : employs
    DEPARTMENTS ||--o{ STUDENTS : enrolls
    DEPARTMENTS ||--o{ COURSES : offers
    INSTRUCTORS ||--o{ COURSES : teaches
    STUDENTS ||--o{ ENROLLMENTS : registers
    COURSES ||--o{ ENROLLMENTS : includes

    DEPARTMENTS {
        bigint department_id PK
        varchar department_name UK
        varchar office_location
    }
    INSTRUCTORS {
        bigint instructor_id PK
        bigint department_id FK
        varchar first_name
        varchar last_name
        varchar email UK
        varchar academic_title
    }
    STUDENTS {
        bigint student_id PK
        bigint department_id FK
        varchar first_name
        varchar last_name
        varchar email UK
        date birth_date
        date enrollment_date
        boolean is_active
    }
    COURSES {
        bigint course_id PK
        bigint department_id FK
        bigint instructor_id FK
        varchar course_code UK
        varchar course_name
        integer credits
    }
    ENROLLMENTS {
        bigint student_id PK, FK
        bigint course_id PK, FK
        date enrollment_date
        numeric grade
    }
```

## 🔒 Uygulanan Kısıtlamalar (Constraints & Kurallar)
- **Primary Keys:** Tekil tablolarda `BIGINT GENERATED ALWAYS AS IDENTITY`, ara tabloda (`enrollments`) `(student_id, course_id)` **Composite Primary Key** kullanıldı.
- **Unique:** Bölüm adları, ders kodları ve öğrenci/öğretim üyesi e-posta adresleri benzersiz (`UNIQUE`) tanımlandı.
- **Check Constraints:** Ders kredileri `1 ile 10` arasında, öğrenci notları `0 ile 100` arasında sınırlandırıldı.
- **Referential Actions:**
  - `ON DELETE RESTRICT`: Öğrencisi, hocası veya dersi bulunan bir bölümün yanlışlıkla silinmesi engellendi.
  - `ON DELETE CASCADE`: Öğrenci kaydı silindiğinde ilgili ders kayıtlarının (`enrollments`) otomatik temizlenmesi sağlandı.
