using {sap.capire.incidents as my} from '../db/schema';

/**
 * Service used by support personell, i.e. the incidents' 'processors'.
 */
@title: 'Processor Service - Incident Management'
service ProcessorService {
    @odata.draft.enabled // habilita el flujo CRUD completo (crear/editar/borrar) en Fiori Elements
    entity Incidents as projection on my.Incidents {
        *,
        // Criticality calculada en SQL (siempre disponible al leer la lista, sin depender de qué columnas pida la UI).
        // Convención Fiori: 1=Negative(rojo) 2=Critical(naranja) 3=Positive(verde) 0=Neutral
        case urgency.code when 'H' then 1 when 'M' then 2 when 'L' then 3 else 0 end as urgencyCriticality : Integer,
        case status.code  when 'R' then 3 when 'C' then 3 when 'H' then 0 else 2 end as statusCriticality  : Integer,
    };

    @readonly
    entity Customers as projection on my.Customers;

    @readonly
    @cds.persistence.skip
    entity ExternalCustomers {
        key ID    : String;
            name  : String;
            email : String;
            phone : String;
    }

    action exportIncidentsCSV()  returns String;
    action exportIncidentsJSON() returns String;
}

/**
 * Service used by administrators to manage customers and incidents.
 */
@title: 'Admin Service - Incident Management'
service AdminService {
    entity Customers as projection on my.Customers;
    entity Incidents as projection on my.Incidents;
}
