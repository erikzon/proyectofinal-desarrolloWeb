import React from "react";

import {
  Table,
  TableBody,
  TableHead,
  TableRow,
  TableHeadCell,
  TableDataCell,
} from "react95";

import { useState, useEffect, useRef } from "react";

function ReporteSeis() {
  const [recordset, setRecordset] = useState([]);
  const [loaded, setLoaded] = useState(false);
  useEffect(() => {
    const peticion = fetch(`http://${process.env.NEXT_PUBLIC_SERVER}:3000/api/reportes?numero=6`, {
      method: "GET",
    });
    peticion
      .then((response) => response.json())
      .then((datos) => {
        if (datos !== null && datos.length > 0) {
          setRecordset(datos);
          setLoaded(true);
        }
      })
      .catch((e) => console.log(e));
  }, []);

  return (
    <Table>
      <TableHead>
        <TableRow>
          {loaded &&
            Object.keys(recordset[0]).map((cabecera, index) => (
              <TableHeadCell key={index}> {cabecera} </TableHeadCell>
            ))}
        </TableRow>
      </TableHead>
      <TableBody>
        {loaded && (
          <>
            {recordset.map((record) => (
              <>
                <TableRow key={record.Nombre}>
                  <TableDataCell>{record.Nombre}</TableDataCell>
                  <TableDataCell>{record.Apellido}</TableDataCell>
                  <TableDataCell>{record.Estado}</TableDataCell>
                  <TableDataCell>{record.Contacto}</TableDataCell>
                  <TableDataCell>{record.Edad}</TableDataCell>
                  <TableDataCell>{record.AltaBaja ? "Alta" : 'Baja'}</TableDataCell>
                  <TableDataCell>{record.Colegiado}</TableDataCell>
                  <TableDataCell>{new Date(record.FechaIngreso).toISOString().slice(0,10)}</TableDataCell>
                  <TableDataCell>{new Date(record.FechaSalida).toISOString().slice(0,10)}</TableDataCell>
                  <TableDataCell>{record.Enfermedad && "X"}</TableDataCell>
                  <TableDataCell>{record.Accidente && "X"}</TableDataCell>
                </TableRow>
              </>
            ))}
          </>
        )}
      </TableBody>
    </Table>
  );
}
export default ReporteSeis;
