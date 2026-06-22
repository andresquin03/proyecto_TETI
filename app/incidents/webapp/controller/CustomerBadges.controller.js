sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel"
], function (Controller, JSONModel) {
    "use strict";

    return Controller.extend("ns.incidents.controller.CustomerBadges", {
        onInit: function () {
            // Carga los datos directamente del servicio OData de CAP.
            // La respuesta OData V4 tiene forma { "@odata.context": ..., "value": [ ... ] },
            // por eso la vista bindea la agregación a "/value".
            var oModel = new JSONModel();
            oModel.loadData("/odata/v4/processor/ExternalCustomers");
            this.getView().setModel(oModel);
        }
    });
});
