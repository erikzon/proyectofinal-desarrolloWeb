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
  if (req.method === "GET") {
    await request.query(
      ``,
      function (err, recordSet) {
        if (err) {
          res.status(400).json({ respuesta: 0 });
        } else {
          res
            .status(200)
            .json({ respuesta: recordSet.recordset[0]?.ModuloPaciente ?? 0 });
        }
      }
    );
  } else {
    res.status(200).json({ respuesta: "en desarrollo" });
  }
}
