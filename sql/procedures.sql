CREATE OR REPLACE PROCEDURE core.virement(
    p_from_acc INT,
    p_to_acc INT,
    p_amount DECIMAL(15,2),
    p_label VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_from_bal DECIMAL(15,2);
    v_to_bal DECIMAL(15,2);
    v_transfer_id INT;
BEGIN
    IF p_from_acc = p_to_acc THEN
        RAISE EXCEPTION 'Comptes identique interdit';
    END IF;

    SELECT balance INTO v_from_bal FROM core.accounts WHERE account_id = p_from_acc FOR UPDATE;
    SELECT balance INTO v_to_bal FROM core.accounts WHERE account_id = p_to_acc FOR UPDATE;

    IF v_from_bal < p_amount THEN
        RAISE EXCEPTION 'Solde insuffisant';
    END IF;

    UPDATE core.accounts SET balance = balance - p_amount WHERE account_id = p_from_acc;
    UPDATE core.accounts SET balance = balance + p_amount WHERE account_id = p_to_acc;

    INSERT INTO core.transfers (from_account_id, to_account_id, amount, label)
    VALUES (p_from_acc, p_to_acc, p_amount, p_label)
    RETURNING transfer_id INTO v_transfer_id;

    INSERT INTO core.transactions (account_id, tx_type, amount, balance_after, transfer_id)
    VALUES (p_from_acc, 'DEBIT', p_amount, v_from_bal - p_amount, v_transfer_id);

    INSERT INTO core.transactions (account_id, tx_type, amount, balance_after, transfer_id)
    VALUES (p_to_acc, 'CREDIT', p_amount, v_to_bal + p_amount, v_transfer_id);
END;
$$;