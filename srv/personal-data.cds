using { sap.capire.incidents as my } from '../db/schema';

/**
 * Anotaciones de Datos Personales (GDPR) que alimentan a @cap-js/audit-logging.
 *
 * Disparan automáticamente, sin código:
 *   - Lectura de campos @PersonalData.IsPotentiallySensitive  -> log "data-access"
 *   - Cambios en campos @PersonalData.IsPotentiallyPersonal    -> log "data-modification"
 *
 * MODO ACTUAL: `audit-log-to-console` (ver cds.requires.audit-log en package.json),
 * tanto en development como en production. Los eventos se escriben al stdout de la
 * app (`cf logs ProyectoTETI-srv`). NO se usa kind `audit-log-to-restv2` porque el
 * servicio de ESCRITURA `auditlog` (plan premium) no está disponible en el trial;
 * solo existe `auditlog-management` (lectura) y `auditlog-viewer` (visor). Por eso
 * los eventos NO aparecen en el Audit Log Viewer, pero sí quedan registrados y la
 * app no falla por ausencia de binding.
 *
 * El modelo identifica al SUJETO de datos:
 *   - Customers ES el sujeto            -> EntitySemantics: 'DataSubject'
 *   - Addresses son DETALLES del sujeto -> EntitySemantics: 'DataSubjectDetails'
 *   - El campo/asociación que apunta al sujeto -> FieldSemantics: 'DataSubjectID'
 */

annotate my.Customers with @PersonalData.EntitySemantics: 'DataSubject'
                          @PersonalData.DataSubjectRole : 'Customer' {
  ID           @PersonalData.FieldSemantics: 'DataSubjectID';
  firstName    @PersonalData.IsPotentiallyPersonal;
  lastName     @PersonalData.IsPotentiallyPersonal;
  email        @PersonalData.IsPotentiallyPersonal;
  phone        @PersonalData.IsPotentiallyPersonal;
  creditCardNo @PersonalData.IsPotentiallySensitive;
}

annotate my.Addresses with @PersonalData.EntitySemantics: 'DataSubjectDetails' {
  customer      @PersonalData.FieldSemantics: 'DataSubjectID';
  city          @PersonalData.IsPotentiallyPersonal;
  postCode      @PersonalData.IsPotentiallyPersonal;
  streetAddress @PersonalData.IsPotentiallyPersonal;
}
