CALL core.virement(1, 2, 500.00, 'Test virement NovaBank');

SELECT * FROM core.accounts WHERE account_id IN (1, 2);

INSERT INTO core.transactions (account_id, tx_type, amount, balance_after)
VALUES (1, 'DEBIT', 6000.00, 3700.00);

SELECT * FROM core.fraud_alerts;
SELECT * FROM audit.audit_log;