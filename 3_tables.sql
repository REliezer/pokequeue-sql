CREATE TABLE pokequeue.[status](
    id INT IDENTITY(1,1) PRIMARY KEY,
    [description] VARCHAR(255) NOT NULL
)

INSERT INTO pokequeue.[status] ([description]) 
VALUES ('sent'),('inprogress'),('completed'),('failed');

CREATE TABLE pokequeue.[requests](
    id INT IDENTITY(1,1) PRIMARY KEY,
    [type] NVARCHAR(255) NOT NULL,
    id_status INT NOT NULL,
    [url] NVARCHAR(1000) NOT NULL, 
    created DATETIME DEFAULT GETDATE(),
    updated DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_status) REFERENCES pokequeue.[status](id)
)