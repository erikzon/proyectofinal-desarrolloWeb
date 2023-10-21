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
      `delete from Paciente where Nombre = '${req.query.usuario}'`,
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
      `delete Paciente where Nombre = '${req.query.usuario}'; 
      declare @HabitacionID int;
      select @HabitacionID = ID from Habitacion where Numero = ${req.query.habitacion};
      insert into Paciente (Identificador, Nombre, Apellido, Residencia, Contacto, Estado, AltaBaja, Edad, Visitas, ClinicaID, HabitacionID)
values
( 'PAC001', '${req.query.usuario}', '${req.query.apellido}', '${req.query.residencia}', ${req.query.contacto}, '${req.query.estado}', 1, ${req.query.edad}, 2, 1, @HabitacionID)`,
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
    const { usuario, apellido, residencia, contacto, estado, edad, identificador,numeroHabitacion } = req.body;
    const query = `
    declare @HabitacionID int;
    select @HabitacionID = ID from Habitacion where Numero = @numeroHabitacion;
    UPDATE Paciente SET Nombre = @Nombre, Apellido = @apellido, Residencia = @residencia, Contacto = @contacto, Estado = @estado, Edad = @edad,HabitacionID = @HabitacionID  WHERE ID = @identificador`;

    const request = new sql.Request();
    request.input('Identificador', sql.Char(30), identificador.trim());
    request.input('Nombre', sql.VarChar(70), usuario);
    request.input('apellido', sql.VarChar(70), apellido);
    request.input('residencia', sql.VarChar(70), residencia);
    request.input('contacto', sql.Int, contacto);
    request.input('estado', sql.VarChar(100), estado);
    request.input('edad', sql.Int, edad);
    request.input('numeroHabitacion', sql.Int, numeroHabitacion);

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