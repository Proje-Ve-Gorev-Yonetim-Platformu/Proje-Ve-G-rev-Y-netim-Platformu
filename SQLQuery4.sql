DELIMITER //
CREATE TRIGGER trg_task_completion_log
AFTER UPDATE ON tasks
FOR EACH ROW
BEGIN
    IF OLD.status <> 'done' AND NEW.status = 'done' THEN
        INSERT INTO activity_logs (user_id, action_type, entity_id, new_value)
        VALUES (NEW.assignee_id, 'TASK_COMPLETED', NEW.id, 'Görev tamamlandý');
    END IF;
END //
DELIMITER ;