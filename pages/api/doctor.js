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
      `exec deleteDoctor '${req.query.usuario}', ${req.query.activoinactivo}`,
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
    console.log(
      `exec createDoctor '${req.query.usuario}','${req.query.apellido}',${req.query.colegiado},1,4`
    );
    await request.query(
      `exec createDoctor '${req.query.usuario}','${req.query.apellido}',${req.query.colegiado},1,4`,
      function (err, recordSet) {
        if (err) {
          res.status(400).json({ respuesta: 0 });
        } else {
          res.status(200).json({ respuesta: "correcto" });
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
          res.status(400).json({ respuesta: 0 });
        } else {
          res.status(200).json({ respuesta: "correcto" });
        }
      }
    );
  }
}
