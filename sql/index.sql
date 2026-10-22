CREATE INDEX IF NOT EXISTS idx_accounts_customer ON core.accounts(customer_id);
CREATE INDEX IF NOT EXISTS idx_transactions_account ON core.transactions(account_id);
CREATE INDEX IF NOT EXISTS idx_transactions_created_at ON core.transactions(created_at);
CREATE INDEX IF NOT EXISTS idx_transfers_accounts ON core.transfers(from_account_id, to_account_id);