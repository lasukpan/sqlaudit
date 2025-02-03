-- Создание серверного аудита
USE [master];
GO

CREATE SERVER AUDIT [ServerAudit]
TO FILE (
    FILEPATH = 'C:\SQLAudit\',
    MAXSIZE = 100 MB,
    MAX_ROLLOVER_FILES = 10
)
WITH (
    QUEUE_DELAY = 1000,
    ON_FAILURE = CONTINUE
);

-- Включение аудита
ALTER SERVER AUDIT [ServerAudit]
WITH (STATE = ON);




USE [master];
GO

CREATE SERVER AUDIT SPECIFICATION [ServerAuditSpec]
FOR SERVER AUDIT [ServerAudit]
ADD (FAILED_LOGIN_GROUP),
ADD (BACKUP_RESTORE_GROUP),
ADD (USER_CHANGE_PASSWORD_GROUP)
WITH (STATE = ON);



-- Создание спецификации аудита сервера

USE [master];
GO

CREATE SERVER AUDIT SPECIFICATION [ServerAuditSpec]
FOR SERVER AUDIT [ServerAudit]
ADD (FAILED_LOGIN_GROUP),
ADD (BACKUP_RESTORE_GROUP),
ADD (USER_CHANGE_PASSWORD_GROUP)
WITH (STATE = ON);



--Создание спецификации аудита базы данных

