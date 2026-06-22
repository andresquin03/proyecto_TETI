sap.ui.define([
    "sap/ui/core/Control",
    "sap/ui/dom/includeStylesheet"
], function (Control, includeStylesheet) {
    "use strict";

    // El control carga su propia hoja de estilos, de modo que es autocontenido
    // y se ve igual sin importar desde qué vista/página se use.
    includeStylesheet(sap.ui.require.toUrl("ns/incidents/control/CustomerBadge.css"));

    /**
     * CustomerBadge: control personalizado hecho a medida (no es un control estándar de Fiori).
     * Demuestra el uso del SDK de UI5 para extensibilidad: extiende sap.ui.core.Control,
     * define propiedades configurables y aporta su propio renderer.
     */
    return Control.extend("ns.incidents.control.CustomerBadge", {
        metadata: {
            properties: {
                // Propiedades configurables desde XML/JS
                name:  { type: "string", defaultValue: "" },
                email: { type: "string", defaultValue: "" },
                phone: { type: "string", defaultValue: "" }
            }
        },

        // Inicial del nombre para el avatar (ej. "Leanne" -> "L")
        _getInitial: function () {
            var sName = (this.getName() || "").trim();
            return sName ? sName.charAt(0).toUpperCase() : "?";
        },

        // Color de fondo determinístico derivado del nombre (mismo nombre -> mismo color)
        _getColor: function () {
            var sName = this.getName() || "";
            var iHash = 0;
            for (var i = 0; i < sName.length; i++) {
                iHash = sName.charCodeAt(i) + ((iHash << 5) - iHash);
            }
            return "hsl(" + (Math.abs(iHash) % 360) + ", 60%, 50%)";
        },

        renderer: {
            apiVersion: 2,
            render: function (oRm, oControl) {
                oRm.openStart("div", oControl);
                oRm.class("customerBadge");
                oRm.openEnd();

                // Avatar circular con la inicial del nombre
                oRm.openStart("span");
                oRm.class("customerBadgeAvatar");
                oRm.style("background-color", oControl._getColor());
                oRm.openEnd();
                oRm.text(oControl._getInitial());
                oRm.close("span");

                // Bloque de datos del cliente
                oRm.openStart("div");
                oRm.class("customerBadgeInfo");
                oRm.openEnd();

                oRm.openStart("span");
                oRm.class("customerBadgeName");
                oRm.openEnd();
                oRm.text(oControl.getName());
                oRm.close("span");

                oRm.openStart("span");
                oRm.class("customerBadgeEmail");
                oRm.openEnd();
                oRm.text(oControl.getEmail());
                oRm.close("span");

                if (oControl.getPhone()) {
                    oRm.openStart("span");
                    oRm.class("customerBadgePhone");
                    oRm.openEnd();
                    oRm.text("☎ " + oControl.getPhone());
                    oRm.close("span");
                }

                oRm.close("div"); // .customerBadgeInfo
                oRm.close("div"); // .customerBadge
            }
        }
    });
});
