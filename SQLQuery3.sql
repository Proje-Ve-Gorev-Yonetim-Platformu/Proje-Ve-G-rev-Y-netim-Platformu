DELIMITER //
CREATE TRIGGER trg_after_penalty_insert
AFTER INSERT ON user_penalties
FOR EACH ROW
BEGIN
    UPDATE users 
    SET reputation_points = reputation_points - NEW.points_lost 
    WHERE id = NEW.user_id;
END //
DELIMITER ;