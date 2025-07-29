CREATE LOGIN PokeQueueApp WITH PASSWORD = '*f79ZVFm!=4Cx7h';

CREATE USER PokeQueueApp FOR LOGIN PokeQueueApp;

GRANT SELECT ON SCHEMA :: pokequeue to PokeQueueApp;
GRANT INSERT ON SCHEMA :: pokequeue to PokeQueueApp;
GRANT UPDATE ON SCHEMA :: pokequeue to PokeQueueApp;
GRANT DELETE ON SCHEMA :: pokequeue to PokeQueueApp;
GRANT EXECUTE ON SCHEMA :: pokequeue to PokeQueueApp;