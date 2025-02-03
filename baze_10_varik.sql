CREATE TABLE марка_автомобиля (
    id INT PRIMARY KEY IDENTITY(1,1),
    название_марки NVARCHAR(50) NOT NULL UNIQUE,
    страна_производитель NVARCHAR(50) NOT NULL,
    завод_производитель NVARCHAR(100) NOT NULL,
    адрес_завода NVARCHAR(200)
);




CREATE TABLE автомобили (
    id INT PRIMARY KEY IDENTITY(1,1),
    название_автомобиля NVARCHAR(100) NOT NULL,
    марка_id INT NOT NULL,
    год_производства INT NOT NULL CHECK (год_производства > 1900),
    цвет NVARCHAR(30),
    категория NVARCHAR(50),
    цена DECIMAL(12, 2) NOT NULL CHECK (цена > 0),
    
    FOREIGN KEY (марка_id) REFERENCES марка_автомобиля(id)
);



CREATE TABLE покупатели (
    id INT PRIMARY KEY IDENTITY(1,1),
    фамилия NVARCHAR(50) NOT NULL,
    имя NVARCHAR(50) NOT NULL,
    отчество NVARCHAR(50),
    паспортные_данные NVARCHAR(100) NOT NULL UNIQUE,
    адрес NVARCHAR(200),
    город NVARCHAR(50),
    возраст INT CHECK (возраст >= 18),
    пол NVARCHAR(10) CHECK (пол IN ('Мужской', 'Женский'))
);




CREATE TABLE сотрудники (
    id INT PRIMARY KEY IDENTITY(1,1),
    фамилия NVARCHAR(50) NOT NULL,
    имя NVARCHAR(50) NOT NULL,
    отчество NVARCHAR(50),
    стаж INT CHECK (стаж >= 0),
    зарплата DECIMAL(10, 2) CHECK (зарплата >= 0)
);



CREATE TABLE продажа_автомобилей (
    id INT PRIMARY KEY IDENTITY(1,1),
    дата_продажи DATE NOT NULL,
    сотрудник_id INT NOT NULL,
    автомобиль_id INT NOT NULL,
    покупатель_id INT NOT NULL,
    
    FOREIGN KEY (сотрудник_id) REFERENCES сотрудники(id),
    FOREIGN KEY (автомобиль_id) REFERENCES автомобили(id),
    FOREIGN KEY (покупатель_id) REFERENCES покупатели(id)
);




-- Добавление марки
INSERT INTO марка_автомобиля (название_марки, страна_производитель, завод_производитель, адрес_завода)
VALUES ('Toyota', 'Япония', 'Toyota Motor Corporation', 'Тойота, Айти, Япония');

-- Добавление автомобиля
INSERT INTO автомобили (название_автомобиля, марка_id, год_производства, цвет, категория, цена)
VALUES ('Camry', 1, 2023, 'Черный', 'Седан', 3000000.00);

-- Добавление покупателя
INSERT INTO покупатели (фамилия, имя, отчество, паспортные_данные, адрес, город, возраст, пол)
VALUES ('Иванов', 'Иван', 'Иванович', '1234 567890', 'ул. Пушкина, 10', 'Москва', 30, 'Мужской');

-- Добавление сотрудника
INSERT INTO сотрудники (фамилия, имя, отчество, стаж, зарплата)
VALUES ('Петров', 'Петр', 'Петрович', 5, 50000.00);

-- Фиксация продажи
INSERT INTO продажа_автомобилей (дата_продажи, сотрудник_id, автомобиль_id, покупатель_id)
VALUES ('2023-10-01', 1, 1, 1);


CREATE INDEX idx_марка_id ON автомобили(марка_id);

CREATE TRIGGER mark_as_sold
ON продажа_автомобилей
AFTER INSERT
AS
BEGIN
    UPDATE автомобили
    SET статус = 'Продан'
    WHERE id IN (SELECT автомобиль_id FROM inserted);
END;
