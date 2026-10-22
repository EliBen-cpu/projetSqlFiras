CREATE OR REPLACE VIEW core.v_customers_public AS
SELECT customer_id, first_name, last_name, kyc_status, risk_level
FROM core.customers;

CREATE OR REPLACE VIEW core.v_account_summaries AS
SELECT a.account_id, a.iban, a.balance, c.last_name, c.first_name
FROM core.accounts a
JOIN core.customers c ON a.customer_id = c.customer_id;