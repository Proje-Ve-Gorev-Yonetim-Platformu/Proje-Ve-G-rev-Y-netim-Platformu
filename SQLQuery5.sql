DELIMITER //
CREATE PROCEDURE Proc_ApplyOverduePenalties()
BEGIN
    -- Geciken ve henüz ceza iþlemi görmemiþ görevleri bul
    INSERT INTO user_penalties (user_id, task_id, rule_id, points_lost)
    SELECT 
        t.assignee_id, 
        t.id, 
        (SELECT id FROM penalty_rules WHERE rule_name = 'Gecikme' LIMIT 1),
        50 -- Örnek: Gecikme cezasý 50 puan
    FROM tasks t
    WHERE t.due_date < NOW() 
      AND t.status <> 'done' 
      AND t.is_penalty_processed = FALSE
      AND t.assignee_id IS NOT NULL;

    -- Ýþlem yapýlan görevleri iþaretle ki tekrar ceza kesilmesin
    UPDATE tasks 
    SET is_penalty_processed = TRUE 
    WHERE due_date < NOW() AND status <> 'done';
END //
DELIMITER ;