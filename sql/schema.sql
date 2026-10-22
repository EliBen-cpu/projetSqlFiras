CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SCHEMA IF NOT EXISTS core;
CREATE SCHEMA IF NOT EXISTS audit;

DROP TABLE IF EXISTS audit.audit_log CASCADE;
DROP TABLE IF EXISTS core.fraud_alerts CASCADE;
DROP TABLE IF EXISTS core.transactions CASCADE;
DROP TABLE IF EXISTS core.transfers CASCADE;
DROP TABLE IF EXISTS core.accounts CASCADE;
DROP TABLE IF EXISTS core.customers CASCADE;

CREATE TABLE core.customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    phone VARCHAR(20),
    birth_date DATE NOT NULL CHECK (birth_date <= CURRENT_DATE - INTERVAL '18 years'),
    kyc_status VARCHAR(20) DEFAULT 'PENDING',
    risk_level VARCHAR(20) DEFAULT 'LOW',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE core.accounts (
    account_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES core.customers(customer_id) ON DELETE CASCADE,
    iban VARCHAR(34) UNIQUE NOT NULL,
    account_type VARCHAR(20) NOT NULL,
    balance DECIMAL(15,2) NOT NULL DEFAULT 0.00 CHECK (balance >= 0),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    opened_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE core.transfers (
    transfer_id SERIAL PRIMARY KEY,
    from_account_id INT REFERENCES core.accounts(account_id),
    to_account_id INT REFERENCES core.accounts(account_id),
    amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
    label VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CHECK (from_account_id <> to_account_id)
);

CREATE TABLE core.transactions (
    tx_id SERIAL PRIMARY KEY,
    account_id INT REFERENCES core.accounts(account_id),
    tx_type VARCHAR(10) NOT NULL CHECK (tx_type IN ('DEBIT', 'CREDIT')),
    amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
    balance_after DECIMAL(15,2) NOT NULL CHECK (balance_after >= 0),
    transfer_id INT REFERENCES core.transfers(transfer_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE core.fraud_alerts (
    alert_id SERIAL PRIMARY KEY,
    account_id INT REFERENCES core.accounts(account_id),
    tx_id INT REFERENCES core.transactions(tx_id),
    rule_code VARCHAR(50) NOT NULL,
    status VARCHAR(20) DEFAULT 'OPEN',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE audit.audit_log (
    log_id SERIAL PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    operation VARCHAR(10) NOT NULL,
    old_data JSONB,
    new_data JSONB,
    db_user VARCHAR(50) DEFAULT CURRENT_USER,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);