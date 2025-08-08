# PokeQueue SQL

Sistema de gestión de colas de solicitudes para el procesamiento de datos Pokémon desarrollado para la materia Sistemas Expertos II PAC 2025.

## 🏗️ Arquitectura del Sistema PokeQueue

Este repositorio es parte de un ecosistema completo de microservicios para el procesamiento de reportes de Pokémon. El sistema completo está compuesto por los siguientes componentes:

### 🔗 Repositorios Relacionados

| Componente | Repositorio | Descripción |
|------------|-------------|-------------|
| **Frontend** | [PokeQueue UI](https://github.com/REliezer/pokequeue-ui) | Interfaz de usuario web para solicitar y gestionar reportes de Pokémon |
| **API REST** | [PokeQueue API](https://github.com/REliezer/pokequeueAPI) | API principal que gestiona solicitudes de reportes y coordinación del sistema |
| **Azure Functions** | [PokeQueue Functions](https://github.com/REliezer/pokequeue-function) | Procesamiento asíncrono de reportes |
| **Base de Datos** | [PokeQueue SQL Scripts](https://github.com/REliezer/pokequeue-sql) | Este repositorio - Scripts SQL para la configuración y mantenimiento de la base de datos |
| **Infraestructura** | [PokeQueue Terraform](https://github.com/REliezer/pokequeue-terrafom) | Configuración de infraestructura como código (IaC) |

### 🔄 Flujo de Datos del Sistema Completo

1. **PokeQueue UI** → Usuario solicita reporte desde la interfaz web
2. **PokeQueue UI** → Envía solicitud a **PokeQueue API**
3. **PokeQueue API** → Valida la solicitud y la guarda en la base de datos
4. **PokeQueue API** → Envía mensaje a la cola de Azure Storage
5. **PokeQueue Function** → Procesa el mensaje de la cola
6. **PokeQueue Function** → Consulta PokéAPI y genera el reporte CSV
7. **PokeQueue Function** → Almacena el CSV en Azure Blob Storage
8. **PokeQueue Function** → Notifica el estado a **PokeQueue API**
9. **PokeQueue UI** → Consulta el estado y permite descargar el reporte terminado

### 🏗️ Diagrama de Arquitectura

```
   ┌─────────────────┐
   │   PokeQueue UI  │
   │ (Frontend Web)  │
   └─────────┼───────┘
             │
             ▼ HTTP/REST
  ┌─────────────────┐    ┌─────────────────┐
  │  PokeQueue API  │────│   Azure SQL DB  │
  │   (REST API)    │    │  (Persistencia) │
  └─────────┼───────┘    └─────────────────┘
            │
            ▼ Queue Message
   ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
   │  Azure Storage  │────│ PokeQueue Func  │────│   Azure Blob    │
   │     Queue       │    │ (Procesamiento) │    │    Storage      │
   └─────────────────┘    └─────────┼───────┘    └─────────────────┘
                                    │
                                    ▼ HTTP API Call
                           ┌─────────────────┐
                           │    PokéAPI      │
                           │ (Datos Pokémon) │
                           └─────────────────┘
```
## Descripción

PokeQueue SQL es un sistema de base de datos diseñado para gestionar colas de solicitudes de procesamiento de datos relacionados con Pokémon. El sistema permite crear, actualizar, eliminar y rastrear el estado de las solicitudes de manera eficiente.

## Características Principales

- ✅ **Gestión de Estados**: Sistema de estados para rastrear solicitudes (sent, inprogress, completed, failed)
- ✅ **Procedimientos Almacenados**: Operaciones CRUD optimizadas mediante stored procedures
- ✅ **Seguridad**: Usuario dedicado con permisos específicos para la aplicación
- ✅ **Timestamps Automáticos**: Seguimiento automático de fechas de creación y actualización
- ✅ **Transacciones Seguras**: Manejo de errores y rollback automático

## Estructura de la Base de Datos

### Esquema: `pokequeue`

#### Tablas Principales

##### 1. `status`
Gestiona los diferentes estados de las solicitudes.
```sql
- id (INT IDENTITY, PK)
- description (VARCHAR(255))
```

**Estados disponibles:**
- `sent`: Solicitud enviada
- `inprogress`: En proceso
- `completed`: Completada
- `failed`: Fallida

##### 2. `requests`
Almacena las solicitudes de procesamiento.
```sql
- id (INT IDENTITY, PK)
- type (NVARCHAR(255))
- id_status (INT, FK -> status.id)
- url (NVARCHAR(1000))
- sample_size (INT, NULLABLE)
- created (DATETIME, DEFAULT: GETDATE())
- updated (DATETIME, DEFAULT: GETDATE())
```

##### 3. `MESSAGES`
Tabla de metadatos del proyecto.
```sql
- id (INT IDENTITY, PK)
- message (VARCHAR(255))
```

## Instalación

### Prerrequisitos

- SQL Server 2016 o superior
- Permisos de administrador para crear esquemas y usuarios

### Pasos de Instalación

1. **Clonar o descargar el proyecto**
   ```bash
   git clone [repository-url]
   cd pokequeue-sql
   ```

2. **Ejecutar los scripts en orden:**

   ```sql
   -- 1. Crear esquema y tabla inicial
   1_schema_first_table.sql
   
   -- 2. Crear usuario y permisos
   2_users.sql
   
   -- 3. Crear tablas principales
   3_tables.sql
   
   -- 4. Crear procedimiento de creación
   4_create_request.sql
   
   -- 5. Crear procedimiento de actualización
   5_update_request.sql
   
   -- 6. Crear procedimiento de eliminación
   6_delete_one_request.sql
   ```

3. **Verificar la instalación**
   ```sql
   SELECT * FROM pokequeue.MESSAGES;
   SELECT * FROM pokequeue.status;
   ```

## Uso

### Procedimientos Almacenados Disponibles

#### 1. Crear Solicitud
```sql
EXEC pokequeue.create_poke_request 
    @type = 'pokemon_data',
    @sample_size = 100;
```

**Parámetros:**
- `@type`: Tipo de solicitud (NVARCHAR(255))
- `@sample_size`: Tamaño de muestra opcional (INT)

**Retorna:** ID de la solicitud creada

#### 2. Actualizar Solicitud
```sql
EXEC pokequeue.update_poke_request
    @id = 1,
    @status = 'completed',
    @url = 'https://api.pokemon.com/result/123';
```

**Parámetros:**
- `@id`: ID de la solicitud (INT)
- `@status`: Nuevo estado ('sent', 'inprogress', 'completed', 'failed')
- `@url`: URL del resultado (NVARCHAR(1000))

#### 3. Eliminar Solicitud
```sql
EXEC pokequeue.delete_poke_request @id = 1;
```

**Parámetros:**
- `@id`: ID de la solicitud a eliminar (INT)

## 🚀 Instalación Completa del Sistema PokeQueue

Para desplegar el sistema completo, necesitas configurar todos los componentes en el siguiente orden:

### 1. Infraestructura (Terraform)
```bash
# Clonar el repositorio de infraestructura
git clone https://github.com/REliezer/pokequeue-terrafom.git
cd pokequeue-terrafom

# Configurar variables de Terraform
terraform init
terraform plan
terraform apply
```

### 2. Base de Datos (SQL Scripts) (Este Repositorio)
```bash
# Clonar el repositorio de base de datos
git clone https://github.com/REliezer/pokequeue-sql.git
cd pokequeue-sql

# Ejecutar scripts SQL en Azure SQL Database
```

### 3. API REST
```bash
# Clonar y desplegar la API
git clone https://github.com/REliezer/pokequeueAPI.git
cd pokequeueAPI

# Seguir las instrucciones del README de la API
```

### 4. Azure Functions
```bash
# Clonar este repositorio
git clone https://github.com/REliezer/pokequeue-function.git
cd pokequeue-function

# Seguir las instrucciones de despliegue
```

### 5. Frontend UI
```bash
# Clonar y desplegar el frontend
git clone https://github.com/REliezer/pokequeue-ui.git
cd pokequeue-ui

# Seguir las instrucciones del README del UI para configuración y despliegue
```

## Seguridad

### Usuario de Aplicación

Se crea un usuario específico `PokeQueueApp` con permisos limitados:

- **SELECT**: Para consultar datos
- **INSERT**: Para crear nuevas solicitudes
- **UPDATE**: Para modificar estados y URLs
- **DELETE**: Para eliminar solicitudes
- **EXECUTE**: Para ejecutar procedimientos almacenados

### Contraseña
- Usuario: `PokeQueueApp`
- Contraseña: `*f79ZVFm!=4Cx7h`

> ⚠️ **Importante**: Cambiar la contraseña por defecto en producción.

## Estructura de Archivos

```
pokequeue-sql/
├── 1_schema_first_table.sql    # Esquema inicial y tabla MESSAGES
├── 2_users.sql                 # Creación de usuario y permisos
├── 3_tables.sql                # Tablas principales (status, requests)
├── 4_create_request.sql        # Procedimiento para crear solicitudes
├── 5_update_request.sql        # Procedimiento para actualizar solicitudes
├── 6_delete_one_request.sql    # Procedimiento para eliminar solicitudes
├── .gitignore                  # Archivos ignorados por Git
└── README.md                   # Este archivo
```

## Contribución

1. Fork el proyecto
2. Crear una rama para tu funcionalidad (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir un Pull Request

## Licencia

Este proyecto es parte de un trabajo académico para Sistemas Expertos II PAC 2025.

---

