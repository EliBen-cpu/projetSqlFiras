CREATE OR REPLACE FUNCTION audit.fn_log_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit.audit_log (table_name, operation, old_data, new_data)
    VALUES (
        TG_TABLE_NAME,
        TG_OP,
        CASE WHEN TG_OP IN ('UPDATE', 'DELETE') THEN to_jsonb(OLD) ELSE NULL END,
        CASE WHEN TG_OP IN ('INSERT', 'UPDATE') THEN to_jsonb(NEW) ELSE NULL END
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_audit_customers ON core.customers;
CREATE TRIGGER trg_audit_customers
AFTER INSERT OR UPDATE OR DELETE ON core.customers
FOR EACH ROW EXECUTE FUNCTION audit.fn_log_changes();

CREATE OR REPLACE FUNCTION core.fn_check_fraud()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.amount >= 5000.00 THEN
        INSERT INTO core.fraud_alerts (account_id, tx_id, rule_code)
        VALUES (NEW.account_id, NEW.tx_id, 'HIGH_AMOUNT_RETRAIT');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_detect_fraud ON core.transactions;
CREATE TRIGGER trg_detect_fraud
AFTER INSERT ON core.transactions
FOR EACH ROW EXECUTE FUNCTION core.fn_check_fraud();