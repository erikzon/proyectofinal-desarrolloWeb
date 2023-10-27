import Router from "next/router";
import { useState, useEffect } from "react";
import { Window, WindowHeader, WindowContent, Button } from "react95";

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
  let { recordset } = await request.query(
    `select ModuloPaciente,ModuloDoctor,ModuloMedicina,ModuloReporte from tipo_usuario 
	inner join usuario on tipo_usuario.ID_TipoUsuario = usuario.FK_ID_TipoUsuario
	where usuario.usuario = '${context.query.usuario}'`
  );
  return {
    props: { recordset },
  };
}

export default function Home({recordset}) {
  return (
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
      <Window>
        <WindowHeader active={true} className="window-header">
          <span>Menu</span>
        </WindowHeader>
        <div style={{ marginTop: 8 }}>
          <img
            src="https://www.vhv.rs/dpng/d/57-578520_nombre-de-la-universidad-mariano-galvez-hd-png.png"
            alt="refine-logo"
            width={100}
          />
        </div>
        <WindowContent>
          <div
            style={{
              width: 300,
              display: "flex",
              alignItems: "center",
              flexDirection: "column",
              gap: "2rem",
            }}
          >
            <Button
              type="submit"
              value="login"
              disabled={!recordset[0].ModuloPaciente}
              onClick={() =>
                Router.push(
                  `/modulo/paciente?habilitado=${recordset[0].ModuloDoctor}`
                )
              }
            >
              Modulo Paciente
            </Button>
            <Button
              type="submit"
              value="login"
              disabled={!recordset[0].ModuloDoctor}
              onClick={() => Router.push("/modulo/doctor")}
            >
              Modulo Empleados
            </Button>
            <Button
              type="submit"
              value="login"
              disabled={!recordset[0].ModuloMedicina}
              onClick={() => Router.push("/modulo/medicina")}
            >
              Modulo Inventario
            </Button>
            <Button
              type="submit"
              value="login"
              disabled={!recordset[0].ModuloReporte}
              onClick={() => Router.push("/modulo/reportes")}
            >
              Historial Clinico de Pacientes
            </Button>
            <Button
              type="submit"
              value="login"
              disabled={!recordset[0].ModuloPaciente}
              onClick={() => Router.push("/modulo/habitaciones")}
            >
              Habitaciones Disponibles
            </Button>
            <Button
              type="submit"
              value="login"
              disabled={!recordset[0].ModuloReporte}
              onClick={() => Router.push("/modulo/usuarios")}
            >
              Modulo Usuarios
            </Button>
          </div>
        </WindowContent>
      </Window>
    </div>
  );
}
