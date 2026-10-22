TRUNCATE core.fraud_alerts, core.transactions, core.transfers, core.accounts, core.customers RESTART IDENTITY CASCADE;

INSERT INTO core.customers (first_name, last_name, email, phone, birth_date, kyc_status, risk_level)
VALUES 
('Alice', 'Dupont', 'alice.dupont@email.com', '0601020304', '1995-05-12', 'VERIFIED', 'LOW'),
('Bob', 'Martin', 'bob.martin@email.com', '0611223344', '1988-11-23', 'VERIFIED', 'MEDIUM'),
('Charlie', 'Bernard', 'charlie.bernard@email.com', '0699887766', '2001-02-15', 'PENDING', 'LOW');

INSERT INTO core.accounts (customer_id, iban, account_type, balance, status)
VALUES 
(1, 'FR7630001007941234567890185', 'COURANT', 5000.00, 'ACTIVE'),
(2, 'FR7630001007949876543210142', 'COURANT', 1200.00, 'ACTIVE'),
(3, 'FR7630001007945556667770199', 'EPARGNE', 350.00, 'ACTIVE');

INSERT INTO core.transfers (from_account_id, to_account_id, amount, label)
VALUES (1, 2, 200.00, 'Remboursement resto');

INSERT INTO core.transactions (account_id, tx_type, amount, balance_after, transfer_id)
VALUES 
(1, 'DEBIT', 200.00, 4800.00, 1),
(2, 'CREDIT', 200.00, 1400.00, 1);