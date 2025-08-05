CREATE OR ALTER PROCEDURE pokequeue.create_poke_request(
    @type NVARCHAR(255),
    @sample_size INT = NULL
)
AS 

SET NOCOUNT ON;

INSERT INTO pokequeue.requests(
    [type],
    [url],
    sample_size,
    id_status
) VALUES(
    @type,
    '',
    @sample_size,
    ( SELECT id FROM pokequeue.status WHERE description = 'sent' )
)

SELECT max(id) AS id FROM pokequeue.requests;