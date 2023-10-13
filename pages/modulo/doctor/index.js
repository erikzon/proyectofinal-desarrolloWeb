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

import { useRouter } from "next/router";
import { useRef, useState, useEffect } from "react";

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
  let { recordset } = await request.query("exec readDoctor");
  return {
    props: { recordset },
  };
}

export default function Doctor({ recordset }) {
  const [opt, setOPT] = useState([]);
  const router = useRouter();
  const refreshData = () => {
    router.replace(router.asPath);
  };

  const [modalCrear, setModalCrear] = useState(false);

  const activardesactivar = (usuario, activoinactivo) => {
    const peticion = fetch(
      `http://${process.env.SERVER}:3000/api/doctor?usuario=${usuario}&activoinactivo=${
        activoinactivo ? "1" : "0"
      }`,
      { method: "DELETE" }
    );
    peticion
      .then((response) => response.json())
      .then((datos) => {
        refreshData();
      })
      .catch((e) => console.log(e));
  };

  const enviarFormularioDoctor = () => {
    const peticion = fetch(
      `http://${process.env.SERVER}:3000/api/doctor?usuario=${nombreRef.current.value}&apellido=${apellidoRef.current.value}&colegiado=${colegiadoRef.current.value}`,
      { method: "POST" }
    );
    peticion
      .then((response) => response.json())
      .then((datos) => {
        refreshData();
        setModalCrear(false);
      })
      .catch((e) => console.log(e));
  };

  const editarDoctor = () => {
    const peticion = fetch(
      `http://${process.env.SERVER}:3000/api/doctor?usuario=${nombreRef.current.value}&apellido=${apellidoRef.current.value}&colegiado=${colegiadoRef.current.value}`,
      { method: "PUT" }
    );
    peticion
      .then((response) => response.json())
      .then((datos) => {
        refreshData();
        setModalCrear(false);
      })
      .catch((e) => console.log(e));
  };

  const nombreRef = useRef();
  const apellidoRef = useRef();
  const colegiadoRef = useRef();
  const especialidadRef = useRef();

  const [modoUpdate, setModoUpdate] = useState(false);
  const editar = (record) => {
    setModalCrear(true);
    setTimeout(() => {
      nombreRef.current.value = record.Nombre;
      apellidoRef.current.value = record.Apellido;
      colegiadoRef.current.value = record.Colegiado;
      especialidadRef.current.value = record.Descripcion;
    }, 200);
    setModoUpdate(true);
  };

  useEffect(() => {
    const peticion = fetch(`http://${process.env.SERVER}:3000/api/especialidades`, {
      method: "GET",
    });
    peticion
      .then((response) => response.json())
      .then((datos) => {
        console.log(datos);
        setOPT(datos);
      })
      .catch((e) => console.log(e));
  }, []);

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
          <WindowHeader>Doctores</WindowHeader>
          <div
            style={{
              display: "flex",
              justifyContent: "flex-end",
              marginBottom: 8,
              marginTop: 8,
              alignItems: "flex-end",
              gap: "6rem",
            }}
          >
            <Button
              type="button"
              onClick={() => {
                setModalCrear(!modalCrear);
                setModoUpdate(false);
              }}
            >
              {modalCrear ? "Cancelar" : "crear"}
            </Button>
          </div>
          {modalCrear && (
            <form>
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
                </section>
                <section>
                  <div
                    style={{
                      display: "flex",
                      gap: "1rem",
                      alignItems: "center",
                    }}
                  >
                    colegiado
                    <TextField fullWidth type="text" ref={colegiadoRef} />
                  </div>
                  <div
                    style={{
                      display: "flex",
                      gap: "1rem",
                      alignItems: "center",
                    }}
                  >
                    Especialidad
                    <Select options={opt} ref={especialidadRef} />
                  </div>
                </section>

                {modoUpdate ? (
                  <Button type="button" onClick={() => editarDoctor()}>
                    Editar
                  </Button>
                ) : (
                  <Button
                    type="button"
                    onClick={() => enviarFormularioDoctor()}
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
                {Object.keys(recordset[0]).map((cabecera, index) => (
                  <TableHeadCell key={index}> {cabecera} </TableHeadCell>
                ))}
                <TableHeadCell> Accion </TableHeadCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {recordset.map((record) => (
                <TableRow key={record.ID}>
                  <TableDataCell>{record.Nombre}</TableDataCell>
                  <TableDataCell>{record.Apellido}</TableDataCell>
                  <TableDataCell>{record.Colegiado}</TableDataCell>
                  <TableDataCell>{record.Disponible ? "X" : ""}</TableDataCell>
                  <TableDataCell>{record.Descripcion}</TableDataCell>
                  <TableDataCell>
                    <Button onClick={() => editar(record)}>Editar</Button>
                    <Button
                      onClick={() =>
                        activardesactivar(record.Apellido, !record.Disponible)
                      }
                    >
                      {record.Disponible ? "desactivar" : "activar"}
                    </Button>
                  </TableDataCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </Window>
      </div>
    </>
  );
}
