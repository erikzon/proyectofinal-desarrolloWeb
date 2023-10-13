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
import { useRef, useState } from "react";

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
  let { recordset } = await request.query("exec readMedicina");
  return {
    props: { recordset },
  };
}

export default function Medicina({ recordset }) {
  const router = useRouter();
  const refreshData = () => {
    router.replace(router.asPath);
  };

  const [modalCrear, setModalCrear] = useState(false);

  const [modoUpdate, setModoUpdate] = useState(false);

  const eliminar = (usuario) => {
    const peticion = fetch(
      `http://${process.env.SERVER}:3000/api/medicina?usuario=${usuario}`,
      { method: "DELETE" }
    );
    peticion
      .then((response) => response.json())
      .then((datos) => {
        refreshData();
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
      const peticion = fetch("http://${process.env.SERVER}:3000/api/medicina", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data),
      });
      peticion
        .then((response) => response.json())
        .then((datos) => {
          refreshData();
          setModalCrear(false);
        })
        .catch((e) => console.log(e));
    };
    reader.readAsDataURL(ImagenRef.current.files[0]);
  };
  

  const editarMedicina = () => {
    const peticion = fetch(
      `http://${process.env.SERVER}:3000/api/medicina?usuario=${nombreRef.current.value}&fechaingreso=${fechaIngresoRef.current.value}&fechalote=${fechaLoteRef.current.value}&fechacaducidad=${fechaCaducidadRef.current.value}&casa=${casaRef.current.value}&tipomedicamento=${tipoMedicamentoRef.current.value}`,
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
    setTimeout(() => {
      nombreRef.current.value = record.Nombre;
      fechaIngresoRef.current.value = record.Fecha_Ingreso;
      fechaLoteRef.current.value = record.Fecha_Lote;
      fechaCaducidadRef.current.value = record.Fecha_Caducidad;
      casaRef.current.value = record.Casa;
      tipoMedicamentoRef.current.value = record.TipoMedicamento;
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
          <WindowHeader>Medicina</WindowHeader>
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
                    <TextField fullWidth type="text" ref={fechaIngresoRef} />
                  </div>
                  <div
                    style={{
                      display: "flex",
                      gap: "1rem",
                      alignItems: "center",
                    }}
                  >
                    Fecha Lote
                    <TextField fullWidth type="text" ref={fechaLoteRef} />
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
                    <TextField fullWidth type="text" ref={fechaCaducidadRef} />
                  </div>
                  <div
                    style={{
                      display: "flex",
                      gap: "1rem",
                      alignItems: "center",
                    }}
                  >
                    Casa
                    <TextField fullWidth type="text" ref={casaRef} />
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
              {/* <div
                style={{
                  display: "flex",
                  gap: "1rem",
                  alignItems: "center",
                }}
              >
                URL de la imagen
                <TextField fullWidth type="text" ref={ImagenRef} />
              </div> */}
              <div
                style={{
                  display: "flex",
                  gap: "1rem",
                  alignItems: "center",
                }}
              >
                Imagen
                <input type="file" ref={ImagenRef} />
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
                <TableRow key={record.ID_Medicina}>
                  <TableDataCell>{record.ID_Medicina}</TableDataCell>
                  <TableDataCell>{record.Nombre}</TableDataCell>
                  <TableDataCell>{record.Perecedero ? "X" : ""}</TableDataCell>
                  <TableDataCell>{record.Fecha_Ingreso}</TableDataCell>
                  <TableDataCell>{record.Fecha_Lote}</TableDataCell>
                  <TableDataCell>{record.Fecha_Caducidad}</TableDataCell>
                  <TableDataCell>{record.Casa}</TableDataCell>
                  <TableDataCell>{record.TipoMedicamento}</TableDataCell>
                  <TableDataCell><img src={`data:image/png;base64,${record.Imagen}`} alt="Imagen" style={{width: '35px', height: '35px'}}/></TableDataCell>
                  <TableDataCell>
                    <Button onClick={() => editar(record)}>Editar</Button>
                    <Button onClick={() => eliminar(record.ID_Medicina)}>
                      eliminar
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
