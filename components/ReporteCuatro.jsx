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

function ReporteCuatro() {
  const [recordset, setRecordset] = useState([]);
  const [loaded, setLoaded] = useState(false);
  useEffect(() => {
    const peticion = fetch(`http://${process.env.SERVER}:3000/api/reportes?numero=4`, {
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
        {loaded && (
          <>
            {recordset.map((record) => (
              <>
                <TableRow key={record.Nombre}>
                  <TableDataCell>{record.Nombre}</TableDataCell>
                </TableRow>
              </>
            ))}
          </>
        )}
      </TableBody>
    </Table>
  );
}
export default ReporteCuatro;
