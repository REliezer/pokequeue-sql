CREATE OR ALTER PROCEDURE pokequeue.delete_poke_request
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    BEGIN TRY
    	DELETE FROM pokequeue.requests
	    WHERE id = @id

        -- Si todo va bien, hacer commit
        COMMIT TRANSACTION;
        SELECT 'Request eliminado exitosamente.' AS mensaje;
    END TRY
    BEGIN CATCH
        -- En caso de error, hacer rollback y mostrar el error
        ROLLBACK TRANSACTION;
        THROW;
    -- Relanzar el error para que sea capturado fuera del procedimiento
    END CATCH
END;