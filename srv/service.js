const cds = require('@sap/cds');
const dayjs = require('dayjs'); // librería NPM externa para formato de fechas

const EXTERNAL_CUSTOMERS_API = 'https://jsonplaceholder.typicode.com/users';

// Estados que se consideran "cerrados" (Resolved / Closed)
const CLOSED_STATUS_CODES = ['R', 'C'];

// --- Lógica de negocio pura (reutilizable y testeable) ---

function validateTitle(title) {
    const value = (title ?? '').trim();
    if (value.length < 5) {
        return 'El título debe tener al menos 5 caracteres';
    }
    return null;
}

function computeOpenStatus(statusCode) {
    return CLOSED_STATUS_CODES.includes(statusCode) ? 'cerrado' : 'abierto';
}

module.exports = cds.service.impl(async function () {
    const { Incidents } = this.entities;

    // Validación custom antes de crear un incidente
    this.before('CREATE', 'Incidents', (req) => {
        const error = validateTitle(req.data.title);
        if (error) req.error({ code: 'TITLE_TOO_SHORT', message: error, target: 'title', status: 400 });
    });

    // Campo virtual calculado en JS (no en SQL)
    this.after('READ', 'Incidents', (incidents) => {
        for (const incident of [].concat(incidents)) {
            if (incident && incident.status_code !== undefined) {
                incident.isOpen = computeOpenStatus(incident.status_code);
            }
        }
    });

    this.on('READ', 'ExternalCustomers', async () => {
        const response = await fetch(EXTERNAL_CUSTOMERS_API);
        const users = await response.json();
        return users.map(user => ({
            ID    : String(user.id),
            name  : user.name,
            email : user.email,
            phone : user.phone,
        }));
    });

    this.on('exportIncidentsCSV', async () => {
        const incidents = await SELECT.from(Incidents);
        const columns = ['ID', 'title', 'urgency_code', 'status_code', 'customer_ID', 'createdAt'];
        const rows = incidents.map(row => columns.map(col => {
            // dayjs formatea la fecha de creación de forma legible
            if (col === 'createdAt' && row.createdAt) return dayjs(row.createdAt).format('YYYY-MM-DD HH:mm');
            return row[col] ?? '';
        }).join(','));
        return [columns.join(','), ...rows].join('\n');
    });

    this.on('exportIncidentsJSON', async () => {
        const incidents = await SELECT.from(Incidents);
        return JSON.stringify(incidents);
    });
});

// Exportar la lógica pura para tests unitarios
module.exports.validateTitle = validateTitle;
module.exports.computeOpenStatus = computeOpenStatus;
