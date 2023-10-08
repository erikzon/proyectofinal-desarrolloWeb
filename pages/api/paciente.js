const sql = require("mssql/msnodesqlv8");
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
  if (req.method === "DELETE") {
    await request.query(
      `exec deletePaciente '${req.query.usuario}', ${req.query.activoinactivo}`,
      function (err, recordSet) {
        if (err) {
          res.status(400).json({ respuesta: 0 });
        } else {
          res.status(200).json({ respuesta: "correcto" });
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
          res.status(400).json({ respuesta: 0 });
        } else {
          res.status(200).json(recordSet.recordset);
        }
      }
    );
  } else if (req.method === "POST") {
    await request.query(
      `delete Paciente where Nombre = '${req.query.usuario}'; exec createPaciente '${req.query.usuario}','${req.query.apellido}','${req.query.residencia}',${req.query.contacto},'${req.query.estado}',1,${req.query.edad}`,
      function (err, recordSet) {
        if (err) {
          res.status(400).json({ respuesta: 0 });
        } else {
          res.status(200).json({ respuesta: "correcto" });
        }
      }
    );
  }
}