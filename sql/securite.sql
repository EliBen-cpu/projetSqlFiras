DO $$
BEGIN
    IF EXISTS (SELECT FROM pg_roles WHERE rolname = 'analyste') THEN
        REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA core, audit FROM analyste;
        DROP ROLE analyste;
    END IF;
    IF EXISTS (SELECT FROM pg_roles WHERE rolname = 'support') THEN
        REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA core, audit FROM support;
        DROP ROLE support;
    END IF;
    IF EXISTS (SELECT FROM pg_roles WHERE rolname = 'appli') THEN
        REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA core, audit FROM appli;
        DROP ROLE appli;
    END IF;
    IF EXISTS (SELECT FROM pg_roles WHERE rolname = 'auditeur') THEN
        REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA core, audit FROM auditeur;
        DROP ROLE auditeur;
    END IF;
END $$;

CREATE ROLE analyste WITH LOGIN PASSWORD 'AnalystePass2026!';
CREATE ROLE support WITH LOGIN PASSWORD 'SupportPass2026!';
CREATE ROLE appli WITH LOGIN PASSWORD 'AppliPass2026!';
CREATE ROLE auditeur WITH LOGIN PASSWORD 'AuditeurPass2026!';

GRANT USAGE ON SCHEMA core TO analyste, support, appli, auditeur;
GRANT USAGE ON SCHEMA audit TO auditeur;

GRANT SELECT ON core.transactions, core.transfers, core.accounts TO analyste;
GRANT SELECT, UPDATE (phone, kyc_status) ON core.customers TO support;
GRANT SELECT ON core.accounts TO support;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA core TO appli;
GRANT SELECT ON ALL TABLES IN SCHEMA core TO auditeur;
GRANT SELECT ON ALL TABLES IN SCHEMA audit TO auditeur;