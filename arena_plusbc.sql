-- =============================================================
-- Arena+ | Banco de dados MySQL 8.0+
-- Projeto acadêmico P06 - Fábrica de Software / UNIVILLE
-- =============================================================
USE arena;

CREATE DATABASE IF NOT EXISTS arena_plus
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE arena_plus;

-- -------------------------
-- 1. USUARIO (Organizador/Diretor; público não possui conta)
-- -------------------------
CREATE TABLE IF NOT EXISTS usuario (
    id_usuario BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(254) NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    perfil VARCHAR(20) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario),
    UNIQUE KEY uk_usuario_email (email),
    CONSTRAINT ck_usuario_perfil CHECK (perfil IN ('DIRETOR', 'ORGANIZADOR')),
    CONSTRAINT ck_usuario_ativo CHECK (ativo IN (0,1))
) ENGINE=InnoDB;

-- -------------------------
-- 2. ENDERECO
-- -------------------------
CREATE TABLE IF NOT EXISTS endereco (
    id_endereco BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    cep CHAR(8) NULL,
    logradouro VARCHAR(180) NOT NULL,
    numero VARCHAR(20) NULL,
    complemento VARCHAR(100) NULL,
    bairro VARCHAR(100) NULL,
    cidade VARCHAR(100) NOT NULL,
    uf CHAR(2) NOT NULL,
    PRIMARY KEY (id_endereco),
    CONSTRAINT ck_endereco_cep CHECK (cep IS NULL OR cep REGEXP '^[0-9]{8}$'),
    CONSTRAINT ck_endereco_uf CHECK (uf REGEXP '^[A-Z]{2}$')
) ENGINE=InnoDB;

-- -------------------------
-- 3. EQUIPE
-- -------------------------
CREATE TABLE IF NOT EXISTS equipe (
    id_equipe BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_diretor BIGINT UNSIGNED NOT NULL,
    nome VARCHAR(150) NOT NULL,
    sigla VARCHAR(15) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'ATIVA',
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_equipe),
    KEY idx_equipe_diretor (id_diretor),
    CONSTRAINT fk_equipe_diretor FOREIGN KEY (id_diretor)
        REFERENCES usuario (id_usuario)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_equipe_status CHECK (status IN ('ATIVA', 'INATIVA'))
) ENGINE=InnoDB;

-- -------------------------
-- 4. INTEGRANTE
-- -------------------------
CREATE TABLE IF NOT EXISTS integrante (
    id_integrante BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_equipe BIGINT UNSIGNED NOT NULL,
    id_endereco BIGINT UNSIGNED NULL,
    cpf CHAR(11) NULL,
    nome VARCHAR(150) NOT NULL,
    data_nascimento DATE NULL,
    funcao VARCHAR(60) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_integrante),
    UNIQUE KEY uk_integrante_cpf (cpf),
    KEY idx_integrante_equipe (id_equipe),
    KEY idx_integrante_endereco (id_endereco),
    CONSTRAINT fk_integrante_equipe FOREIGN KEY (id_equipe)
        REFERENCES equipe (id_equipe)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_integrante_endereco FOREIGN KEY (id_endereco)
        REFERENCES endereco (id_endereco)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT ck_integrante_cpf CHECK (cpf IS NULL OR cpf REGEXP '^[0-9]{11}$'),
    CONSTRAINT ck_integrante_ativo CHECK (ativo IN (0,1))
) ENGINE=InnoDB;

-- -------------------------
-- 5. LOCAL_PARTIDA
-- -------------------------
CREATE TABLE IF NOT EXISTS local_partida (
    id_local BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_endereco BIGINT UNSIGNED NOT NULL,
    nome VARCHAR(150) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_local),
    KEY idx_local_endereco (id_endereco),
    CONSTRAINT fk_local_endereco FOREIGN KEY (id_endereco)
        REFERENCES endereco (id_endereco)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_local_ativo CHECK (ativo IN (0,1))
) ENGINE=InnoDB;

-- -------------------------
-- 6. CAMPEONATO
-- -------------------------
CREATE TABLE IF NOT EXISTS campeonato (
    id_campeonato BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_organizador BIGINT UNSIGNED NOT NULL,
    nome VARCHAR(150) NOT NULL,
    modalidade VARCHAR(80) NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PLANEJADO',
    min_equipes SMALLINT UNSIGNED NOT NULL,
    max_equipes SMALLINT UNSIGNED NOT NULL,
    pontos_vitoria SMALLINT NOT NULL DEFAULT 3,
    pontos_empate SMALLINT NOT NULL DEFAULT 1,
    pontos_derrota SMALLINT NOT NULL DEFAULT 0,
    PRIMARY KEY (id_campeonato),
    KEY idx_campeonato_organizador (id_organizador),
    CONSTRAINT fk_campeonato_organizador FOREIGN KEY (id_organizador)
        REFERENCES usuario (id_usuario)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_campeonato_datas CHECK (data_fim >= data_inicio),
    CONSTRAINT ck_campeonato_status CHECK (status IN ('PLANEJADO', 'EM_ANDAMENTO', 'ENCERRADO')),
    CONSTRAINT ck_campeonato_min_equipes CHECK (min_equipes >= 2),
    CONSTRAINT ck_campeonato_max_equipes CHECK (max_equipes >= min_equipes),
    CONSTRAINT ck_campeonato_pontos CHECK (
        pontos_vitoria >= 0 AND pontos_empate >= 0 AND pontos_derrota >= 0
    )
) ENGINE=InnoDB;

-- -------------------------
-- 7. INSCRICAO
-- -------------------------
CREATE TABLE IF NOT EXISTS inscricao (
    id_inscricao BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_campeonato BIGINT UNSIGNED NOT NULL,
    id_equipe BIGINT UNSIGNED NOT NULL,
    id_usuario_inscricao BIGINT UNSIGNED NOT NULL,
    data_inscricao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'CONFIRMADA',
    PRIMARY KEY (id_inscricao),
    UNIQUE KEY uk_inscricao_campeonato_equipe (id_campeonato, id_equipe),
    UNIQUE KEY uk_inscricao_campeonato_id (id_campeonato, id_inscricao),
    KEY idx_inscricao_equipe (id_equipe),
    KEY idx_inscricao_usuario (id_usuario_inscricao),
    CONSTRAINT fk_inscricao_campeonato FOREIGN KEY (id_campeonato)
        REFERENCES campeonato (id_campeonato)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_inscricao_equipe FOREIGN KEY (id_equipe)
        REFERENCES equipe (id_equipe)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_inscricao_usuario FOREIGN KEY (id_usuario_inscricao)
        REFERENCES usuario (id_usuario)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_inscricao_status CHECK (status IN ('CONFIRMADA', 'CANCELADA'))
) ENGINE=InnoDB;

-- -------------------------
-- 8. PARTIDA
-- FKs compostas asseguram que as duas inscrições pertencem ao campeonato.
-- -------------------------
CREATE TABLE IF NOT EXISTS partida (
    id_partida BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_campeonato BIGINT UNSIGNED NOT NULL,
    id_inscricao_a BIGINT UNSIGNED NOT NULL,
    id_inscricao_b BIGINT UNSIGNED NOT NULL,
    id_local BIGINT UNSIGNED NULL,
    data_hora DATETIME NULL,
    rodada SMALLINT UNSIGNED NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'AGENDADA',

    PRIMARY KEY (id_partida),

    KEY idx_partida_campeonato (id_campeonato),
    KEY idx_partida_inscricao_a (id_campeonato, id_inscricao_a),
    KEY idx_partida_inscricao_b (id_campeonato, id_inscricao_b),
    KEY idx_partida_local (id_local),

    CONSTRAINT fk_partida_inscricao_a
        FOREIGN KEY (id_campeonato, id_inscricao_a)
        REFERENCES inscricao (id_campeonato, id_inscricao)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_partida_inscricao_b
        FOREIGN KEY (id_campeonato, id_inscricao_b)
        REFERENCES inscricao (id_campeonato, id_inscricao)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_partida_local
        FOREIGN KEY (id_local)
        REFERENCES local_partida (id_local)
        ON UPDATE CASCADE ON DELETE SET NULL,

    CONSTRAINT ck_partida_rodada
        CHECK (rodada > 0),

    CONSTRAINT ck_partida_status
        CHECK (status IN ('AGENDADA', 'EM_ANDAMENTO', 'CONCLUIDA', 'CANCELADA'))
) ENGINE=InnoDB;


DROP TRIGGER IF EXISTS trg_partida_validar_insert;
DROP TRIGGER IF EXISTS trg_partida_validar_update;

DELIMITER $$

CREATE TRIGGER trg_partida_validar_insert
BEFORE INSERT ON partida
FOR EACH ROW
BEGIN
    IF NEW.id_inscricao_a = NEW.id_inscricao_b THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Uma equipe nao pode jogar contra ela mesma.';
    END IF;
END$$

CREATE TRIGGER trg_partida_validar_update
BEFORE UPDATE ON partida
FOR EACH ROW
BEGIN
    IF NEW.id_inscricao_a = NEW.id_inscricao_b THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Uma equipe nao pode jogar contra ela mesma.';
    END IF;
END$$

DELIMITER ;


-- -------------------------
-- 9. RESULTADO
-- -------------------------
CREATE TABLE IF NOT EXISTS resultado (
    id_resultado BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_partida BIGINT UNSIGNED NOT NULL,
    placar_a INT NOT NULL,
    placar_b INT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'RASCUNHO',
    registrado_por BIGINT UNSIGNED NOT NULL,
    registrado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id_resultado),
    UNIQUE KEY uk_resultado_partida (id_partida),
    KEY idx_resultado_usuario (registrado_por),

    CONSTRAINT fk_resultado_partida
        FOREIGN KEY (id_partida)
        REFERENCES partida (id_partida)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_resultado_usuario
        FOREIGN KEY (registrado_por)
        REFERENCES usuario (id_usuario)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT ck_resultado_placares
        CHECK (placar_a >= 0 AND placar_b >= 0),

    CONSTRAINT ck_resultado_status
        CHECK (status IN ('RASCUNHO', 'CONFIRMADO', 'ANULADO'))
) ENGINE=InnoDB;

-- -------------------------
-- 10. HISTORICO_RESULTADO
-- -------------------------
CREATE TABLE IF NOT EXISTS historico_resultado (
    id_historico BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_resultado BIGINT UNSIGNED NOT NULL,
    id_usuario BIGINT UNSIGNED NOT NULL,
    acao VARCHAR(20) NOT NULL,
    placar_a_anterior INT NULL,
    placar_b_anterior INT NULL,
    placar_a_novo INT NULL,
    placar_b_novo INT NULL,
    status_anterior VARCHAR(20) NULL,
    status_novo VARCHAR(20) NOT NULL,
    motivo VARCHAR(500) NULL,
    alterado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_historico),
    KEY idx_hist_resultado_resultado (id_resultado),
    KEY idx_hist_resultado_usuario (id_usuario),
    CONSTRAINT fk_hist_resultado_resultado FOREIGN KEY (id_resultado)
        REFERENCES resultado (id_resultado)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_hist_resultado_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_hist_resultado_acao CHECK (acao IN ('CRIADO', 'ALTERADO', 'CONFIRMADO', 'ANULADO'))
) ENGINE=InnoDB;

-- -------------------------
-- 11. HISTORICO_CAMPEONATO
-- -------------------------
CREATE TABLE IF NOT EXISTS historico_campeonato (
    id_historico BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_campeonato BIGINT UNSIGNED NOT NULL,
    id_usuario BIGINT UNSIGNED NOT NULL,
    status_anterior VARCHAR(20) NOT NULL,
    status_novo VARCHAR(20) NOT NULL,
    motivo VARCHAR(500) NULL,
    alterado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_historico),
    KEY idx_hist_campeonato_campeonato (id_campeonato),
    KEY idx_hist_campeonato_usuario (id_usuario),
    CONSTRAINT fk_hist_campeonato_campeonato FOREIGN KEY (id_campeonato)
        REFERENCES campeonato (id_campeonato)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_hist_campeonato_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =============================================================
-- VIEW: classificação calculada somente a partir de resultados CONFIRMADOS
-- Critérios de ordenação: pontos, saldo, pontos marcados, vitórias.
-- Empate residual: id_inscricao (ordem determinística; regra oficial de desempate
-- precisa ser confirmada/documentada pelo PO).
-- =============================================================
CREATE OR REPLACE VIEW vw_classificacao AS
WITH desempenho AS (
    SELECT
        i.id_campeonato,
        i.id_inscricao,
        i.id_equipe,
        e.nome AS nome_equipe,
        e.sigla,
        c.pontos_vitoria,
        c.pontos_empate,
        c.pontos_derrota,
        COUNT(r.id_resultado) AS jogos,
        SUM(CASE
            WHEN (p.id_inscricao_a = i.id_inscricao AND r.placar_a > r.placar_b)
              OR (p.id_inscricao_b = i.id_inscricao AND r.placar_b > r.placar_a)
            THEN 1 ELSE 0 END) AS vitorias,
        SUM(CASE WHEN r.placar_a = r.placar_b THEN 1 ELSE 0 END) AS empates,
        SUM(CASE
            WHEN (p.id_inscricao_a = i.id_inscricao AND r.placar_a < r.placar_b)
              OR (p.id_inscricao_b = i.id_inscricao AND r.placar_b < r.placar_a)
            THEN 1 ELSE 0 END) AS derrotas,
        SUM(CASE
            WHEN p.id_inscricao_a = i.id_inscricao THEN COALESCE(r.placar_a,0)
            WHEN p.id_inscricao_b = i.id_inscricao THEN COALESCE(r.placar_b,0)
            ELSE 0 END) AS pontos_marcados,
        SUM(CASE
            WHEN p.id_inscricao_a = i.id_inscricao THEN COALESCE(r.placar_b,0)
            WHEN p.id_inscricao_b = i.id_inscricao THEN COALESCE(r.placar_a,0)
            ELSE 0 END) AS pontos_sofridos
    FROM inscricao i
    JOIN equipe e ON e.id_equipe = i.id_equipe
    JOIN campeonato c ON c.id_campeonato = i.id_campeonato
    LEFT JOIN partida p
        ON p.id_campeonato = i.id_campeonato
       AND (p.id_inscricao_a = i.id_inscricao OR p.id_inscricao_b = i.id_inscricao)
       AND p.status <> 'CANCELADA'
    LEFT JOIN resultado r
        ON r.id_partida = p.id_partida
       AND r.status = 'CONFIRMADO'
    WHERE i.status = 'CONFIRMADA'
    GROUP BY i.id_campeonato, i.id_inscricao, i.id_equipe, e.nome, e.sigla,
             c.pontos_vitoria, c.pontos_empate, c.pontos_derrota
),
pontuacao AS (
    SELECT desempenho.*,
        (vitorias * pontos_vitoria + empates * pontos_empate + derrotas * pontos_derrota) AS pontos,
        (pontos_marcados - pontos_sofridos) AS saldo_pontos
    FROM desempenho
)
SELECT
    id_campeonato,
    id_inscricao,
    id_equipe,
    nome_equipe,
    sigla,
    jogos,
    vitorias,
    empates,
    derrotas,
    pontos,
    pontos_marcados,
    pontos_sofridos,
    saldo_pontos,
    ROW_NUMBER() OVER (
        PARTITION BY id_campeonato
        ORDER BY pontos DESC, saldo_pontos DESC, pontos_marcados DESC,
                 vitorias DESC, id_inscricao ASC
    ) AS posicao
FROM pontuacao;

-- =============================================================
-- TRIGGERS: validações de negócio no banco e trilha de auditoria.
-- Regras de autorização (diretor/organizador) ainda são do backend;
-- estes triggers protegem estados/integridade, não substituem autorização.
-- =============================================================

DROP TRIGGER IF EXISTS trg_inscricao_bi;
DROP TRIGGER IF EXISTS trg_inscricao_bu;
DROP TRIGGER IF EXISTS trg_partida_bi;
DROP TRIGGER IF EXISTS trg_partida_bu;
DROP TRIGGER IF EXISTS trg_resultado_bi;
DROP TRIGGER IF EXISTS trg_resultado_ai;
DROP TRIGGER IF EXISTS trg_resultado_bu;
DROP TRIGGER IF EXISTS trg_resultado_au;
DROP TRIGGER IF EXISTS trg_campeonato_au;

DELIMITER $$

CREATE TRIGGER trg_inscricao_bi
BEFORE INSERT ON inscricao
FOR EACH ROW
BEGIN
    DECLARE v_status VARCHAR(20);
    DECLARE v_max SMALLINT;
    DECLARE v_total INT;
    DECLARE v_equipe_status VARCHAR(20);
    SELECT status, max_equipes INTO v_status, v_max
      FROM campeonato WHERE id_campeonato = NEW.id_campeonato;
    IF v_status = 'ENCERRADO' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Campeonato encerrado: novas inscricoes bloqueadas.';
    END IF;
    SELECT status INTO v_equipe_status FROM equipe WHERE id_equipe = NEW.id_equipe;
    IF v_equipe_status <> 'ATIVA' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Equipe inativa nao pode ser inscrita.';
    END IF;
    SELECT COUNT(*) INTO v_total FROM inscricao
      WHERE id_campeonato = NEW.id_campeonato AND status = 'CONFIRMADA';
    IF NEW.status = 'CONFIRMADA' AND v_total >= v_max THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Limite maximo de equipes do campeonato atingido.';
    END IF;
END$$

CREATE TRIGGER trg_inscricao_bu
BEFORE UPDATE ON inscricao
FOR EACH ROW
BEGIN
    DECLARE v_status VARCHAR(20);
    DECLARE v_max SMALLINT;
    DECLARE v_total INT;
    SELECT status, max_equipes INTO v_status, v_max
      FROM campeonato WHERE id_campeonato = NEW.id_campeonato;
    IF v_status = 'ENCERRADO' AND OLD.status <> NEW.status THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Campeonato encerrado: alteracao de inscricao bloqueada.';
    END IF;
    SELECT COUNT(*) INTO v_total FROM inscricao
      WHERE id_campeonato = NEW.id_campeonato
        AND status = 'CONFIRMADA'
        AND id_inscricao <> OLD.id_inscricao;
    IF NEW.status = 'CONFIRMADA' AND v_total >= v_max THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Limite maximo de equipes do campeonato atingido.';
    END IF;
END$$

CREATE TRIGGER trg_partida_bi
BEFORE INSERT ON partida
FOR EACH ROW
BEGIN
    DECLARE v_status VARCHAR(20);
    DECLARE v_status_a VARCHAR(20);
    DECLARE v_status_b VARCHAR(20);
    SELECT status INTO v_status FROM campeonato WHERE id_campeonato = NEW.id_campeonato;
    IF v_status = 'ENCERRADO' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Campeonato encerrado: novas partidas bloqueadas.';
    END IF;
    SELECT status INTO v_status_a FROM inscricao
      WHERE id_campeonato = NEW.id_campeonato AND id_inscricao = NEW.id_inscricao_a;
    SELECT status INTO v_status_b FROM inscricao
      WHERE id_campeonato = NEW.id_campeonato AND id_inscricao = NEW.id_inscricao_b;
    IF v_status_a IS NULL OR v_status_b IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ambas equipes devem estar inscritas no campeonato da partida.';
    END IF;
    IF v_status_a <> 'CONFIRMADA' OR v_status_b <> 'CONFIRMADA' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Partida exige inscricoes confirmadas.';
    END IF;
END$$

CREATE TRIGGER trg_partida_bu
BEFORE UPDATE ON partida
FOR EACH ROW
BEGIN
    DECLARE v_status VARCHAR(20);
    DECLARE v_status_a VARCHAR(20);
    DECLARE v_status_b VARCHAR(20);
    SELECT status INTO v_status FROM campeonato WHERE id_campeonato = OLD.id_campeonato;
    IF v_status = 'ENCERRADO' AND
       (OLD.status <> NEW.status OR OLD.id_inscricao_a <> NEW.id_inscricao_a
        OR OLD.id_inscricao_b <> NEW.id_inscricao_b OR OLD.data_hora <> NEW.data_hora
        OR OLD.id_local <> NEW.id_local) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Campeonato encerrado: alteracao de partida bloqueada.';
    END IF;
    SELECT status INTO v_status_a FROM inscricao
      WHERE id_campeonato = NEW.id_campeonato AND id_inscricao = NEW.id_inscricao_a;
    SELECT status INTO v_status_b FROM inscricao
      WHERE id_campeonato = NEW.id_campeonato AND id_inscricao = NEW.id_inscricao_b;
    IF v_status_a IS NULL OR v_status_b IS NULL
       OR v_status_a <> 'CONFIRMADA' OR v_status_b <> 'CONFIRMADA' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Partida exige inscricoes confirmadas do campeonato.';
    END IF;
END$$

CREATE TRIGGER trg_resultado_bi
BEFORE INSERT ON resultado
FOR EACH ROW
BEGIN
    DECLARE v_campeonato BIGINT UNSIGNED;
    DECLARE v_status_campeonato VARCHAR(20);
    DECLARE v_status_partida VARCHAR(20);
    SELECT id_campeonato, status INTO v_campeonato, v_status_campeonato
      FROM partida WHERE id_partida = NEW.id_partida;
    SELECT status INTO v_status_partida FROM partida WHERE id_partida = NEW.id_partida;
    IF v_status_partida = 'CANCELADA' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nao se registra resultado em partida cancelada.';
    END IF;
    IF v_status_campeonato = 'ENCERRADO' AND NEW.status <> 'RASCUNHO' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Campeonato encerrado: novo resultado confirmado bloqueado.';
    END IF;
END$$

CREATE TRIGGER trg_resultado_ai
AFTER INSERT ON resultado
FOR EACH ROW
BEGIN
    INSERT INTO historico_resultado
        (id_resultado, id_usuario, acao, placar_a_novo, placar_b_novo, status_novo)
    VALUES
        (NEW.id_resultado, NEW.registrado_por, 'CRIADO',
         NEW.placar_a, NEW.placar_b, NEW.status);
END$$

CREATE TRIGGER trg_resultado_bu
BEFORE UPDATE ON resultado
FOR EACH ROW
BEGIN
    DECLARE v_status_campeonato VARCHAR(20);
    DECLARE v_status_partida VARCHAR(20);
    SELECT c.status, p.status INTO v_status_campeonato, v_status_partida
      FROM partida p JOIN campeonato c ON c.id_campeonato = p.id_campeonato
      WHERE p.id_partida = NEW.id_partida;
    IF v_status_partida = 'CANCELADA' AND NEW.status <> 'ANULADO' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Partida cancelada nao pode possuir resultado ativo.';
    END IF;
    IF v_status_campeonato = 'ENCERRADO' AND
       (OLD.placar_a <> NEW.placar_a OR OLD.placar_b <> NEW.placar_b OR OLD.status <> NEW.status) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Campeonato encerrado: alteracao de resultado bloqueada.';
    END IF;
END$$

CREATE TRIGGER trg_resultado_au
AFTER UPDATE ON resultado
FOR EACH ROW
BEGIN
    IF OLD.placar_a <> NEW.placar_a OR OLD.placar_b <> NEW.placar_b OR OLD.status <> NEW.status THEN
        INSERT INTO historico_resultado
            (id_resultado, id_usuario, acao,
             placar_a_anterior, placar_b_anterior,
             placar_a_novo, placar_b_novo,
             status_anterior, status_novo, motivo)
        VALUES
            (NEW.id_resultado, NEW.registrado_por,
             CASE
                WHEN OLD.status <> 'CONFIRMADO' AND NEW.status = 'CONFIRMADO' THEN 'CONFIRMADO'
                WHEN NEW.status = 'ANULADO' THEN 'ANULADO'
                ELSE 'ALTERADO'
             END,
             OLD.placar_a, OLD.placar_b,
             NEW.placar_a, NEW.placar_b,
             OLD.status, NEW.status, NULL);
    END IF;
END$$

CREATE TRIGGER trg_campeonato_au
AFTER UPDATE ON campeonato
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        INSERT INTO historico_campeonato
            (id_campeonato, id_usuario, status_anterior, status_novo, motivo)
        VALUES
            (NEW.id_campeonato, NEW.id_organizador,
             OLD.status, NEW.status, NULL);
    END IF;
END$$

DELIMITER ;

-- =============================================================
-- Consultas de verificação pós-execução
-- =============================================================
SHOW TABLES;
SELECT TABLE_NAME, ENGINE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = DATABASE()
ORDER BY TABLE_NAME;

-- Exemplo de consulta à classificação:
-- SELECT * FROM vw_classificacao WHERE id_campeonato = 1 ORDER BY posicao;


USE arena;

SHOW TABLES;

SHOW CREATE TABLE partida;

SHOW TRIGGERS FROM arena;


SELECT * FROM campeonato;
SELECT * FROM equipe;
SELECT * FROM inscricao;

DESCRIBE usuario;
DESCRIBE campeonato;
DESCRIBE equipe;
DESCRIBE inscricao;