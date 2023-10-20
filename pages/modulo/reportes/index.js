import {
  Window,
  WindowHeader,
} from "react95";

import ReporteUno from "../../../components/ReporteUno";
import ReporteDos from "../../../components/ReporteDos";
import ReporteTres from "../../../components/ReporteTres";
import ReporteCuatro from "../../../components/ReporteCuatro";
import ReporteCinco from "../../../components/ReporteCinco";
import ReporteSeis from "../../../components/ReporteSeis";

export default function Reportes(props) {
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
        <Window
          resizable
          style={{
            width: "95%",
            display: "flex",
            flexDirection: "column",
            justifyContent: "center",
          }}
        >
          <WindowHeader>Historial Clinico</WindowHeader>
          <h4>1. Los pacientes que más visitas han tenido. </h4>
          <div
            style={{ width: "95%", margin: "0 auto", paddingBottom: "1rem" }}
          >
            <ReporteUno />
          </div>
          <h4>
            2. Conteo y visualización de pacientes por enfermedad o accidente
            (si aplica).
          </h4>
          <div
            style={{ width: "30%", margin: "0 auto", paddingBottom: "1rem" }}
          >
            <ReporteDos />
          </div>
          <h4>3. Cantidad de personas atendidos por médico. </h4>
          <div
            style={{ width: "30%", margin: "0 auto", paddingBottom: "1rem" }}
          >
            <ReporteTres />
          </div>
          <h4>
            4. Los suministros o medicinas que más se han dado a los pacientes.
          </h4>
          <div
            style={{ width: "30%", margin: "0 auto", paddingBottom: "1rem" }}
          >
            <ReporteCuatro />
          </div>
          <h4>
            5. Cálculo de edades de los pacientes que más se han enfermado por
            mes.
          </h4>
          <div
            style={{ width: "30%", margin: "0 auto", paddingBottom: "1rem" }}
          >
            <ReporteCinco />
          </div>
          <h4>6. Antecedentes médicos de enfermedad por paciente. </h4>
          <div
            style={{ width: "98%", margin: "0 auto", paddingBottom: "1rem" }}
          >
            <ReporteSeis />
          </div>
        </Window>
      </div>
    </>
  );
}
