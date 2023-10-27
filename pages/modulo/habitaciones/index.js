import {
    Table,
    TableBody,
    TableHead,
    TableRow,
    TableHeadCell,
    TableDataCell,
    Window,
    WindowHeader,
  } from "react95";
  import { useRouter } from "next/router";
  import 'dotenv/config'
  import { useState, useEffect } from "react";
  
  
  export default function Habitaciones() {
    const router = useRouter();
    const [datos, setDatos] = useState();

    useEffect(() => {
      cargar();
      let seguir = setInterval(() => {
        cargar()
      }, 2000);
      return () => {
        clearInterval(seguir);
      };
    }, []); 

    
    const cargar = () => {
      const peticion = fetch(
        `http://${process.env.NEXT_PUBLIC_SERVER}:3000/api/habitaciones`,
        { method: "GET" }
      );
      peticion
        .then((response) => response.json())
        .then((datos) => {
          setDatos(datos);
        })
        .catch((e) => console.log(e));
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
          <WindowHeader active={true} className="window-header">
          <span>HABITACIONES DISPONIBLES (EN TIEMPO REAL)</span>
        </WindowHeader>
          <Table>
                <TableHead>
                    <TableRow>
                        {datos && Object.keys(datos.recordset[0]).map((cabecera, index) => (
                        <TableHeadCell key={index}> {cabecera} </TableHeadCell>
                      ))}
                    </TableRow>
                </TableHead>
                <TableBody>
                {datos && datos.recordset.map((record) => (
                        <TableRow key={record.ID}>
                            <TableDataCell>{record.HabitacionNo}</TableDataCell>
                            <TableDataCell>{record.Clinica}</TableDataCell>
                            <TableDataCell>{record.Ocupada ? 'SI':'No'}</TableDataCell>
                        </TableRow>
                    ))}
                </TableBody>
            </Table>
          </Window>
        </div>
      </>
    );
  }
  