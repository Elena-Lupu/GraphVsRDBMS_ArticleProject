import { Text, ListaDropDowns, ButonIco } from "./ReactComps.jsx"
import * as JSONdata from "./Constants.js"

export function cauta() {
    let bd = document.getElementById("BDuser").value;
    let punctPlecare = document.getElementById("PunctPlecare").value;
    let punctDestinatie = document.getElementById("PunctDestinatie").value;
    let bdController = "";
    let chestii = [];
    let filtruScari = document.getElementById("FiltruScari").checked;
    let puncteEvitate = [];
    let puncteIntermediare = [];

    switch (bd) {
        case '1': bdController = "Neo4j"; break;
        case '2': bdController = "SQLServer"; break;
        default: alert("Alege serios !!!"); return;
    }

    if (punctPlecare == "0") {
        alert("Alege un punct de plecare !");
        return;
    }
    if (punctDestinatie == "0") {
        alert("Alege un punct de destinatie !");
        return;
    }
    if (isNaN(punctDestinatie) || isNaN(punctPlecare)) {
        alert("Alege serios !!!");
        return;
    }

    if (document.getElementById("ListaPuncteEvitate").innerHTML != "") {
        var i = 1;
        var vals = "0";

        while (document.getElementById("Punct-Evitate" + i.toString()) != null) {
            vals = document.getElementById("Punct-Evitate" + i.toString()).value;
            if (vals != punctPlecare && vals != punctDestinatie)
                puncteEvitate.push(vals);
            i++;
        }
    }

    if (document.getElementById("plusPuncteIntermediare").innerHTML != "") {
        var i = 1;
        var vals = "0";

        while (document.getElementById("Punct-Intermediare" + i.toString()) != null) {
            vals = document.getElementById("Punct-Intermediare" + i.toString()).value;
            if (vals != punctPlecare && vals != punctDestinatie)
                puncteIntermediare.push(vals);
            i++;
        }
    }

    let params = new URLSearchParams();
    params.append("punctPlecare", punctPlecare);
    params.append("punctDestinatie", punctDestinatie);
    params.append("filtruScari", filtruScari);
    params.append("puncteEvitate", puncteEvitate);
    params.append("puncteIntermediare", puncteIntermediare);

    let options = {
        method: "POST",
        body: params
    };

    fetch(webPath + bdController + "/CalculeazaTraseu", options).then(response => response.text())
        .then(data => {
            try {
                var tempdata = JSON.parse(data);
                var len = Object.keys(tempdata.Traseu).length;

                chestii.push(<Text text={"START:   " + tempdata.Traseu[0].nume} marime="TextSelect" />);
                for (var i = 1; i < len; i++)
                    chestii.push(<Text text={tempdata.Traseu[i - 1].nume + " ---> " + tempdata.Traseu[i].nume} marime="TextSelect" />);
                chestii.push(<Text text={"FINISH:   " + tempdata.Traseu[len - 1].nume} marime="TextSelect" />);

            } catch { chestii = <Text text="Nu exista traseu !!" marime="TextSelect" />; }
            ReactDOM.render(chestii, document.getElementById('detaliiDiv'));
        })
        .catch(error => console.log(error));
}

export function addPuncteEvitare() {
    if (document.getElementById("FiltruPersonalizat").checked == true)
        ReactDOM.render(<ListaDropDowns data={JSONdata.pointsData} addId="Evitate" />, document.getElementById("ListaPuncteEvitate"));
    else
        ReactDOM.render("", document.getElementById("ListaPuncteEvitate"));
}

export function adaugaPuncteIntermediare() {
    document.getElementById("plusPuncteIntermediare").style.display = "";
    ReactDOM.render(<ListaDropDowns data={JSONdata.pointsData} onZeroFunc={replaceInitialText} addId="Intermediare" />, document.getElementById("plusPuncteIntermediare"));
}

function replaceInitialText() {
    document.getElementById("plusPuncteIntermediare").style.display = "flex";
    ReactDOM.render(
        <>
            <ButonIco svg="plus" func={adaugaPuncteIntermediare} />
            <Text text="Adauga puncte intermediare" />
        </>, document.getElementById("plusPuncteIntermediare")
    );
}