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
      `exec deletePaciente '${req.query.usuario}', ${req.query.activoinactivo}`,
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
          res.end(JSON.stringify({  respuesta: "correcto" }));
        }
      }
    );
  } else if (req.method === "GET") {
    await request.query(
      `select * from Paciente where Identificador like '%${req.query.busqueda.replace(
        " ",
        "%"
      )}%' or Nombre like '%${req.query.busqueda}%'`,
      function (err, recordSet) {
        if (err) {
          res.writeHead(400, {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': '*',
          'Content-Type': 'application/json',
        });
        res.end(JSON.stringify({  respuesta: 0 }));
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
    await request.query(
      `delete Paciente where Nombre = '${req.query.usuario}'; exec createPaciente '${req.query.usuario}','${req.query.apellido}','${req.query.residencia}',${req.query.contacto},'${req.query.estado}',1,${req.query.edad}`,
      function (err, recordSet) {
        if (err) {
          res.writeHead(400, {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': '*',
      'Content-Type': 'application/json',
    });
    res.end(JSON.stringify({  respuesta: 0 }));
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
  }
}