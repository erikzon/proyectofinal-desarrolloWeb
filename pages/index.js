import Router from "next/router";
import { useState } from "react";
import {
  Window,
  WindowHeader,
  WindowContent,
  TextField,
  Button,
  AppBar,
  Toolbar
} from "react95";
require('dotenv').config()

export default function Home() {
  const [usuario, setusuario] = useState("erick");
  const [contrasena, setcontrasena] = useState("4125");
  const [mostrarErrorCredencialesIncorrectas, setMostrarErrorCredencialesIncorrectas] = useState(false)
  const [open, setOpen] = useState(false);
  
  const login = (usuario,contrasena) => {
    const peticion = fetch(`http://${process.env.NEXT_PUBLIC_SERVER}:3000/api/login?usuario=${usuario}&contrasena=${contrasena}`);
    peticion
      .then((response) => response.json())
      .then((datos) => {
        datos.respuesta == 1
          ? Router.push(`/menu?usuario=${usuario}`)
          : setMostrarErrorCredencialesIncorrectas(true);
          setTimeout(() => {
            setMostrarErrorCredencialesIncorrectas(false)
          }, 4000);
      })
    .catch((e) => console.log(e))
    
  }

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
      <Window>
        <WindowHeader active={true} className="window-header">
          <span>Login</span>
        </WindowHeader>
        <div style={{ marginTop: 8 }}>
          <img
            src="https://umg.edu.gt/assets/umg.png"
            alt="refine-logo"
            width={100}
          />
        </div>
        <WindowContent>
          <form
            onSubmit={(e) => {
              e.preventDefault();
              login(usuario, contrasena);
            }}
          >
            <div style={{ width: 500 }}>
              <div style={{ display: "flex" }}>
                <TextField
                  placeholder="User Name"
                  fullWidth
                  value={usuario}
                  onChange={(e) => {
                    setusuario(e.target.value);
                  }}
                />
              </div>
              <br />
              <TextField
                placeholder="contrasena"
                fullWidth
                type="password"
                value={contrasena}
                onChange={(e) => {
                  setcontrasena(e.target.value);
                }}
              />
              <br />
              <Button type="submit" value="login">
                Iniciar Sesion
              </Button>
              {mostrarErrorCredencialesIncorrectas && (
                <h4>Credenciales incorrectas, intente nuevamente.</h4>
              )}
            </div>
          </form>
        </WindowContent>
      </Window>
    </div>
    <AppBar>
      <Toolbar style={{ justifyContent: 'space-between' }}>
      <Button
        onClick={() => setOpen(!open)}
        active={open}
        style={{ fontWeight: 'bold' }}
      >
        <img
          src="https://umg.edu.gt/assets/umg.png"
          alt='react95 logo'
          style={{ height: '24px', marginRight: 4 }}
        />
        Start
      </Button>
      [GRUPO 1] Edgar 7691-15-9407 | Erick 7691-20-10863 | Víctor 7691-19-11984 | Chrissy 7691-20-3886 | Donald 7691-19-11308 | Hugo 7691-20-2920
      </Toolbar>
    </AppBar>
    </>
  );
};
