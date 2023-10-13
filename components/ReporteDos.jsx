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

function ReporteDos() {
  const [recordset, setRecordset] = useState([]);
  const [loaded, setLoaded] = useState(false);
  useEffect(() => {
    const peticion = fetch(`http://${process.env.NEXT_PUBLIC_SERVER}:3000/api/reportes?numero=2`, {
      method: "GET",
    });
    peticion
      .then((response) => response.json())
      .then((datos) => {
        console.log(datos.recordsets);
        console.log(datos.recordsets[0][0]);
        setRecordset(datos);
        setLoaded(true);
      })
      .catch((e) => console.log(e));
  }, []);

  return (
    <Table>
      <TableHead>
        <TableRow>
          <TableHeadCell> enfermos </TableHeadCell>
          <TableHeadCell> accidentados </TableHeadCell>
        </TableRow>
      </TableHead>
      <TableBody>
        <TableRow>
          {loaded && (
            <>
              <TableDataCell>{recordset.recordsets[0][0].Enfermos}</TableDataCell>
              <TableDataCell>
                {recordset.recordsets[1][0].Accidentados}
              </TableDataCell>
            </>
          )}
        </TableRow>
      </TableBody>
    </Table>
  );
}
export default ReporteDos;
