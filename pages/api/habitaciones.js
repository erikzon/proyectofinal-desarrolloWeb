require('dotenv').config()
import sql from "mssql/msnodesqlv8";

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
  
  
  if (req.method === "GET") {
    await request.query(
      `SELECT 
      H.Numero as 'HabitacionNo',
      H.ClinicaID as 'Clinica',
      CASE
          WHEN EXISTS (
              SELECT 1
              FROM Paciente P
              WHERE P.HabitacionID = H.ID
          ) THEN 1
          ELSE 0
      END as 'Ocupada'
  FROM Habitacion H;`,
      function (err, recordSet) {
        if (err) {
          res.status(400).json({ respuesta: 0 });
        } else {
          res.writeHead(200, {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': '*',
            'Content-Type': 'application/json',
          });
          res.end(JSON.stringify(recordSet));
        }
      }
    );
  }
}
