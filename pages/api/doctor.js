require('dotenv').config()
const sql = require("mssql/msnodesqlv8");

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
  if (req.method === "DELETE") {
    await request.query(
      `exec deleteDoctor '${req.query.usuario}', ${req.query.activoinactivo}`,
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
          res.end(JSON.stringify({ respuesta: "correcto" }));
        }
      }
    );
  } else if (req.method === "GET") {
    await request.query(
      `select ID_TipoUsuario as value, Nombre as label from Tipo_Usuario`,
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
          res.end(JSON.stringify(recordSet.recordset));
        }
      }
    );
  } else if (req.method === "POST") {
    console.log(
      `exec createDoctor '${req.query.usuario}','${req.query.apellido}',${req.query.colegiado},1,4`
    );
    await request.query(
      `exec createDoctor '${req.query.usuario}','${req.query.apellido}',${req.query.colegiado},1,4`,
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
          res.end(JSON.stringify({ respuesta: "correcto" }));
        }
      }
    );
  } else if (req.method === "PUT") {
    console.log(
      `update Doctor set Nombre = '${req.query.usuario}', Apellido = '${req.query.apellido}', colegiado = ${req.query.colegiado} where colegiado = '${req.query.colegiado}'`
    );
    await request.query(
      `update Doctor set Nombre = '${req.query.usuario}', Apellido = '${req.query.apellido}', colegiado = ${req.query.colegiado} where colegiado = '${req.query.colegiado}'`,
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
          res.end(JSON.stringify({respuesta: "correcto" }));
        }
      }
    );
  }
}
