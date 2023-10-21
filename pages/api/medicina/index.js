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

  try {
    await sql.connect(config);

    var request = new sql.Request();

    if (req.method === "DELETE") {
      await request.query(
        `delete from medicina where ID_Medicina = '${req.query.ID_Medicina}'`
      );
      res.writeHead(200, {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': '*',
        'Content-Type': 'application/json',
      });
      res.end(JSON.stringify({ respuesta: "correcto" }));
    } else if (req.method === "GET" && req.query.id) {
      const result = await request.query(
        `select * from Medicina where ID_Medicina = ${req.query.id}`
      );
      res.writeHead(200, {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': '*',
        'Content-Type': 'application/json',
      });
      res.end(JSON.stringify(result.recordset));
    } else if (req.method === "GET") {
      const result = await request.query(`exec readMedicina`);
      res.writeHead(200, {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': '*',
        'Content-Type': 'application/json',
      });
      res.end(JSON.stringify(result.recordset));
    } else if (req.method === "POST") {
      const data = req.body;
      await request.query(
        `exec createMedicina '${data.usuario}',1,'${data.fechaingreso}','${data.fechalote}','${data.fechacaducidad}','${data.casa}','${data.tipomedicamento}','${data.descripcion}','${data.imagen}'`
      );
      res.writeHead(200, {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': '*',
        'Content-Type': 'application/json',
      });
      res.end(JSON.stringify({ respuesta: "correcto" }));
    } else if (req.method === "PUT") {
      await request.query(
        `update medicina set nombre = '${req.query.usuario}', Perecedero = 1, Fecha_Ingreso = convert(smalldatetime,'${req.query.fechaingreso}',120), Fecha_Lote = convert(smalldatetime,'${req.query.fechalote}',120), Fecha_Caducidad = convert(smalldatetime,'${req.query.fechacaducidad}',120), Casa = '${req.query.casa}', TipoMedicamento = '${req.query.tipomedicamento}' where casa = '${req.query.casa}'`
      );
      res.writeHead(200, {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': '*',
        'Content-Type': 'application/json',
      });
      res.end(JSON.stringify({ respuesta: "correcto" }));
    } else {
      res.writeHead(400, {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': '*',
        'Content-Type': 'application/json',
      });
      res.end(JSON.stringify({respuesta: "Método HTTP no válido" }));
    }
  } catch (err) {
    console.error(err);
    res.writeHead(500, {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': '*',
      'Content-Type': 'application/json',
    });
    res.end(JSON.stringify({ respuesta: "Error en el servidor" }));
  } finally {
    sql.close(); // Cerrar la conexión después de completar la consulta
  }
}
