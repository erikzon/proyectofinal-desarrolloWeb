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

import { useRouter } from "next/router";
import { useEffect, useRef, useState } from "react";

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
  let { recordset } = await request.query("exec readMedicina");
  return {
    props: { recordset },
  };
}

export default function Medicina({ recordset }) {
  const router = useRouter();
  

  const [modalCrear, setModalCrear] = useState(false);
  const [datos, setDatos] = useState();
  const [modoUpdate, setModoUpdate] = useState(false);

  useEffect(() => {
    cargar();
  }, []);


  const cargar = () => {
    const peticion = fetch(
      `http://${process.env.NEXT_PUBLIC_SERVER}:3000/api/medicina`,
      { method: "GET" }
    );
    peticion
      .then((response) => response.json())
      .then((datos) => {
        setDatos(datos);
      })
      .catch((e) => console.log(e));
  };

  const eliminar = (record) => {
    const peticion = fetch(
      `http://${process.env.NEXT_PUBLIC_SERVER}:3000/api/medicina?ID_Medicina=${record.ID}`,
      { method: "DELETE" }
    );
    peticion
      .then((response) => response.json())
      .then((datos) => {
        cargar();
      })
      .catch((e) => console.log(e));
  };

  const crearMedicina = () => {
    const reader = new FileReader();
    reader.onloadend = () => {
      const base64String = reader.result.replace("data:", "").replace(/^.+,/, "");
      const data = {
        usuario: nombreRef.current.value,
        fechaingreso: fechaIngresoRef.current.value,
        fechalote: fechaLoteRef.current.value,
        fechacaducidad: fechaCaducidadRef.current.value,
        casa: casaRef.current.value,
        tipomedicamento: tipoMedicamentoRef.current.value,
        descripcion: descripcionRef.current.value,
        imagen: base64String,
      };
      const peticion = fetch(`http://${process.env.NEXT_PUBLIC_SERVER}:3000/api/medicina`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data),
      });
      peticion
        .then((response) => response.json())
        .then((datos) => {
          cargar();
          setModalCrear(false);
        })
        .catch((e) => console.log(e));
       };
    reader.readAsDataURL(ImagenRef.current.files[0]);
  };
  

  const editarMedicina = () => {
    const peticion = fetch(
      `http://${process.env.NEXT_PUBLIC_SERVER}:3000/api/medicina?usuario=${nombreRef.current.value}&fechaingreso=${fechaIngresoRef.current.value}&fechalote=${fechaLoteRef.current.value}&fechacaducidad=${fechaCaducidadRef.current.value}&casa=${casaRef.current.value}&tipomedicamento=${tipoMedicamentoRef.current.value}`,
      { method: "PUT" }
    );
    peticion
      .then((response) => response.json())
      .then((datos) => {
        cargar();
        setModalCrear(false);
      })
      .catch((e) => console.log(e));
  };

  const nombreRef = useRef(" ");
  const fechaIngresoRef = useRef(" ");
  const fechaLoteRef = useRef(" ");
  const fechaCaducidadRef = useRef(" ");
  const casaRef = useRef(" ");
  const tipoMedicamentoRef = useRef(" ");
  const descripcionRef = useRef(" ");
  const ImagenRef = useRef(" ");

  const editar = (record) => {
    setModalCrear(true);
    console.log(record);
    const fechaIngresoParts = record.Ingreso.split('/');
    const fechaLoteParts = record.Lote.split('/');
    const fechaCaducidadParts = record.Caducidad.split('/');
    setTimeout(() => {
      nombreRef.current.value = record.Nombre
      fechaIngresoRef.current.value = `${fechaIngresoParts[2]}-${fechaIngresoParts[1]}-${fechaIngresoParts[0]}`;
      fechaLoteRef.current.value = `${fechaLoteParts[2]}-${fechaLoteParts[1]}-${fechaLoteParts[0]}`;
      fechaCaducidadRef.current.value = `${fechaCaducidadParts[2]}-${fechaCaducidadParts[1]}-${fechaCaducidadParts[0]}`;
      casaRef.current.value = record.Casa;
      tipoMedicamentoRef.current.value = record.Tipo;
      descripcionRef.current.value = record.Descripcion;
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
        <Window style={{ width: "95%" }}>
          <WindowHeader>Inventario</WindowHeader>
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
                    Fecha Ingreso
                    <TextField fullWidth type="date" ref={fechaIngresoRef} />
                  </div>
                  <div
                    style={{
                      display: "flex",
                      gap: "1rem",
                      alignItems: "center",
                    }}
                  >
                    Fecha Lote
                    <TextField fullWidth type="date" ref={fechaLoteRef} />
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
                    Fecha Caducidad
                    <TextField fullWidth type="date" ref={fechaCaducidadRef} />
                  </div>
                  <div
                    style={{
                      display: "flex",
                      gap: "1rem",
                      alignItems: "center",
                    }}
                  >
                    Casa
                    <TextField fullWidth type="text" ref={casaRef} disabled={modoUpdate ? true : false}/>
                  </div>
                  <div
                    style={{
                      display: "flex",
                      gap: "1rem",
                      alignItems: "center",
                    }}
                  >
                    Tipo Medicamento
                    <TextField fullWidth type="text" ref={tipoMedicamentoRef} />
                  </div>
                  
                </section>
                {modoUpdate ? (
                  <Button type="button" onClick={() => editarMedicina()}>
                    Editar
                  </Button>
                ) : (
                  <Button type="button" onClick={() => crearMedicina()}>
                    Crear
                  </Button>
                )}
              </div>
              <div
                style={{
                  display: "flex",
                  gap: "1rem",
                  alignItems: "center",
                }}
              >
                Descripción
                <TextField fullWidth type="text" ref={descripcionRef} />
              </div>
              <div
                style={{
                  display: "flex",
                  gap: "1rem",
                  alignItems: "center",
                  margin: "1rem"
                }}
              >
                Imagen
                <input type="file" ref={ImagenRef} disabled={modoUpdate ? true : false} />
              </div>
            </form>
          )}
          <Table>
            <TableHead>
              <TableRow>
                {datos && Object.keys(recordset[0]).map((cabecera, index) => (
                  <TableHeadCell key={index}> {cabecera} </TableHeadCell>
                ))}
                <TableHeadCell> Accion </TableHeadCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {datos && datos.map((record) => (
                <TableRow key={record.ID}>
                  <TableDataCell>{record.ID}</TableDataCell>
                  <TableDataCell>{record.Nombre}</TableDataCell>
                  <TableDataCell>{record.Perecedero ? "X" : ""}</TableDataCell>
                  <TableDataCell>{record.Ingreso}</TableDataCell>
                  <TableDataCell>{record.Lote}</TableDataCell>
                  <TableDataCell>{record.Caducidad}</TableDataCell>
                  <TableDataCell>{record.Casa}</TableDataCell>
                  <TableDataCell>{record.Tipo}</TableDataCell>
                  <TableDataCell><img src={`data:image/png;base64,${record.Imagen}`} alt="Imagen" style={{width: '35px', height: '35px'}}/></TableDataCell>
                  <TableDataCell>{record.Descripcion.substring(0,6)+'...'}</TableDataCell>
                  <TableDataCell>
                    <Button onClick={() => editar(record)}>Editar</Button>
                    <br/>
                    <Button onClick={() => eliminar(record)}>
                      Eliminar
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
