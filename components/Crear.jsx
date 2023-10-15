import { useState, useEffect } from "react";

import { Window, WindowHeader, Select, TextField, Button } from "react95";

function Crear() {
  const [usuario, setusuario] = useState("erick");
  const [contrasena, setcontrasena] = useState("4125");
  const [tipoUsuario, setTipoUsuario] = useState(1);
  const [dpi, setDPI] = useState();
  const [opt, setOPT] = useState([
    { value: 1, label: "consulta" },
    { value: 2, label: "operador" },
    { value: 3, label: "administrador" },
  ]);

  useEffect(() => {
    const peticion = fetch(
      `http://${process.env.NEXT_PUBLIC_SERVER}:3000/api/usuarios`,
      { method: "GET" }
    );
    peticion
      .then((response) => response.json())
      .then((datos) => {
        console.log(datos);
        setOPT(datos)
      })
      .catch((e) => console.log(e));
  }, []);

  return (
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
          <div style={{ display: "flex", gap: "1rem", alignItems: "center" }}>
            Usuario
            <TextField
              placeholder="User Name"
              fullWidth
              value={usuario}
              onChange={(e) => {
                setusuario(e.target.value);
              }}
            />
          </div>
          <div style={{ display: "flex", gap: "1rem", alignItems: "center" }}>
            Contrasena
            <TextField
              placeholder="contrasena"
              fullWidth
              type="password"
              value={contrasena}
              onChange={(e) => {
                setcontrasena(e.target.value);
              }}
            />
          </div>
        </section>
        <section>
          <div style={{ display: "flex", gap: "1rem", alignItems: "center" }}>
            DPI
            <TextField
              placeholder="contrasena"
              fullWidth
              type="text"
              value={contrasena}
              onChange={(e) => {
                setcontrasena(e.target.value);
              }}
            />
          </div>
          <div style={{ display: "flex", gap: "1rem", alignItems: "center" }}>
            Tipo usuario
            <Select
              options={opt}
              onChange={(e) => {
                setTipoUsuario(e.target.value);
              }}
            />
          </div>
        </section>
        <Button type="button">Crear</Button>
      </div>
    </form>
    
  );
}
export default Crear;
