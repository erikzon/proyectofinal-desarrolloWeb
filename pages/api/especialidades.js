import sql from "mssql/msnodesqlv8";
require('dotenv').config()

export default async function handler(req, res) {

  var config = {
    database: process.env.DATABASE,
    server: process.env.SERVER,
    user: process.env.USERDB,
    password: process.env.PASSWORD,
    port: process.env.PORT,
    driver: process.env.DRIVER,
    options: {
      trustedConnection: process.env.TRUSTED_CONNECTION === 'true',
    },
  };

  await sql.connect(config); // Conectar a la base de datos
  var request = new sql.Request();
  if (req.method === "GET") {
    await request.query(
      `select ID_Especialida as value, Nombre as label from Especialidad`,
      function (err, recordSet) {
        if (err) {
          res.status(400).json({ respuesta: 0 });
        } else {
          res.status(200).json(recordSet.recordset);
        }
      }
    );
  }
}
