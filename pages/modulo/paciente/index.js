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
} from "react95";
import { useRef, useState } from "react";
import { useRouter } from "next/router";

export async function getServerSideProps(context) {
  const sql = require("mssql/msnodesqlv8");
  var config = {
    database: "proyecto",
    server: "ERICK-LAPTO\\SQLEXPRESS",
    driver: "msnodesqlv8",
    options: {
      trustedConnection: true,
    },
  };
  sql.connect(config);
  var request = new sql.Request();
  let { recordset } = await request.query("exec readPaciente");
  return {
    props: { recordset },
  };
}

export default function Paciente({ recordset }) {
  const router = useRouter();
  const habilitado = location.href.split("=")[1] === "true";
  const refreshData = () => {
    router.replace(router.asPath);
  };
  const inputRef = useRef(null);
  const [resultadoBusqueda, setResultadoBusqueda] = useState();
  const [usarBusqueda, setUsarBusqueda] = useState(false);
  const [modalCrear, setModalCrear] = useState(false);
  const buscar = () => {
    if (inputRef.current.value != null) {
      if (inputRef.current.value.length > 3) {
        const peticion = fetch(
          `http://${process.env.SERVER}:3000/api/paciente?busqueda=${inputRef.current.value}`,
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
      `http://${process.env.SERVER}:3000/api/paciente?usuario=${usuario}&activoinactivo=${
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

  const enviarFormularioPaciente = () => {
    const peticion = fetch(
      `http://loc${process.env.SERVER}alhost:3000/api/paciente?usuario=${nombreRef.current.value}&apellido=${apellidoRef.current.value}&residencia=${residenciaRef.current.value}&contacto=${contactoRef.current.value}&estado=${estadoRef.current.value}&edad=${edadRef.current.value}`,
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

  const editar = (record) => {
    setModalCrear(true);
    setTimeout(() => {
      nombreRef.current.value = record.Nombre;
      apellidoRef.current.value = record.Apellido;
      residenciaRef.current.value = record.Residencia;
      contactoRef.current.value = record.Contacto;
      estadoRef.current.value = record.Estado;
      edadRef.current.value = record.Edad;
    }, 200);
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
              <Button type="button" onClick={() => setModalCrear(!modalCrear)}>
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
                    contacto
                    <TextField fullWidth type="text" ref={contactoRef} />
                  </div>
                  <div
                    style={{
                      display: "flex",
                      gap: "1rem",
                      alignItems: "center",
                    }}
                  >
                    edad
                    <TextField fullWidth type="text" ref={edadRef} />
                  </div>
                </section>
                <Button
                  type="button"
                  onClick={() => enviarFormularioPaciente()}
                >
                  Crear
                </Button>
              </div>
            </form>
          )}
          <Table>
            <TableHead>
              <TableRow>
                <TableHeadCell> Identificador </TableHeadCell>
                <TableHeadCell> Nombre </TableHeadCell>
                <TableHeadCell> Apellido </TableHeadCell>
                <TableHeadCell> Residencia </TableHeadCell>
                <TableHeadCell> Contacto </TableHeadCell>
                <TableHeadCell> Estado </TableHeadCell>
                <TableHeadCell> AltaBaja </TableHeadCell>
                <TableHeadCell> Edad </TableHeadCell>
                <TableHeadCell> Visitas </TableHeadCell>
                {habilitado && <TableHeadCell> Accion </TableHeadCell>}
              </TableRow>
            </TableHead>
            <TableBody>
              {!usarBusqueda
                ? recordset.map((record) => (
                    <TableRow key={record.ID}>
                      <TableDataCell>{record.Identificador}</TableDataCell>
                      <TableDataCell>{record.Nombre}</TableDataCell>
                      <TableDataCell>{record.Apellido}</TableDataCell>
                      <TableDataCell>{record.Residencia}</TableDataCell>
                      <TableDataCell>{record.Contacto}</TableDataCell>
                      <TableDataCell>{record.Estado}</TableDataCell>
                      <TableDataCell>
                        {record.AltaBaja ? "alta" : "baja"}
                      </TableDataCell>
                      <TableDataCell>{record.Edad}</TableDataCell>
                      <TableDataCell>{record.Visitas}</TableDataCell>
                      {habilitado && (
                        <TableDataCell>
                          <Button onClick={() => editar(record)}>Editar</Button>
                          <Button
                            onClick={() =>
                              activardesactivar(record.Nombre, !record.AltaBaja)
                            }
                          >
                            {record.AltaBaja ? "desactivar" : "activar"}
                          </Button>
                        </TableDataCell>
                      )}
                    </TableRow>
                  ))
                : resultadoBusqueda.map((record) => (
                    <TableRow key={record.ID}>
                      <TableDataCell>{record.Identificador}</TableDataCell>
                      <TableDataCell>{record.Nombre}</TableDataCell>
                      <TableDataCell>{record.Apellido}</TableDataCell>
                      <TableDataCell>{record.Residencia}</TableDataCell>
                      <TableDataCell>{record.Contacto}</TableDataCell>
                      <TableDataCell>{record.Estado}</TableDataCell>
                      <TableDataCell>
                        {record.AltaBaja ? "alta" : "baja"}
                      </TableDataCell>
                      <TableDataCell>{record.Edad}</TableDataCell>
                      <TableDataCell>{record.Visitas}</TableDataCell>
                      {habilitado && (
                        <TableDataCell>
                          <Button onClick={() => editar(record)}>Editar</Button>
                          <Button
                            onClick={() =>
                              activardesactivar(record.Nombre, !record.AltaBaja)
                            }
                          >
                            {record.AltaBaja ? "desactivar" : "activar"}
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
