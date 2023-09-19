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
      `delete medicina where ID_Medicina = '${req.query.usuario}'`,
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
    console.log(`exec createMedicina '${req.query.usuario}',1,'${req.query.fechaingreso}','${req.query.fechalote}','${req.query.fechacaducidad}','${req.query.casa}','${req.query.tipomedicamento}'`);
    await request.query(
      `exec createMedicina '${req.query.usuario}',1,'${req.query.fechaingreso}','${req.query.fechalote}','${req.query.fechacaducidad}','${req.query.casa}','${req.query.tipomedicamento}'`,
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
      `update medicina set nombre = '${req.query.usuario}', Perecedero = 1, Fecha_Ingreso = '${req.query.fechaingreso}', Fecha_Lote = '${req.query.fechalote}', Fecha_Caducidad = '${req.query.fechacaducidad}', Casa = '${req.query.casa}', TipoMedicamento = '${req.query.tipomedicamento}' where casa = '${req.query.casa}'`
    );
    await request.query(
      `update medicina set nombre = '${req.query.usuario}', Perecedero = 1, Fecha_Ingreso = convert(smalldatetime,'${req.query.fechaingreso}',103), Fecha_Lote = convert(smalldatetime,'${req.query.fechalote}',103), Fecha_Caducidad = convert(smalldatetime,'${req.query.fechacaducidad}',103), Casa = '${req.query.casa}', TipoMedicamento = '${req.query.tipomedicamento}' where casa = '${req.query.casa}'`,
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
