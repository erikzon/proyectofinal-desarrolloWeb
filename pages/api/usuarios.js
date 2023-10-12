require('dotenv').config()
import sql from "mssql/msnodesqlv8";

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
      `exec deleteUsuario '${req.query.usuario}', ${req.query.activoinactivo}`,
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
      `select ID_TipoUsuario as value, Nombre as label from Tipo_Usuario`,
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
      `exec createUsuario '${req.query.usuario}','${req.query.contrasena}',1,${req.query.tipo}`,
      function (err, recordSet) {
        if (err) {
          res.status(400).json({ respuesta: 0 });
        } else {
          res.status(200).json({ respuesta: "correcto" });
        }
      }
    );
  } else if (req.method === "PUT") {
    `update usuario set Usuario = '${req.query.usuario}', Contrasena = '${req.query.contrasena}', FK_ID_TipoUsuario=${req.query.tipo} where Usuario = '${req.query.usuario}'`;
    await request.query(
      `update usuario set Usuario = '${req.query.usuario}', Contrasena = '${req.query.contrasena}', FK_ID_TipoUsuario=${req.query.tipo} where Usuario = '${req.query.usuario}'`,
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
