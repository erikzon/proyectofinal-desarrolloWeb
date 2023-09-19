const sql = require("mssql/msnodesqlv8");
var config = {
  database: "proyecto",
  server: "ERICK-LAPTO\\SQLEXPRESS",
  driver: "msnodesqlv8",
  options: {
    trustedConnection: true,
  },
};

sql.connect(config, function (err) {
  if (err) {
    console.log(err);
  }
});

export default async function handler(req, res) {
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
