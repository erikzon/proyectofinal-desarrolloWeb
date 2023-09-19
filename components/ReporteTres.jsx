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

function ReporteTres() {
  const [recordset, setRecordset] = useState([]);
  const [loaded, setLoaded] = useState(false);
  useEffect(() => {
    const peticion = fetch(`http://localhost:3000/api/reportes?numero=3`, {
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
                    <TableRow key={record.nombreDoctor}>
                      <TableDataCell>{record.nombreDoctor}</TableDataCell>
                      <TableDataCell>{record.repetidos}</TableDataCell>
                      </TableRow>
                  </>
                ))}
              </>
            )}
        </TableBody>
      </Table>
  );
}
export default ReporteTres;
