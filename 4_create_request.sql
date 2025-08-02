CREATE OR ALTER PROCEDURE pokequeue.create_poke_request(
    @type NVARCHAR(255)
)
AS 

SET NOCOUNT ON;

INSERT INTO pokequeue.requests(
    [type],
    [url],
    id_status
) VALUES(
    @type,
    '',
    ( SELECT id FROM pokequeue.status WHERE description = 'sent' )
)

SELECT max(id) AS id FROM pokequeue.requests;