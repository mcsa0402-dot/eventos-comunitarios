-- ============================================================
-- SISTEMA DE GERENCIAMENTO DE EVENTOS COMUNITÁRIOS
-- Banco de Dados - Prefeitura Comunitária
-- ============================================================
-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS sistema_eventos_comunitarios;
USE sistema_eventos_comunitarios;
-- ============================================================
-- TABELA: CATEGORIAS DE EVENTO
-- ============================================================
CREATE TABLE IF NOT EXISTS categoria_evento (
    id_categoria    INT AUTO_INCREMENT PRIMARY KEY,
    nome            VARCHAR(100) NOT NULL UNIQUE,
    descricao       VARCHAR(255)
);
-- ============================================================
-- TABELA: USUARIOS
-- Tipos: ORGANIZADOR, VOLUNTARIO, PUBLICO
-- ============================================================
CREATE TABLE IF NOT EXISTS usuario (
    id_usuario      INT AUTO_INCREMENT PRIMARY KEY,
    nome            VARCHAR(150) NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    senha           VARCHAR(255) NOT NULL,
    cpf             VARCHAR(14)  NOT NULL UNIQUE,
    telefone        VARCHAR(20),
    tipo_usuario    ENUM('ORGANIZADOR', 'VOLUNTARIO', 'PUBLICO') NOT NULL,
    data_cadastro   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ativo           BOOLEAN      NOT NULL DEFAULT TRUE
);
-- ============================================================
-- TABELA: LOCAIS
-- ============================================================
CREATE TABLE IF NOT EXISTS local_evento (
    id_local        INT AUTO_INCREMENT PRIMARY KEY,
    nome            VARCHAR(150) NOT NULL,
    endereco        VARCHAR(255) NOT NULL,
    bairro          VARCHAR(100),
    capacidade_max  INT NOT NULL
);
-- ============================================================
-- TABELA: EVENTOS
-- ============================================================
CREATE TABLE IF NOT EXISTS evento (
    id_evento       INT AUTO_INCREMENT PRIMARY KEY,
    titulo          VARCHAR(200) NOT NULL,
    descricao       TEXT,
    data_hora       DATETIME     NOT NULL,
    data_hora_fim   DATETIME,
    id_local        INT          NOT NULL,
    capacidade      INT          NOT NULL,
    id_categoria    INT          NOT NULL,
    id_organizador  INT          NOT NULL,
    status          ENUM('PLANEJADO', 'ABERTO', 'EM_ANDAMENTO', 'ENCERRADO', 'CANCELADO') NOT NULL DEFAULT 'PLANEJADO',
    data_criacao    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_evento_local       FOREIGN KEY (id_local)       REFERENCES local_evento(id_local),
    CONSTRAINT fk_evento_categoria   FOREIGN KEY (id_categoria)   REFERENCES categoria_evento(id_categoria),
    CONSTRAINT fk_evento_organizador FOREIGN KEY (id_organizador) REFERENCES usuario(id_usuario)
);
-- ============================================================
-- TABELA: INSCRIÇÕES
-- ============================================================
CREATE TABLE IF NOT EXISTS inscricao (
    id_inscricao    INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario      INT      NOT NULL,
    id_evento       INT      NOT NULL,
    data_inscricao  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status          ENUM('CONFIRMADA', 'PENDENTE', 'CANCELADA', 'LISTA_ESPERA') NOT NULL DEFAULT 'PENDENTE',
    CONSTRAINT fk_inscricao_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    CONSTRAINT fk_inscricao_evento  FOREIGN KEY (id_evento)  REFERENCES evento(id_evento),
    CONSTRAINT uk_inscricao_unica   UNIQUE (id_usuario, id_evento)
);
-- ============================================================
-- TABELA: PARTICIPAÇÕES (presença efetiva no evento)
-- ============================================================
CREATE TABLE IF NOT EXISTS participacao (
    id_participacao INT AUTO_INCREMENT PRIMARY KEY,
    id_inscricao    INT      NOT NULL,
    data_checkin    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_checkout   DATETIME,
    presente        BOOLEAN  NOT NULL DEFAULT TRUE,
    observacao      VARCHAR(255),
    CONSTRAINT fk_participacao_inscricao FOREIGN KEY (id_inscricao) REFERENCES inscricao(id_inscricao),
    CONSTRAINT uk_participacao_unica     UNIQUE (id_inscricao)
);
-- ============================================================
-- TABELA: VOLUNTÁRIOS EM EVENTOS
-- (Relaciona voluntários a eventos com função específica)
-- ============================================================
CREATE TABLE IF NOT EXISTS voluntario_evento (
    id_voluntario_evento INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario           INT          NOT NULL,
    id_evento            INT          NOT NULL,
    funcao               VARCHAR(100) NOT NULL,
    data_atribuicao      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_vol_evento_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    CONSTRAINT fk_vol_evento_evento  FOREIGN KEY (id_evento)  REFERENCES evento(id_evento),
    CONSTRAINT uk_voluntario_evento  UNIQUE (id_usuario, id_evento)
);
-- ============================================================
-- TABELA: RELATÓRIOS
-- ============================================================
CREATE TABLE IF NOT EXISTS relatorio (
    id_relatorio      INT AUTO_INCREMENT PRIMARY KEY,
    id_evento         INT          NOT NULL,
    id_gerado_por     INT          NOT NULL,
    tipo_relatorio    ENUM('PRESENCA', 'FINANCEIRO', 'AVALIACAO', 'GERAL') NOT NULL,
    titulo            VARCHAR(200) NOT NULL,
    conteudo          TEXT,
    total_inscritos   INT DEFAULT 0,
    total_presentes   INT DEFAULT 0,
    total_ausentes    INT DEFAULT 0,
    data_geracao      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_relatorio_evento  FOREIGN KEY (id_evento)     REFERENCES evento(id_evento),
    CONSTRAINT fk_relatorio_usuario FOREIGN KEY (id_gerado_por) REFERENCES usuario(id_usuario)
);
-- ============================================================
--                  POPULAÇÃO DO BANCO DE DADOS
-- ============================================================
-- ---------- CATEGORIAS DE EVENTO ----------
INSERT INTO categoria_evento (nome, descricao) VALUES
('Palestra',       'Apresentações e talks sobre temas diversos'),
('Oficina',        'Atividades práticas e workshops interativos'),
('Feira',          'Feiras de artesanato, gastronomia e produtos locais'),
('Seminário',      'Encontros acadêmicos e debates temáticos'),
('Festival',       'Eventos culturais e artísticos de grande porte'),
('Curso',          'Cursos de curta duração para a comunidade'),
('Mutirão',        'Ações coletivas de limpeza, reforma e voluntariado'),
('Reunião',        'Reuniões comunitárias e assembleias');
-- ---------- LOCAIS ----------
INSERT INTO local_evento (nome, endereco, bairro, capacidade_max) VALUES
('Centro Comunitário São José',    'Rua das Flores, 120',         'Centro',          200),
('Praça da Liberdade',             'Av. Brasil, s/n',             'Liberdade',        500),
('Salão Paroquial N. Sra. Aparecida', 'Rua Padre Anchieta, 45',  'Vila Nova',        150),
('Escola Municipal Paulo Freire',  'Rua da Educação, 300',        'Jardim Esperança', 300),
('Ginásio Poliesportivo',          'Av. dos Esportes, 800',       'Parque Industrial',1000),
('Biblioteca Pública Municipal',   'Rua Machado de Assis, 55',    'Centro',           80),
('Casa da Cultura',                'Praça Tiradentes, 10',        'Centro Histórico', 120),
('Parque Ecológico Municipal',     'Estrada do Parque, km 3',     'Zona Rural',       2000);
-- ---------- USUÁRIOS ----------
-- Organizadores
INSERT INTO usuario (nome, email, senha, cpf, telefone, tipo_usuario) VALUES
('Ana Paula Ferreira',    'ana.ferreira@prefeitura.gov.br',    'hash_senha_01', '111.222.333-44', '(11) 99999-0001', 'ORGANIZADOR'),
('Carlos Eduardo Lima',   'carlos.lima@prefeitura.gov.br',     'hash_senha_02', '222.333.444-55', '(11) 99999-0002', 'ORGANIZADOR'),
('Mariana Santos Costa',  'mariana.costa@prefeitura.gov.br',   'hash_senha_03', '333.444.555-66', '(11) 99999-0003', 'ORGANIZADOR');
-- Voluntários
INSERT INTO usuario (nome, email, senha, cpf, telefone, tipo_usuario) VALUES
('Lucas Oliveira',        'lucas.oliveira@email.com',          'hash_senha_04', '444.555.666-77', '(11) 98888-0001', 'VOLUNTARIO'),
('Beatriz Almeida',       'beatriz.almeida@email.com',         'hash_senha_05', '555.666.777-88', '(11) 98888-0002', 'VOLUNTARIO'),
('Rafael Mendes',         'rafael.mendes@email.com',           'hash_senha_06', '666.777.888-99', '(11) 98888-0003', 'VOLUNTARIO'),
('Juliana Rocha',         'juliana.rocha@email.com',           'hash_senha_07', '777.888.999-00', '(11) 98888-0004', 'VOLUNTARIO'),
('Pedro Henrique Souza',  'pedro.souza@email.com',             'hash_senha_08', '888.999.000-11', '(11) 98888-0005', 'VOLUNTARIO');
-- Público
INSERT INTO usuario (nome, email, senha, cpf, telefone, tipo_usuario) VALUES
('Fernanda Ribeiro',      'fernanda.ribeiro@email.com',        'hash_senha_09', '999.000.111-22', '(11) 97777-0001', 'PUBLICO'),
('Gustavo Pereira',       'gustavo.pereira@email.com',         'hash_senha_10', '000.111.222-33', '(11) 97777-0002', 'PUBLICO'),
('Camila Nascimento',     'camila.nascimento@email.com',       'hash_senha_11', '112.223.334-45', '(11) 97777-0003', 'PUBLICO'),
('Diego Martins',         'diego.martins@email.com',           'hash_senha_12', '223.334.445-56', '(11) 97777-0004', 'PUBLICO'),
('Larissa Campos',        'larissa.campos@email.com',          'hash_senha_13', '334.445.556-67', '(11) 97777-0005', 'PUBLICO'),
('Thiago Barbosa',        'thiago.barbosa@email.com',          'hash_senha_14', '445.556.667-78', '(11) 97777-0006', 'PUBLICO'),
('Amanda Vieira',         'amanda.vieira@email.com',           'hash_senha_15', '556.667.778-89', '(11) 97777-0007', 'PUBLICO'),
('Roberto Cardoso',       'roberto.cardoso@email.com',         'hash_senha_16', '667.778.889-90', '(11) 97777-0008', 'PUBLICO'),
('Isabela Freitas',       'isabela.freitas@email.com',         'hash_senha_17', '778.889.990-01', '(11) 97777-0009', 'PUBLICO'),
('Matheus Gonçalves',     'matheus.goncalves@email.com',       'hash_senha_18', '889.990.001-12', '(11) 97777-0010', 'PUBLICO'),
('Patrícia Moreira',      'patricia.moreira@email.com',        'hash_senha_19', '990.001.112-23', '(11) 97777-0011', 'PUBLICO'),
('Vinícius Teixeira',     'vinicius.teixeira@email.com',       'hash_senha_20', '001.112.223-34', '(11) 97777-0012', 'PUBLICO');
-- ---------- EVENTOS ----------
INSERT INTO evento (titulo, descricao, data_hora, data_hora_fim, id_local, capacidade, id_categoria, id_organizador, status) VALUES
-- Palestras
('Palestra: Sustentabilidade Urbana',
 'Palestra sobre práticas sustentáveis para o dia a dia na cidade, com exemplos de compostagem, reciclagem e economia de água.',
 '2026-07-10 19:00:00', '2026-07-10 21:00:00', 1, 150, 1, 1, 'ABERTO'),
('Palestra: Saúde Mental na Comunidade',
 'Roda de conversa com psicólogos sobre ansiedade, depressão e cuidados com a saúde mental.',
 '2026-07-15 18:30:00', '2026-07-15 20:30:00', 6, 70, 1, 1, 'ABERTO'),
-- Oficinas
('Oficina de Artesanato em Macramê',
 'Aprenda técnicas de macramê para criar peças decorativas. Material incluso.',
 '2026-07-20 14:00:00', '2026-07-20 17:00:00', 7, 30, 2, 2, 'ABERTO'),
('Oficina de Horta Comunitária',
 'Oficina prática de plantio e manutenção de hortas urbanas. Traga roupas confortáveis.',
 '2026-07-25 09:00:00', '2026-07-25 12:00:00', 8, 50, 2, 2, 'PLANEJADO'),
-- Feiras
('Feira de Artesanato e Gastronomia',
 'Feira com expositores locais de artesanato, doces, comidas típicas e produtos orgânicos.',
 '2026-08-02 08:00:00', '2026-08-02 18:00:00', 2, 400, 3, 1, 'PLANEJADO'),
('Feira do Livro Comunitária',
 'Troca e venda de livros usados, com contação de histórias para crianças.',
 '2026-08-10 09:00:00', '2026-08-10 17:00:00', 6, 80, 3, 3, 'PLANEJADO'),
-- Seminário
('Seminário: Direitos do Cidadão',
 'Seminário com advogados e defensores públicos sobre direitos civis, trabalhistas e do consumidor.',
 '2026-07-30 08:00:00', '2026-07-30 17:00:00', 4, 250, 4, 3, 'ABERTO'),
-- Festival
('Festival Cultural de Inverno',
 'Apresentações de dança, música, teatro e exposição de artes visuais da comunidade.',
 '2026-08-15 15:00:00', '2026-08-15 22:00:00', 5, 800, 5, 1, 'PLANEJADO'),
-- Curso
('Curso de Informática Básica',
 'Curso de 3 dias cobrindo Windows, Word, Excel e navegação na internet. Voltado para adultos e idosos.',
 '2026-07-22 13:00:00', '2026-07-24 17:00:00', 4, 40, 6, 2, 'ABERTO'),
-- Mutirão
('Mutirão de Limpeza do Parque',
 'Ação voluntária de limpeza e revitalização do Parque Ecológico Municipal.',
 '2026-07-12 07:00:00', '2026-07-12 12:00:00', 8, 100, 7, 3, 'ABERTO'),
-- Eventos passados (encerrados) para relatórios
('Palestra: Educação Financeira para Famílias',
 'Dicas práticas de economia doméstica, planejamento financeiro e crédito consciente.',
 '2026-06-05 19:00:00', '2026-06-05 21:00:00', 1, 120, 1, 1, 'ENCERRADO'),
('Oficina de Primeiros Socorros',
 'Oficina ministrada pelo Corpo de Bombeiros sobre primeiros socorros básicos.',
 '2026-06-12 14:00:00', '2026-06-12 17:00:00', 3, 50, 2, 2, 'ENCERRADO');
-- ---------- INSCRIÇÕES ----------
-- Evento 1 - Palestra Sustentabilidade (id_evento = 1)
INSERT INTO inscricao (id_usuario, id_evento, status) VALUES
(9,  1, 'CONFIRMADA'),
(10, 1, 'CONFIRMADA'),
(11, 1, 'CONFIRMADA'),
(12, 1, 'CONFIRMADA'),
(13, 1, 'PENDENTE'),
(14, 1, 'CONFIRMADA'),
(15, 1, 'CONFIRMADA'),
(16, 1, 'CANCELADA');
-- Evento 2 - Palestra Saúde Mental (id_evento = 2)
INSERT INTO inscricao (id_usuario, id_evento, status) VALUES
(9,  2, 'CONFIRMADA'),
(11, 2, 'CONFIRMADA'),
(13, 2, 'CONFIRMADA'),
(15, 2, 'PENDENTE'),
(17, 2, 'CONFIRMADA'),
(18, 2, 'CONFIRMADA');
-- Evento 3 - Oficina Macramê (id_evento = 3)
INSERT INTO inscricao (id_usuario, id_evento, status) VALUES
(10, 3, 'CONFIRMADA'),
(12, 3, 'CONFIRMADA'),
(14, 3, 'CONFIRMADA'),
(16, 3, 'CONFIRMADA'),
(18, 3, 'PENDENTE'),
(20, 3, 'CONFIRMADA');
-- Evento 7 - Seminário Direitos (id_evento = 7)
INSERT INTO inscricao (id_usuario, id_evento, status) VALUES
(9,  7, 'CONFIRMADA'),
(10, 7, 'CONFIRMADA'),
(11, 7, 'CONFIRMADA'),
(12, 7, 'CONFIRMADA'),
(13, 7, 'CONFIRMADA'),
(14, 7, 'CONFIRMADA'),
(15, 7, 'CONFIRMADA'),
(17, 7, 'CONFIRMADA'),
(19, 7, 'PENDENTE'),
(20, 7, 'CONFIRMADA');
-- Evento 9 - Curso Informática (id_evento = 9)
INSERT INTO inscricao (id_usuario, id_evento, status) VALUES
(15, 9, 'CONFIRMADA'),
(16, 9, 'CONFIRMADA'),
(17, 9, 'CONFIRMADA'),
(19, 9, 'CONFIRMADA'),
(20, 9, 'CONFIRMADA');
-- Evento 10 - Mutirão Limpeza (id_evento = 10)
INSERT INTO inscricao (id_usuario, id_evento, status) VALUES
(4,  10, 'CONFIRMADA'),
(5,  10, 'CONFIRMADA'),
(6,  10, 'CONFIRMADA'),
(7,  10, 'CONFIRMADA'),
(8,  10, 'CONFIRMADA'),
(9,  10, 'CONFIRMADA'),
(11, 10, 'CONFIRMADA'),
(14, 10, 'CONFIRMADA');
-- Evento 11 - Palestra Ed. Financeira ENCERRADO (id_evento = 11)
INSERT INTO inscricao (id_usuario, id_evento, status) VALUES
(9,  11, 'CONFIRMADA'),
(10, 11, 'CONFIRMADA'),
(11, 11, 'CONFIRMADA'),
(12, 11, 'CONFIRMADA'),
(13, 11, 'CONFIRMADA'),
(14, 11, 'CONFIRMADA'),
(15, 11, 'CONFIRMADA'),
(16, 11, 'CONFIRMADA'),
(17, 11, 'CONFIRMADA'),
(18, 11, 'CANCELADA');
-- Evento 12 - Oficina Primeiros Socorros ENCERRADO (id_evento = 12)
INSERT INTO inscricao (id_usuario, id_evento, status) VALUES
(4,  12, 'CONFIRMADA'),
(5,  12, 'CONFIRMADA'),
(9,  12, 'CONFIRMADA'),
(10, 12, 'CONFIRMADA'),
(12, 12, 'CONFIRMADA'),
(14, 12, 'CONFIRMADA'),
(16, 12, 'CONFIRMADA'),
(20, 12, 'CONFIRMADA');
-- ---------- PARTICIPAÇÕES (check-in nos eventos encerrados) ----------
-- Evento 11 - Palestra Ed. Financeira (inscrições 39-47, excluindo cancelada 48)
INSERT INTO participacao (id_inscricao, data_checkin, data_checkout, presente, observacao) VALUES
(39, '2026-06-05 18:50:00', '2026-06-05 21:00:00', TRUE,  NULL),
(40, '2026-06-05 18:55:00', '2026-06-05 21:00:00', TRUE,  NULL),
(41, '2026-06-05 19:05:00', '2026-06-05 21:00:00', TRUE,  'Chegou com atraso'),
(42, '2026-06-05 18:45:00', '2026-06-05 20:30:00', TRUE,  'Saiu antes do término'),
(43, '2026-06-05 18:58:00', '2026-06-05 21:00:00', TRUE,  NULL),
(44, '2026-06-05 19:00:00', '2026-06-05 21:00:00', TRUE,  NULL),
(45, '2026-06-05 18:40:00', '2026-06-05 21:00:00', TRUE,  NULL),
(46, NULL,                   NULL,                   FALSE, 'Não compareceu'),
(47, '2026-06-05 19:10:00', '2026-06-05 21:00:00', TRUE,  'Chegou atrasado');
-- Evento 12 - Oficina Primeiros Socorros (inscrições 49-56)
INSERT INTO participacao (id_inscricao, data_checkin, data_checkout, presente, observacao) VALUES
(49, '2026-06-12 13:50:00', '2026-06-12 17:00:00', TRUE,  NULL),
(50, '2026-06-12 13:55:00', '2026-06-12 17:00:00', TRUE,  NULL),
(51, '2026-06-12 14:00:00', '2026-06-12 17:00:00', TRUE,  NULL),
(52, '2026-06-12 14:05:00', '2026-06-12 17:00:00', TRUE,  NULL),
(53, '2026-06-12 13:45:00', '2026-06-12 17:00:00', TRUE,  NULL),
(54, NULL,                   NULL,                   FALSE, 'Não compareceu'),
(55, '2026-06-12 14:10:00', '2026-06-12 17:00:00', TRUE,  'Chegou atrasado'),
(56, '2026-06-12 13:58:00', '2026-06-12 17:00:00', TRUE,  NULL);
-- ---------- VOLUNTÁRIOS EM EVENTOS ----------
INSERT INTO voluntario_evento (id_usuario, id_evento, funcao) VALUES
-- Mutirão de Limpeza
(4, 10, 'Coordenador de equipe'),
(5, 10, 'Distribuição de materiais'),
(6, 10, 'Registro fotográfico'),
(7, 10, 'Apoio logístico'),
(8, 10, 'Primeiros socorros'),
-- Palestra Sustentabilidade
(4, 1, 'Recepção e credenciamento'),
(5, 1, 'Apoio audiovisual'),
-- Seminário Direitos
(6, 7, 'Recepção e credenciamento'),
(7, 7, 'Organização de materiais'),
(8, 7, 'Apoio ao palestrante'),
-- Festival Cultural
(4, 8, 'Coordenação de palco'),
(5, 8, 'Bilheteria'),
(6, 8, 'Segurança do evento'),
(7, 8, 'Som e iluminação'),
(8, 8, 'Alimentação e bebidas'),
-- Eventos encerrados
(4, 11, 'Recepção'),
(5, 11, 'Apoio audiovisual'),
(6, 12, 'Organização de materiais'),
(7, 12, 'Recepção');
-- ---------- RELATÓRIOS ----------
INSERT INTO relatorio (id_evento, id_gerado_por, tipo_relatorio, titulo, conteudo, total_inscritos, total_presentes, total_ausentes) VALUES
(11, 1, 'PRESENCA',
 'Relatório de Presença - Palestra Educação Financeira',
 'A palestra sobre Educação Financeira para Famílias ocorreu no dia 05/06/2026 no Centro Comunitário São José. '
 'Dos 10 inscritos, 1 cancelou a inscrição e 1 não compareceu. A taxa de presença entre os confirmados foi de 88,9%. '
 'O público demonstrou grande interesse, com diversas perguntas ao final da apresentação.',
 10, 8, 2),
(11, 1, 'GERAL',
 'Relatório Geral - Palestra Educação Financeira',
 'Evento realizado com sucesso. A palestra abordou temas como controle de gastos, planejamento mensal e uso consciente do crédito. '
 'O palestrante foi o economista Dr. Marcos Ribeiro. Sugestões do público: realizar edição sobre investimentos e aposentadoria.',
 10, 8, 2),
(12, 2, 'PRESENCA',
 'Relatório de Presença - Oficina Primeiros Socorros',
 'A oficina de Primeiros Socorros ocorreu no dia 12/06/2026 no Salão Paroquial. '
 'Dos 8 inscritos, 6 compareceram e participaram integralmente. 1 participante chegou atrasado e 1 não compareceu. '
 'Taxa de presença: 75%.',
 8, 6, 2),
(12, 2, 'AVALIACAO',
 'Relatório de Avaliação - Oficina Primeiros Socorros',
 'A oficina recebeu avaliação média de 4,7/5,0 pelos participantes. '
 'Pontos positivos: didática do instrutor, material prático, simulações realistas. '
 'Pontos de melhoria: duração poderia ser maior, incluir módulo sobre engasgamento em crianças. '
 'Recomendação: realizar nova edição no segundo semestre.',
 8, 6, 2);
-- ============================================================
-- VIEWS ÚTEIS PARA O SISTEMA
-- ============================================================
-- View: Resumo de eventos com contagem de inscritos
CREATE OR REPLACE VIEW vw_resumo_eventos AS
SELECT
    e.id_evento,
    e.titulo,
    ce.nome AS categoria,
    e.data_hora,
    le.nome AS local_nome,
    e.capacidade,
    e.status,
    u.nome AS organizador,
    COUNT(DISTINCT CASE WHEN i.status = 'CONFIRMADA' THEN i.id_inscricao END) AS total_confirmados,
    COUNT(DISTINCT CASE WHEN i.status = 'PENDENTE'   THEN i.id_inscricao END) AS total_pendentes,
    (e.capacidade - COUNT(DISTINCT CASE WHEN i.status IN ('CONFIRMADA','PENDENTE') THEN i.id_inscricao END)) AS vagas_disponiveis
FROM evento e
JOIN categoria_evento ce ON e.id_categoria = ce.id_categoria
JOIN local_evento le     ON e.id_local     = le.id_local
JOIN usuario u           ON e.id_organizador = u.id_usuario
LEFT JOIN inscricao i    ON e.id_evento    = i.id_evento
GROUP BY e.id_evento, e.titulo, ce.nome, e.data_hora, le.nome, e.capacidade, e.status, u.nome;
-- View: Histórico de participação por usuário
CREATE OR REPLACE VIEW vw_historico_participacao AS
SELECT
    u.id_usuario,
    u.nome AS participante,
    u.tipo_usuario,
    e.titulo AS evento,
    e.data_hora,
    i.status AS status_inscricao,
    COALESCE(p.presente, FALSE) AS presente,
    p.data_checkin,
    p.observacao
FROM usuario u
JOIN inscricao i    ON u.id_usuario = i.id_usuario
JOIN evento e       ON i.id_evento  = e.id_evento
LEFT JOIN participacao p ON i.id_inscricao = p.id_inscricao
ORDER BY u.nome, e.data_hora;
-- ============================================================
-- FIM DO SCRIPT
-- ============================================================
