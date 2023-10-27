import {
  Table,
  TableBody,
  TableHead,
  TableRow,
  TableHeadCell,
  TableDataCell,
  Window,
  WindowHeader,
  TextField,
  Button,
  Select
} from "react95";
import { useRef, useState } from "react";
import { useRouter } from "next/router";

export async function getServerSideProps(context) {
  const sql = require("mssql/msnodesqlv8");
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
  sql.connect(config);
  // Consulta para obtener pacientes
  const requestPacientes = new sql.Request();
  const { recordset: pacientes } = await requestPacientes.query("exec readPaciente");

  // Consulta para obtener habitaciones disponibles
  const requestHabitaciones = new sql.Request();
  const { recordset: habitacionesDisponibles } = await requestHabitaciones.query(`
  SELECT Concat(H.Numero, ' de la clinica ', H.ClinicaID) as 'descripcion', H.Numero, H.ClinicaID
  FROM Habitacion H
  WHERE NOT EXISTS (
      SELECT 1
      FROM Paciente P
      WHERE P.HabitacionID = H.ID
  );
  
  `);

  return {
    props: {
      recordset: pacientes,
      habitacionesDisponibles,
    },
  };
}



export default function Paciente({ recordset: pacientes, habitacionesDisponibles }) {
  const router = useRouter();
  const habilitado = location.href.split("=")[1] === "true";
  const refreshData = () => {
    router.replace(router.asPath);
  };
  const inputRef = useRef(null);
  const [modoUpdate, setModoUpdate] = useState(false);
  const [resultadoBusqueda, setResultadoBusqueda] = useState();
  const [usarBusqueda, setUsarBusqueda] = useState(false);
  const [modalCrear, setModalCrear] = useState(false);

  const opcionesHabitaciones = habitacionesDisponibles.map(habitacion => ({
    label: habitacion.descripcion,
    value: habitacion.Numero,
  }));

  const buscar = () => {
    if (inputRef.current.value != null) {
      if (inputRef.current.value.length > 3) {
        const peticion = fetch(
          `http://${process.env.NEXT_PUBLIC_SERVER}:3000/api/paciente?busqueda=${inputRef.current.value}`,
          { method: "GET" }
        );
        peticion
          .then((response) => response.json())
          .then((datos) => {
            setUsarBusqueda(true);
            setResultadoBusqueda(datos);
          })
          .catch((e) => console.log(e));
      } else {
        setUsarBusqueda(false);
      }
    } else {
      setUsarBusqueda(false);
    }
  };

  const activardesactivar = (usuario, activoinactivo) => {
    const peticion = fetch(
      `http://${process.env.NEXT_PUBLIC_SERVER}:3000/api/paciente?usuario=${usuario}&activoinactivo=${
        activoinactivo ? "1" : "0"
      }`,
      { method: "DELETE" }
    );
    peticion
      .then((response) => response.json())
      .then((datos) => {
        refreshData();
        setUsarBusqueda(false);
      })
      .catch((e) => console.log(e));
  };

  const nombreRef = useRef(' ');
  const apellidoRef = useRef(' ');
  const residenciaRef = useRef(' ');
  const contactoRef = useRef(' ');
  const estadoRef = useRef(' ');
  const edadRef = useRef(' ');
  const identificadorRef = useRef(' ');
  const habitacionRef = useRef(1);

  const enviarFormularioPaciente = () => {
    const peticion = fetch(
      `http://${process.env.NEXT_PUBLIC_SERVER}:3000/api/paciente?usuario=${nombreRef.current.value}&apellido=${apellidoRef.current.value}&residencia=${residenciaRef.current.value}&contacto=${contactoRef.current.value}&estado=${estadoRef.current.value}&edad=${edadRef.current.value}&habitacion=${habitacionRef.current.value}`,
      { method: "POST" }
    );
    peticion
      .then((response) => response.json())
      .then((datos) => {
        refreshData();
        setUsarBusqueda(false);
        setModalCrear(false);
      })
      .catch((e) => console.log(e));
  };

  const enviarFormularioEdicionPaciente = () => {
    const data = {
      usuario: nombreRef.current.value,
      apellido: apellidoRef.current.value,
      residencia: residenciaRef.current.value,
      contacto: contactoRef.current.value,
      estado: estadoRef.current.value,
      edad: edadRef.current.value,
      identificador: identificadorRef.current.value,
      numeroHabitacion: habitacionRef.current.value
    };
  
    const peticion = fetch(`http://${process.env.NEXT_PUBLIC_SERVER}:3000/api/paciente`, {
      method: "PUT",
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    });
  
    peticion
      .then((response) => response.json())
      .then((datos) => {
        refreshData();
        setUsarBusqueda(false);
        setModalCrear(false);
      })
      .catch((e) => console.log(e));
  };
  

  const editar = (record) => {
    setModalCrear(true);
    setModoUpdate(true);
    setTimeout(() => {
      nombreRef.current.value = record.Nombre;
      apellidoRef.current.value = record.Apellido;
      residenciaRef.current.value = record.Residencia;
      contactoRef.current.value = record.Contacto;
      estadoRef.current.value = record.Estado;
      edadRef.current.value = record.Edad;
      identificadorRef.current.value = record.Identificador;
    }, 200);
  }

  const botonCrearClickado = () => {
    setModalCrear(!modalCrear)
    setModoUpdate(false)
  }

  return (
    <>
      <div
        style={{
          display: "flex",
          flexDirection: "column",
          justifyContent: "center",
          alignItems: "center",
          textAlign: "center",
          minHeight: "100vh",
          backgroundColor: "rgb(0, 128, 128)",
        }}
      >
        <Window style={{ width: "95%" }}>
          <WindowHeader>Pacientes</WindowHeader>
          <div
            style={{
              display: "flex",
              justifyContent: "center",
              marginBottom: 8,
              marginTop: 8,
              alignItems: "flex-end",
              gap: "6rem",
              padding: "0 1rem",
            }}
          >
            <TextField
              fullWidth
              type="text"
              placeholder="ingrese un identificador"
              id="busqueda"
              ref={inputRef}
            />
            <Button type="submit" value="buscar" onClick={() => buscar()}>
              Buscar
            </Button>
            {habilitado && (
              <Button type="button" onClick={() => botonCrearClickado()}>
                {modalCrear ? "Cancelar" : "crear"}
              </Button>
            )}
          </div>
          {modalCrear && (
            <form
              onSubmit={(e) => {
                e.preventDefault();
                login(usuario, contrasena);
              }}
            >
              <div
                style={{
                  display: "flex",
                  alignItems: "center",
                  justifyItems: "flex-start",
                  gap: "1rem",
                  justifyContent: "space-evenly",
                  flexDirection: "row",
                  padding: "1rem",
                }}
              >
                <section>
                <div
                    style={{
                      display: "none"
                    }}
                  >
                    identificar
                    <TextField fullWidth ref={identificadorRef} />
                  </div>
                  <div
                    style={{
                      display: "flex",
                      gap: "1rem",
                      alignItems: "center",
                    }}
                  >
                    nombre
                    <TextField fullWidth ref={nombreRef} />
                  </div>
                  <div
                    style={{
                      display: "flex",
                      gap: "1rem",
                      alignItems: "center",
                    }}
                  >
                    Apellido
                    <TextField fullWidth type="text" ref={apellidoRef} />
                  </div>
                  <div
                    style={{
                      display: "flex",
                      gap: "1rem",
                      alignItems: "center",
                    }}
                  >
                    estado
                    <TextField fullWidth type="text" ref={estadoRef} />
                  </div>
                </section>
                <section>
                  <div
                    style={{
                      display: "flex",
                      gap: "1rem",
                      alignItems: "center",
                    }}
                  >
                    residencia
                    <TextField fullWidth type="text" ref={residenciaRef} />
                  </div>
                  <div
                    style={{
                      display: "flex",
                      gap: "1rem",
                      alignItems: "center",
                    }}
                  >
                    No. contacto
                    <TextField fullWidth type="number" ref={contactoRef} />
                  </div>
                  <div
                    style={{
                      display: "flex",
                      gap: "1rem",
                      alignItems: "center",
                    }}
                  >
                    edad
                    <TextField fullWidth type="number" ref={edadRef} />
                  </div>
                  <div
                    style={{
                      display: "flex",
                      gap: "1rem",
                      alignItems: "center",
                    }}
                  >
                    Habitacion
                    <Select
                      options={opcionesHabitaciones}
                      menuMaxHeight={160}
                      width={250}
                      ref={habitacionRef}
                    />
                  </div>
                </section>
                {modoUpdate ? (
                  <Button type="button" onClick={() => enviarFormularioEdicionPaciente()}>
                    Editar
                  </Button>
                ) : (
                  <Button
                    type="button" onClick={() => enviarFormularioPaciente()}
                  >
                    Crear
                  </Button>
                )}
              </div>
            </form>
          )}
          <Table>
            <TableHead>
              <TableRow>
                <TableHeadCell> Nombre </TableHeadCell>
                <TableHeadCell> Apellido </TableHeadCell>
                <TableHeadCell> Residencia </TableHeadCell>
                <TableHeadCell> Contacto </TableHeadCell>
                <TableHeadCell> Estado </TableHeadCell>
                <TableHeadCell> Edad </TableHeadCell>
                <TableHeadCell> Visitas </TableHeadCell>
                <TableHeadCell> Clinica </TableHeadCell>
                <TableHeadCell> Habitacion </TableHeadCell>
                {habilitado && <TableHeadCell> Accion </TableHeadCell>}
              </TableRow>
            </TableHead>
            <TableBody>
              {!usarBusqueda
                ? pacientes.map((record) => (
                    <TableRow key={record.ID}>
                      <TableDataCell>{record.Nombre}</TableDataCell>
                      <TableDataCell>{record.Apellido}</TableDataCell>
                      <TableDataCell>{record.Residencia}</TableDataCell>
                      <TableDataCell>{record.Contacto}</TableDataCell>
                      <TableDataCell>{record.Estado}</TableDataCell>
                      <TableDataCell>{record.Edad}</TableDataCell>
                      <TableDataCell>{record.Visitas}</TableDataCell>
                      <TableDataCell>{record.ClinicaID}</TableDataCell>
                      <TableDataCell>{record.Habitacion}</TableDataCell>
                      {habilitado && (
                        <TableDataCell>
                          <Button onClick={() => editar(record)}>Editar</Button>
                          <br/>
                          <Button
                            onClick={() =>
                              activardesactivar(record.Nombre, !record.AltaBaja)
                            }
                          >
                            Dar de alta
                          </Button>
                        </TableDataCell>
                      )}
                    </TableRow>
                  ))
                : resultadoBusqueda.map((record) => (
                    <TableRow key={record.ID}>
                      <TableDataCell>{record.Nombre}</TableDataCell>
                      <TableDataCell>{record.Apellido}</TableDataCell>
                      <TableDataCell>{record.Residencia}</TableDataCell>
                      <TableDataCell>{record.Contacto}</TableDataCell>
                      <TableDataCell>{record.Estado}</TableDataCell>
                      <TableDataCell>{record.Edad}</TableDataCell>
                      <TableDataCell>{record.Visitas}</TableDataCell>
                      <TableDataCell>{record.ClinicaID}</TableDataCell>
                      <TableDataCell>{record.HabitacionID}</TableDataCell>
                      {habilitado && (
                        <TableDataCell>
                          <Button onClick={() => editar(record)}>Editar</Button>
                          <br/>
                          <Button
                            onClick={() =>
                              activardesactivar(record.Nombre, !record.AltaBaja)
                            }
                          >
                            Dar de alta
                          </Button>
                        </TableDataCell>
                      )}
                    </TableRow>
                  ))}
            </TableBody>
          </Table>
        </Window>
      </div>
    </>
  );
}
