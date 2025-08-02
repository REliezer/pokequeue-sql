CREATE OR ALTER PROCEDURE pokequeue.update_poke_request(
    @id INT, 
    @status  NVARCHAR(255), 
    @url NVARCHAR(1000)
)
AS

SET NOCOUNT ON;

UPDATE pokequeue.requests
set id_status = ( SELECT id FROM pokequeue.status WHERE description = @status ), 
    url = @url, 
    updated = GETDATE()
WHERE id = @id;

SELECT 1 AS completed;