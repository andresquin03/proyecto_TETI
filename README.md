# ProyectoTETI - Gestión de Incidentes (SAP Build)

Aplicación de gestión de incidentes (*Incident Management*) construida con **SAP Build Code** (CAP + Fiori Elements).
Desarrollada como parte de la evaluación **T-CHECK** de la plataforma **SAP Build** para el curso **TETI 2026**
(Facultad de Ingeniería, UDELAR).

## Demo en vivo (Cloud Foundry)

- **App Fiori (incidentes)**: https://347c56aftrial-dev-proyectoteti.cfapps.us10-001.hana.ondemand.com/index.html
- **Custom control (badges)**: https://347c56aftrial-dev-proyectoteti.cfapps.us10-001.hana.ondemand.com/badges.html

## Stack

- **SAP BTP** (Business Technology Platform), Cloud Foundry
- **SAP Build Code**, entorno de desarrollo
- **SAP CAP** (Cloud Application Programming Model, Node.js)
- **SAP Fiori Elements** (UI5)
- **SAP Build Process Automation**, proceso de aprobación
- **Joule**, asistente de IA de la plataforma
- **PostgreSQL** (producción / Supabase) y **SQLite** (local)
- **XSUAA**, autenticación y autorización (roles)

## Estructura del proyecto

| Carpeta | Contenido |
|---------|-----------|
| `db/`   | Modelo de dominio (CDS) y datos de ejemplo (CSV) |
| `srv/`  | Servicios CAP, lógica de negocio y autorización |
| `app/`  | UI Fiori Elements (`incidents/`) y App Router (`router/`) |

## Cómo correr en local

Usa **SQLite** en memoria, sin configuración adicional:

```bash
npm install
cds watch
```

La app queda disponible en `http://localhost:4004`.

## Funcionalidades implementadas

- **CRUD de incidentes** con UI Fiori Elements (List Report + Object Page).
- **Integración con API externa** (`ExternalCustomers`, vía `fetch` a un servicio REST público).
- **Lógica de negocio custom**: validación de título, campo virtual calculado (`isOpen`) y acciones de exportación (`exportIncidentsCSV` / `exportIncidentsJSON`).
- **Custom control UI5 propio** (extensibilidad con el SDK de UI5): ver sección siguiente.
- **Tests automatizados**: unitarios de servicio y journeys de integración de UI (OPA5).
- **Despliegue a Cloud Foundry** mediante MTA, con **XSUAA** (roles *Viewer* / *Admin*) y **PostgreSQL gestionado**.

## Custom control UI5 (extensibilidad)

Para demostrar el uso del SDK de UI5 en componentes personalizados, el proyecto incluye un control propio
`CustomerBadge` que extiende `sap.ui.core.Control`, con sus propias propiedades, renderer y estilo a medida.

- **Control**: [`app/incidents/webapp/control/CustomerBadge.js`](app/incidents/webapp/control/CustomerBadge.js)
  - Propiedades configurables: `name`, `email`, `phone`.
  - Renderer propio con `RenderManager` que genera HTML a medida (avatar circular con la inicial + datos del cliente).
  - Estilo propio en [`CustomerBadge.css`](app/incidents/webapp/control/CustomerBadge.css): tarjeta con borde redondeado, sombra y color de avatar derivado del nombre.
- **Página de demostración** (standalone, fuera del flujo Fiori Elements):
  [`app/incidents/webapp/badges.html`](app/incidents/webapp/badges.html), que monta la vista XML
  [`view/CustomerBadges.view.xml`](app/incidents/webapp/view/CustomerBadges.view.xml). Lista los `ExternalCustomers`
  del servicio OData y renderiza cada uno con `CustomerBadge`.

Con `cds watch` corriendo, la página queda accesible en:

```
http://localhost:4004/ns.incidents/badges.html
```

UI5 se carga desde el CDN (sin compilar UI5), igual que el resto de la app.

## Configuración

Las credenciales de base de datos **no se versionan**: van en `.cdsrc-private.json` (excluido por `.gitignore`).
Para las variables de conexión, ver la plantilla [`.env.example`](.env.example).

---

*Trabajo académico del curso TETI 2026, Facultad de Ingeniería, UDELAR.*
