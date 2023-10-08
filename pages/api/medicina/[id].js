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

    if (req.method === "GET") {
      const request = new sql.Request();
      let result = [];
      if (!isNaN(req.query.id)) { // Verificar si req.query.id es un número
        result = await request.query(
          `select * from Medicina where ID_Medicina = ${req.query.id}`
        );
      } else {
        result = await request.query(
          `select * from Medicina where Nombre like '%${req.query.id}%'`
        );

      }

      res.status(200).json(result.recordset);
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ respuesta: "Error en el servidor" });
  } finally {
    sql.close(); // Cerrar la conexión después de completar la consulta
  }
}
