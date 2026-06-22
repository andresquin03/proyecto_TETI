// Deploy del esquema a Postgres (Supabase) usando el @sap/cds LOCAL del proyecto.
// Evita el cds global (bun) que no resuelve @cap-js/postgres. Uso local contra Supabase.
// Las credenciales viven bajo el perfil [supabase] en .cdsrc-private.json (gitignored).
process.env.CDS_ENV = 'supabase';
const cds = require('@sap/cds');

(async () => {
  const csn = await cds.load(['db', 'srv']);
  const db = await cds.connect.to('db');
  console.log('db kind:', cds.env.requires.db && cds.env.requires.db.kind);
  await cds.deploy(csn).to(db);
  console.log('DEPLOY OK ✅');
  process.exit(0);
})().catch((e) => {
  console.error('DEPLOY FAIL ❌:', e.message);
  process.exit(1);
});
