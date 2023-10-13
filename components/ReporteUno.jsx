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

function ReporteUno() {
  const [recordset, setRecordset] = useState([]);
  const [loaded, setLoaded] = useState(false);
  useEffect(() => {
    const peticion = fetch(`http://${process.env.SERVER}:3000/api/reportes?numero=1`, {
      method: "GET",
    });
    peticion
      .then((response) => response.json())
      .then((datos) => {
        setRecordset(datos);
        setLoaded(true);
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
        {recordset.map((record) => (
          <TableRow key={record.ID}>
            <TableDataCell>{record.ID}</TableDataCell>
            <TableDataCell>{record.Identificador}</TableDataCell>
            <TableDataCell>{record.Nombre}</TableDataCell>
            <TableDataCell>{record.Apellido}</TableDataCell>
            <TableDataCell>{record.Residencia}</TableDataCell>
            <TableDataCell>{record.Contacto}</TableDataCell>
            <TableDataCell>{record.Estado}</TableDataCell>
            <TableDataCell>
              {record.AltaBaja ? "de alta" : "de baja"}
            </TableDataCell>
            <TableDataCell>{record.Edad}</TableDataCell>
            <TableDataCell>{record.Visitas}</TableDataCell>
          </TableRow>
        ))}
      </TableBody>
    </Table>
  );
}
export default ReporteUno
