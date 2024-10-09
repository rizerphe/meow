-- Query to generate and run drop commands for all databases except system ones
SET FOREIGN_KEY_CHECKS = 0;

-- Dynamically drop all user-created databases
SET @sql = (SELECT GROUP_CONCAT(DROP_DB_COMMAND SEPARATOR '; ') 
            FROM (SELECT CONCAT('DROP DATABASE IF EXISTS `', SCHEMA_NAME, '`') AS DROP_DB_COMMAND
                  FROM information_schema.SCHEMATA 
                  WHERE SCHEMA_NAME NOT IN ('mysql', 'information_schema', 'performance_schema', 'sys')) AS T);
                    
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET FOREIGN_KEY_CHECKS = 1;
