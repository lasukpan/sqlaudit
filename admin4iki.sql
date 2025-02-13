-- ���������� ���� ������ Mybaza
USE Mybaza;

-- �������� �����
CREATE ROLE AdminRole;
CREATE ROLE ModeratorRole;
CREATE ROLE UserRole;

-- �������� ������������� � �� ���������� � ����

-- �������������
CREATE LOGIN AdminUser WITH PASSWORD = 'AdminPassword123', 
CHECK_POLICY = ON, CHECK_EXPIRATION = ON;
CREATE USER AdminUser FOR LOGIN AdminUser;
ALTER ROLE AdminRole ADD MEMBER AdminUser;

-- ���������
CREATE LOGIN ModeratorUser WITH PASSWORD = 'ModeratorPassword123', 
CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF;
CREATE USER ModeratorUser FOR LOGIN ModeratorUser;
ALTER ROLE ModeratorRole ADD MEMBER ModeratorUser;

-- ������������
CREATE LOGIN RegularUser WITH PASSWORD = 'UserPassword123', 
CHECK_POLICY = ON, CHECK_EXPIRATION = ON;
CREATE USER RegularUser FOR LOGIN RegularUser;
ALTER ROLE UserRole ADD MEMBER RegularUser;



USE master;
-- ����������� ������� ������ � ���� ������ Mybaza
REVOKE CONNECT SQL FROM PUBLIC;
GRANT CONNECT TO AdminRole;
GRANT CONNECT TO ModeratorRole;
GRANT CONNECT TO UserRole;

-- ���������� ���� ��� ������ ����

-- ������������� (������ �����)
GRANT ALL ON SCHEMA::dbo TO AdminRole;

-- ��������� (������������ �����: ������, �������, ����������)
GRANT SELECT, INSERT, UPDATE ON SCHEMA::dbo TO ModeratorRole;

-- ������������ (������ ������)
GRANT SELECT ON SCHEMA::dbo TO UserRole;

-- ������� ���������� ���� ��� ���������� ������ (���� ��� ����������)

-- ��� ������ Employees, Departments, Projects:
GRANT ALL ON Employees TO AdminRole;
GRANT ALL ON Departments TO AdminRole;
GRANT ALL ON Projects TO AdminRole;







------------------------------------
-- ������������� �������� ������ ����� ����� ���� db_owner
ALTER ROLE db_owner ADD MEMBER AdminUser;

-- ��������� �������� ������������ �����
GRANT SELECT, INSERT, UPDATE ON Employees TO ModeratorRole;
GRANT SELECT, INSERT, UPDATE ON Departments TO ModeratorRole;
GRANT SELECT, INSERT, UPDATE ON Projects TO ModeratorRole;

-- ������������ �������� ������ ����� �� ������
GRANT SELECT ON Employees TO UserRole;
GRANT SELECT ON Departments TO UserRole;
GRANT SELECT ON Projects TO UserRole;



GRANT SELECT, INSERT, UPDATE ON Employees TO ModeratorRole;
GRANT SELECT, INSERT, UPDATE ON Departments TO ModeratorRole;
GRANT SELECT, INSERT, UPDATE ON Projects TO ModeratorRole;

GRANT SELECT ON Employees TO UserRole;
GRANT SELECT ON Departments TO UserRole;
GRANT SELECT ON Projects TO UserRole;

-- ���������� ������������ ���������
ALTER LOGIN ModeratorUser DISABLE;

-- ����� ������ ��� ������������ ������������
ALTER LOGIN RegularUser WITH PASSWORD = 'NewUserPassword123';

-- �������� ������������ ������������
DROP USER RegularUser;
DROP LOGIN RegularUser;

-- ������ ���� � ������������ ���������
ALTER ROLE ModeratorRole DROP MEMBER ModeratorUser;

-- �������� ���� ������������
DROP ROLE UserRole;

-- ��������� / ���������� ������� ������������

-- ��������� �������� ������� ��� ��������������
ALTER LOGIN AdminUser WITH CHECK_POLICY = ON, CHECK_EXPIRATION = ON;

-- ���������� �������� ������� ��� ����������
ALTER LOGIN ModeratorUser WITH CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF;

-- ����� ������ ��� ����������
ALTER LOGIN ModeratorUser WITH PASSWORD = 'NewModeratorPassword123';

-- ������ �� ���������� ������������ ��������

-- ������ ����� �� ���������� ��� ����������
REVOKE UPDATE ON Employees FROM ModeratorRole;
REVOKE UPDATE ON Departments FROM ModeratorRole;
REVOKE UPDATE ON Projects FROM ModeratorRole;

-- ������ �������� ������ �������������� (��� �������������)
-- DROP LOGIN AdminUser;