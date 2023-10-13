require('dotenv').config()
import sql from "mssql/msnodesqlv8";

export default async function handler(req, res) {
  var config = {
    database: process.env.DATABASE,
    server: process.env.NEXT_PUBLIC_SERVER,
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
      `select 1 as respuesta from usuario where Usuario = '${req.query.usuario}' and Contrasena = '${req.query.contrasena}' and ActivoInactivo = 1`,
      function (err, recordSet) {
        if (err) {
          res.writeHead(400, {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': '*',
            'Content-Type': 'application/json',
          });
          res.end(JSON.stringify({ respuesta: 0 }));
        } else {
          res.writeHead(200, {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': '*',
            'Content-Type': 'application/json',
          });
          res.end(JSON.stringify({ respuesta: recordSet.recordset[0]?.respuesta ?? 0 }));
        }
      }
    );
  } else {
    res.writeHead(200, {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': '*',
      'Content-Type': 'application/json',
    });
    res.end(JSON.stringify({ respuesta: 'en desarrollo' }));

  }
}
