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

  try {
    await sql.connect(config); // Conectar a la base de datos

    var request = new sql.Request();

    if (req.method === "DELETE") {
      await request.query(
        `delete from medicina where ID_Medicina = '${req.query.usuario}'`
      );
      res.status(200).json({ respuesta: "correcto" });
    } else if (req.method === "GET" && req.query.id) {
      const result = await request.query(
        `select * from Medicina where ID_Medicina = ${req.query.id}`
      );
      res.status(200).json(result.recordset);
    } else if (req.method === "GET") {
      const result = await request.query(`exec readMedicina`);
      res.status(200).json(result.recordset);
    } else if (req.method === "POST") {
      const data = req.body;
      await request.query(
        `exec createMedicina '${data.usuario}',1,'${data.fechaingreso}','${data.fechalote}','${data.fechacaducidad}','${data.casa}','${data.tipomedicamento}','${data.descripcion}','${data.imagen}'`
      );
      res.status(200).json({ respuesta: "correcto" });
    } else if (req.method === "PUT") {
      await request.query(
        `update medicina set nombre = '${req.query.usuario}', Perecedero = 1, Fecha_Ingreso = convert(smalldatetime,'${req.query.fechaingreso}',103), Fecha_Lote = convert(smalldatetime,'${req.query.fechalote}',103), Fecha_Caducidad = convert(smalldatetime,'${req.query.fechacaducidad}',103), Casa = '${req.query.casa}', TipoMedicamento = '${req.query.tipomedicamento}' where casa = '${req.query.casa}'`
      );
      res.status(200).json({ respuesta: "correcto" });
    } else {
      res.status(400).json({ respuesta: "Método HTTP no válido" });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ respuesta: "Error en el servidor" });
  } finally {
    sql.close(); // Cerrar la conexión después de completar la consulta
  }
}
