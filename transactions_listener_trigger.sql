CREATE OR REPLACE FUNCTION on_balance_changed()
RETURNS trigger 
LANGUAGE plpgsql AS
$$
BEGIN
	CALL update_user_balance(
		NEW.user_id, 
		NEW.operation_type,
		NEW.amount
	);
	RETURN NEW;
END
$$;

CREATE OR REPLACE TRIGGER transactions_listener 
	AFTER INSERT ON public.transaction
FOR EACH ROW
EXECUTE PROCEDURE on_balance_changed();