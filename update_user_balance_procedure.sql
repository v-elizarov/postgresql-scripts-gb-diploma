CREATE OR REPLACE PROCEDURE update_user_balance
(
	user_id integer, 
	operation boolean, 
	amount bigint
)
LANGUAGE plpgsql AS
$$
DECLARE 
	current_balance bigint;
BEGIN
	SELECT balance INTO current_balance FROM public.user WHERE "ID" = user_id;
-- 	RAISE NOTICE USING MESSAGE = operation;
	IF operation = true THEN
		UPDATE public.user 
		SET balance = current_balance + amount
		WHERE "ID" = user_id;	
	ELSE
		UPDATE public.user 
		SET balance = current_balance - amount
		WHERE "ID" = user_id;
	END IF;
END
$$;