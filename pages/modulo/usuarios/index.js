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
  Select,
  Modal,
  Fieldset,
} from "react95";
import { useRouter } from "next/router";
import 'dotenv/config'

import { useState, useEffect, useRef } from "react";

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
  var request = new sql.Request();
  let { recordset } = await request.query("exec readusuario");
  return {
    props: { recordset },
  };
}

export default function Usuarios({ recordset }) {
  const [modalCrear, setModalCrear] = useState(false);
  const router = useRouter();
  const refreshData = () => {
    router.replace(router.asPath);
  };
  // const activardesactivar = (usuario, activoinactivo) => {
  //   let headersList = {
  //     "Accept": "*/*",
  //     "User-Agent": "Thunder Client (https://www.thunderclient.com)"
  //   }
  //   const peticion = fetch(
  //     `http://${process.env.NEXT_PUBLIC_SERVER}:3000/api/usuarios?usuario=${usuario}&activoinactivo=${
  //       activoinactivo ? "1" : "0"
  //     }`,
  //     { method: "DELETE",
  //     headers: headersList }
  //   );    
  //   peticion
  //     .then((response) => response.json())
  //     .then((datos) => {
  //       refreshData();
  //     })
  //     .catch((e) => console.log(e));
  // };

  const activardesactivar = async (usuario,activoinactivo) => {
    let headersList = {
      "Accept": "*/*",
      "User-Agent": "Thunder Client (https://www.thunderclient.com)"
     }
     
     let response = await fetch("http://167.71.172.206:3000/api/usuarios?usuario=vito&activoinactivo=0", { 
       method: "DELETE",
       headers: headersList
     });
     
     let data = await response.text();
     console.log(data);
     
  }

  const [usuario, setusuario] = useState("erick");
  const [contrasena, setcontrasena] = useState("4125");
  const [tipoUsuario, setTipoUsuario] = useState(1);
  const [dpi, setDPI] = useState();
  const [opt, setOPT] = useState([]);

  const usuarioRef = useRef(" ");
  const contrasenaRef = useRef(" ");
  const FK_ID_TipoUsuarioRef = useRef(" ");

  const [modoUpdate, setModoUpdate] = useState(false);

  const crearUsuario = () => {
    const peticion = fetch(
      `http://${process.env.NEXT_PUBLIC_SERVER}:3000/api/usuarios?usuario=${usuarioRef.current.value}&contrasena=${contrasenaRef.current.value}&tipo=${FK_ID_TipoUsuarioRef.current.value}`,
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
  const editarUsuario = () => {
    const peticion = fetch(
      `http://${process.env.NEXT_PUBLIC_SERVER}:3000/api/usuarios?usuario=${usuarioRef.current.value}&contrasena=${contrasenaRef.current.value}&tipo=${FK_ID_TipoUsuarioRef.current.value}`,
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

  useEffect(() => {
    const peticion = fetch(`http://${process.env.NEXT_PUBLIC_SERVER}:3000/api/usuarios`, {
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

  const editar = (record) => {
    setModalCrear(true);
    setTimeout(() => {
      usuarioRef.current.value = record.Usuario;
      
      contrasenaRef.current.value = record.Contrasena.trim();
      FK_ID_TipoUsuarioRef.current.value = record.FK_ID_TipoUsuario;
    }, 200);
    setModoUpdate(true);
  };

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
        <Window style={{ width: "65%" }}>
          <WindowHeader>Usuarios</WindowHeader>
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
            <Button type="button" onClick={() => {setModalCrear(!modalCrear); setModoUpdate(false)}}>
              {modalCrear ? "Cancelar crear" : "crear"}
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
                    Usuario
                    <TextField
                      placeholder="nombre"
                      fullWidth
                      ref={usuarioRef}
                      disabled={modoUpdate ? true : false}
                    />
                  </div>
                  <div
                    style={{
                      display: "flex",
                      gap: "1rem",
                      alignItems: "center",
                    }}
                  >
                    Contrasena
                    <TextField
                      placeholder="contrasena"
                      fullWidth
                      type="text"
                      ref={contrasenaRef}
                    />
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
                    Tipo usuario
                    <Select options={opt} ref={FK_ID_TipoUsuarioRef} />
                  </div>
                </section>
                {modoUpdate ? (
                  <Button type="button" onClick={() => editarUsuario()}>
                    Editar
                  </Button>
                ) : (
                  <Button type="button" onClick={() => crearUsuario()}>
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
                <TableRow key={record.Usuario}>
                  <TableDataCell>{record.Usuario}</TableDataCell>
                  <TableDataCell>{record.Contrasena}</TableDataCell>
                  <TableDataCell>
                    {record.ActivoInactivo ? "activo" : "inactivo"}
                  </TableDataCell>
                  <TableDataCell>{record.TipoUsuario}</TableDataCell>
                  <TableDataCell>
                    <Button onClick={() => editar(record)}>Editar</Button>
                    <Button
                      onClick={() =>
                        activardesactivar(
                          record.Usuario,
                          !record.ActivoInactivo
                        )
                      }
                    >
                      {record.ActivoInactivo ? "desactivar" : "activar"}
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
