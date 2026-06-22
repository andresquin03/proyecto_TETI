using { ProcessorService, AdminService } from './service';

/**
 * Autorización basada en roles (enforced solo en producción vía XSUAA).
 * En desarrollo/test la auth es 'dummy', por lo que todas las peticiones
 * pasan como usuario privilegiado y NO se rompe cds watch / npm test.
 *
 *  - Viewer : acceso de SOLO LECTURA a Incidents.
 *  - Admin  : acceso COMPLETO (incluye el AdminService entero).
 */

annotate ProcessorService.Incidents with @(restrict: [
    { grant: 'READ', to: 'Viewer' },
    { grant: '*',    to: 'Admin'  }
]);

annotate AdminService with @(requires: 'Admin');
