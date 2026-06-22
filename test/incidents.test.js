const cds = require('@sap/cds');
const { validateTitle, computeOpenStatus } = require('../srv/service');

jest.setTimeout(30000);

// --- Tests unitarios de la lógica de negocio pura ---
describe('Lógica de negocio (unitarios)', () => {
    describe('validateTitle', () => {
        test('acepta un título válido (>= 5 caracteres)', () => {
            expect(validateTitle('Pantalla rota')).toBeNull();
        });

        test('rechaza un título demasiado corto', () => {
            expect(validateTitle('abc')).toMatch(/al menos 5/);
        });

        test('rechaza un título vacío', () => {
            expect(validateTitle('')).toMatch(/al menos 5/);
        });

        test('rechaza un título nulo/undefined', () => {
            expect(validateTitle(undefined)).toMatch(/al menos 5/);
            expect(validateTitle(null)).toMatch(/al menos 5/);
        });

        test('ignora espacios en blanco al medir la longitud', () => {
            expect(validateTitle('  ab  ')).toMatch(/al menos 5/);
        });
    });

    describe('computeOpenStatus', () => {
        test('estados nuevos/en proceso => abierto', () => {
            expect(computeOpenStatus('N')).toBe('abierto');
            expect(computeOpenStatus('I')).toBe('abierto');
            expect(computeOpenStatus('H')).toBe('abierto');
        });

        test('estados resueltos/cerrados => cerrado', () => {
            expect(computeOpenStatus('R')).toBe('cerrado');
            expect(computeOpenStatus('C')).toBe('cerrado');
        });
    });
});

// --- Tests de integración sobre el servicio CAP (handlers reales) ---
// Incidents es draft-enabled: crear = POST (borrador) + draftActivate (guardar).
// La validación de negocio se dispara al ACTIVAR el borrador (UX estándar de Fiori).
describe('ProcessorService.Incidents (integración, draft)', () => {
    const { POST, GET } = cds.test(__dirname + '/..');

    const base = '/odata/v4/processor/Incidents';
    const activate = (id) =>
        POST(`${base}(ID=${id},IsActiveEntity=false)/ProcessorService.draftActivate`, {});

    // Crea un borrador, lo activa y devuelve el registro activo leído.
    async function createIncident(data) {
        const { data: draft } = await POST(base, data);
        await activate(draft.ID);
        const { data: active } = await GET(`${base}(ID=${draft.ID},IsActiveEntity=true)`);
        return active;
    }

    test('crea un incidente con título válido y calcula isOpen', async () => {
        const read = await createIncident({ title: 'Solar panel broken' });
        expect(read.status_code).toBe('N');
        expect(read.isOpen).toBe('abierto');
        expect(read.statusCriticality).toBe(2);
        expect(read.urgencyCriticality).toBe(2); // urgencia por defecto = M
    });

    test('un incidente cerrado se calcula como "cerrado"', async () => {
        const read = await createIncident({
            title: 'Issue already resolved',
            status_code: 'C',
        });
        expect(read.isOpen).toBe('cerrado');
        expect(read.statusCriticality).toBe(3); // verde
    });

    test('urgencia alta => criticality 1 (rojo), calculada en SQL', async () => {
        const read = await createIncident({
            title: 'High urgency incident',
            urgency_code: 'H',
        });
        expect(read.urgencyCriticality).toBe(1);
    });

    test('rechaza al guardar un borrador con título demasiado corto', async () => {
        const { data: draft } = await POST(base, { title: 'abc' });
        await expect(activate(draft.ID)).rejects.toMatchObject({ response: { status: 400 } });
    });

    test('rechaza al guardar un borrador con título vacío', async () => {
        const { data: draft } = await POST(base, { title: '' });
        await expect(activate(draft.ID)).rejects.toMatchObject({ response: { status: 400 } });
    });
});
