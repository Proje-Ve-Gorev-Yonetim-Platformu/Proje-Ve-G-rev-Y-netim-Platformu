-- 1. Kullanýcýlar ve Ýtibar Puaný
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    reputation_points INT DEFAULT 1000, -- Baþlangýç puaný
    avatar_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Çalýþma Alanlarý (Workspaces)
CREATE TABLE workspaces (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    owner_id BIGINT,
    FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE SET NULL
);

-- 3. Workspace Üyeliði ve Roller
CREATE TABLE workspace_members (
    workspace_id BIGINT,
    user_id BIGINT,
    role ENUM('admin', 'manager', 'developer', 'viewer') DEFAULT 'developer',
    PRIMARY KEY (workspace_id, user_id),
    FOREIGN KEY (workspace_id) REFERENCES workspaces(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 4. Projeler
CREATE TABLE projects (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    workspace_id BIGINT,
    name VARCHAR(100) NOT NULL,
    status ENUM('active', 'completed', 'archived') DEFAULT 'active',
    due_date DATE,
    FOREIGN KEY (workspace_id) REFERENCES workspaces(id) ON DELETE CASCADE
);

-- 5. Görev Listeleri (Sütunlar)
CREATE TABLE task_lists (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    project_id BIGINT,
    name VARCHAR(50) NOT NULL,
    position INT DEFAULT 0,
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
);

-- 6. Görevler (Tasklar)
CREATE TABLE tasks (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    list_id BIGINT,
    creator_id BIGINT,
    assignee_id BIGINT, -- Görevin sorumlusu
    parent_id BIGINT DEFAULT NULL, -- Alt görev desteði
    title VARCHAR(255) NOT NULL,
    description TEXT,
    priority ENUM('low', 'medium', 'high', 'critical') DEFAULT 'medium',
    status ENUM('todo', 'in_progress', 'review', 'done') DEFAULT 'todo',
    due_date DATETIME,
    completed_at DATETIME,
    is_penalty_processed BOOLEAN DEFAULT FALSE, -- Ceza kesildi mi kontrolü
    FOREIGN KEY (list_id) REFERENCES task_lists(id) ON DELETE CASCADE,
    FOREIGN KEY (assignee_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (parent_id) REFERENCES tasks(id) ON DELETE CASCADE
);

-- 7. Ceza Kurallarý (Örn: Gecikme, Reddedilme)
CREATE TABLE penalty_rules (
    id INT PRIMARY KEY AUTO_INCREMENT,
    rule_name VARCHAR(100), -- Örn: "Görev Gecikmesi"
    points_to_deduct INT NOT NULL, -- Kaç puan düþecek?
    description TEXT
);

-- 8. Verilen Cezalar
CREATE TABLE user_penalties (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT,
    task_id BIGINT,
    rule_id INT,
    points_lost INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE SET NULL,
    FOREIGN KEY (rule_id) REFERENCES penalty_rules(id)
);

-- 9. Aktivite Loglarý (Audit Log)
CREATE TABLE activity_logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT,
    action_type VARCHAR(50),
    entity_id BIGINT,
    old_value TEXT,
    new_value TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 10. Bildirimler
CREATE TABLE notifications (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT,
    message TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);