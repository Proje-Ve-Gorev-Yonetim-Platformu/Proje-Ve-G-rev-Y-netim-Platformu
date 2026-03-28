DELIMITER //
CREATE PROCEDURE Proc_GetUserPerformanceReport(IN p_workspace_id BIGINT)
BEGIN
    SELECT 
        u.full_name,
        u.reputation_points,
        COUNT(t.id) as total_tasks,
        SUM(CASE WHEN t.status = 'done' THEN 1 ELSE 0 END) as completed_tasks
    FROM users u
    JOIN workspace_members wm ON u.id = wm.user_id
    LEFT JOIN tasks t ON u.id = t.assignee_id
    WHERE wm.workspace_id = p_workspace_id
    GROUP BY u.id;
END //
DELIMITER ;