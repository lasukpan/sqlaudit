-- Используем базу данных Mybaza
USE Mybaza;

-- Создание ролей
CREATE ROLE AdminRole;
CREATE ROLE ModeratorRole;
CREATE ROLE UserRole;

-- Создание пользователей и их добавление в роли

-- Администратор
CREATE LOGIN AdminUser WITH PASSWORD = 'AdminPassword123', 
CHECK_POLICY = ON, CHECK_EXPIRATION = ON;
CREATE USER AdminUser FOR LOGIN AdminUser;
ALTER ROLE AdminRole ADD MEMBER AdminUser;

-- Модератор
CREATE LOGIN ModeratorUser WITH PASSWORD = 'ModeratorPassword123', 
CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF;
CREATE USER ModeratorUser FOR LOGIN ModeratorUser;
ALTER ROLE ModeratorRole ADD MEMBER ModeratorUser;

-- Пользователь
CREATE LOGIN RegularUser WITH PASSWORD = 'UserPassword123', 
CHECK_POLICY = ON, CHECK_EXPIRATION = ON;
CREATE USER RegularUser FOR LOGIN RegularUser;
ALTER ROLE UserRole ADD MEMBER RegularUser;



USE master;
-- Ограничение доступа только к базе данных Mybaza
REVOKE CONNECT SQL FROM PUBLIC;
GRANT CONNECT TO AdminRole;
GRANT CONNECT TO ModeratorRole;
GRANT CONNECT TO UserRole;

-- Назначение прав для каждой роли

-- Администратор (полные права)
GRANT ALL ON SCHEMA::dbo TO AdminRole;

-- Модератор (ограниченные права: чтение, вставка, обновление)
GRANT SELECT, INSERT, UPDATE ON SCHEMA::dbo TO ModeratorRole;

-- Пользователь (только чтение)
GRANT SELECT ON SCHEMA::dbo TO UserRole;

-- Примеры назначения прав для конкретных таблиц (если они существуют)

-- Для таблиц Employees, Departments, Projects:
GRANT ALL ON Employees TO AdminRole;
GRANT ALL ON Departments TO AdminRole;
GRANT ALL ON Projects TO AdminRole;







------------------------------------
-- Администратор получает полные права через роль db_owner
ALTER ROLE db_owner ADD MEMBER AdminUser;

-- Модератор получает ограниченные права
GRANT SELECT, INSERT, UPDATE ON Employees TO ModeratorRole;
GRANT SELECT, INSERT, UPDATE ON Departments TO ModeratorRole;
GRANT SELECT, INSERT, UPDATE ON Projects TO ModeratorRole;

-- Пользователь получает только право на чтение
GRANT SELECT ON Employees TO UserRole;
GRANT SELECT ON Departments TO UserRole;
GRANT SELECT ON Projects TO UserRole;



GRANT SELECT, INSERT, UPDATE ON Employees TO ModeratorRole;
GRANT SELECT, INSERT, UPDATE ON Departments TO ModeratorRole;
GRANT SELECT, INSERT, UPDATE ON Projects TO ModeratorRole;

GRANT SELECT ON Employees TO UserRole;
GRANT SELECT ON Departments TO UserRole;
GRANT SELECT ON Projects TO UserRole;

-- Отключение пользователя Модератор
ALTER LOGIN ModeratorUser DISABLE;

-- Смена пароля для пользователя Пользователь
ALTER LOGIN RegularUser WITH PASSWORD = 'NewUserPassword123';

-- Удаление пользователя Пользователь
DROP USER RegularUser;
DROP LOGIN RegularUser;

-- Отмена роли у пользователя Модератор
ALTER ROLE ModeratorRole DROP MEMBER ModeratorUser;

-- Удаление роли Пользователь
DROP ROLE UserRole;

-- Включение / отключение политик безопасности

-- Включение политики паролей для Администратора
ALTER LOGIN AdminUser WITH CHECK_POLICY = ON, CHECK_EXPIRATION = ON;

-- Отключение политики паролей для Модератора
ALTER LOGIN ModeratorUser WITH CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF;

-- Сброс пароля для Модератора
ALTER LOGIN ModeratorUser WITH PASSWORD = 'NewModeratorPassword123';

-- Запрет на выполнение определенных действий

-- Отмена права на обновление для Модератора
REVOKE UPDATE ON Employees FROM ModeratorRole;
REVOKE UPDATE ON Departments FROM ModeratorRole;
REVOKE UPDATE ON Projects FROM ModeratorRole;

-- Полное удаление логина Администратора (при необходимости)
-- DROP LOGIN AdminUser;