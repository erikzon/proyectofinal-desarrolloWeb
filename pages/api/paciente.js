require('dotenv').config()
const sql = require("mssql/msnodesqlv8");

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
  if (req.method === "DELETE") {
    await request.query(
      `exec deletePaciente '${req.query.usuario}', ${req.query.activoinactivo}`,
      function (err, recordSet) {
        if (err) {
          res.writeHead(400, {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': '*',
            'Content-Type': 'application/json',
          });
          res.end(JSON.stringify({ respuesta: 0 }));
        } else {
          res.writeHead(200, {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': '*',
            'Content-Type': 'application/json',
          });
          res.end(JSON.stringify({  respuesta: "correcto" }));
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
          res.writeHead(400, {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': '*',
          'Content-Type': 'application/json',
        });
        res.end(JSON.stringify({  respuesta: 0 }));
        } else {
        res.writeHead(200, {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': '*',
          'Content-Type': 'application/json',
        });
        res.end(JSON.stringify(recordSet.recordset));
        }
      }
    );
  } else if (req.method === "POST") {
    await request.query(
      `delete Paciente where Nombre = '${req.query.usuario}'; exec createPaciente '${req.query.usuario}','${req.query.apellido}','${req.query.residencia}',${req.query.contacto},'${req.query.estado}',1,${req.query.edad}`,
      function (err, recordSet) {
        if (err) {
          res.writeHead(400, {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': '*',
            'Content-Type': 'application/json',
              });
          res.end(JSON.stringify({  respuesta: 0 }));
        } else {
          res.writeHead(200, {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': '*',
      'Content-Type': 'application/json',
    });
    res.end(JSON.stringify({ respuesta: "correcto" }));
        }
      }
    );
  } else if (req.method === "PUT") {
    const { ID, Identificador, Nombre, Apellido, Residencia, Contacto, Estado, AltaBaja, Edad, Visitas } = req.body;
  
    // Use parameterized query to prevent SQL injection
    const query = `UPDATE Paciente SET Identificador = @Identificador, Nombre = @Nombre, Apellido = @Apellido, Residencia = @Residencia, Contacto = @Contacto, Estado = @Estado, AltaBaja = @AltaBaja, Edad = @Edad, Visitas = @Visitas WHERE ID = @ID`;
  
    const request = new sql.Request();
    request.input('ID', sql.Int, ID);
    request.input('Identificador', sql.Char(30), Identificador);
    request.input('Nombre', sql.VarChar(70), Nombre);
    request.input('Apellido', sql.VarChar(70), Apellido);
    request.input('Residencia', sql.VarChar(70), Residencia);
    request.input('Contacto', sql.Int, Contacto);
    request.input('Estado', sql.VarChar(100), Estado);
    request.input('AltaBaja', sql.Bit, AltaBaja);
    request.input('Edad', sql.Int, Edad);
    request.input('Visitas', sql.Int, Visitas);
  
    request.query(query, function (err) {
      if (err) {
        console.error(err);
        res.status(500).json({ error: 'Internal Server Error' });
      } else {
        res.status(200).json({ message: 'Record updated successfully' });
      }
    });
  }
}