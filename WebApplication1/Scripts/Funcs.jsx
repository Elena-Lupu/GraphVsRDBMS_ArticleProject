import { Text, ListaDropDowns, ButonIco, PaginaStats, Pagina } from "./ReactComps.jsx"
import * as JSONdata from "./Constants.js"

let harta = null;
let ctx = null;
let img = null;
let traseu = null;
let posX = 0;
let posY = 0;
let hartaId = "8";

window.onload = function () {
    harta = document.getElementById("canvasCentral");
    ctx = harta.getContext('2d');
    img = new Image();
    img.src = "../Pics/Parter_MappedIn.png";
    img.onload = function () {
        harta.width = img.width;
        harta.height = img.height;
        ctx.drawImage(img, 0, 0, harta.width, harta.height);
    }

    /*
    //Doar pt a extrage coordonatele punctelor de pe harta --> Comenteaza dupa !!!
    function getMousePos(harta, event) {
        const rect = harta.getBoundingClientRect();
        return {
            x: (event.clientX - rect.left) * (harta.width / rect.width),
            y: (event.clientY - rect.top) * (harta.height / rect.height)
        };
    }

    harta.addEventListener('click', function (event) {
        //Deseneaza cerc + linie intre cercuri --> Pt extragere de puncte
        ctx.beginPath();
        const pos = getMousePos(harta, event);

        ctx.arc(pos.x, pos.y, 25, 0, 2 * Math.PI);
        ctx.fillStyle = 'blue';
        ctx.fill();
        ctx.lineWidth = 2;
        ctx.strokeStyle = '#003300';
        ctx.moveTo(posX, posY);
        if (posX != 0) ctx.lineTo(pos.x, pos.y);
        posX = pos.x;
        posY = pos.y;
        ctx.stroke();

        console.log(`Mouse position: ${pos.x}, ${pos.y}`);
    });
    */

    function dragElement(elmnt) {
        var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
        elmnt.onmousedown = dragMouseDown;

        function dragMouseDown(e) {
            e = e || window.event;
            e.preventDefault();
            pos3 = e.clientX;
            pos4 = e.clientY;
            document.onmouseup = closeDragElement;
            document.onmousemove = elementDrag;
        }

        function elementDrag(e) {
            e = e || window.event;
            e.preventDefault();
            pos1 = pos3 - e.clientX;
            pos2 = pos4 - e.clientY;
            pos3 = e.clientX;
            pos4 = e.clientY;
            elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
            elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
        }

        function closeDragElement() {
            document.onmouseup = null;
            document.onmousemove = null;
        }
    }

    dragElement(document.getElementById("canvasDiv"));
}

export function testButon() {
    ctx.beginPath();
    ctx.arc(257, 434, 10, 0, 2 * Math.PI);
    ctx.fillStyle = 'blue';
    ctx.fill();
    ctx.lineWidth = 1;
    ctx.strokeStyle = '#003300';
    ctx.stroke();
}


export function cauta() {
    let bd = document.getElementById("BDuser").value;
    let punctPlecare = document.getElementById("PunctPlecare").value;
    let punctDestinatie = document.getElementById("PunctDestinatie").value;
    let bdController = "";
    let chestii = [];
    let detaliiRulare = [];
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
            clearTraseu();
            try {
                traseu = JSON.parse(data);
                var len = Object.keys(traseu.Traseu).length;

                chestii.push(<Text text={"START:   " + traseu.Traseu[0].nume} marime="TextSelect" />);
                for (var i = 1; i < len; i++)
                    if (traseu.Traseu[i - 1].nume != traseu.Traseu[i].nume)
                        chestii.push(<Text text={traseu.Traseu[i - 1].nume + " ---> " + traseu.Traseu[i].nume} marime="TextSelect" />);
                chestii.push(<Text text={"FINISH:   " + traseu.Traseu[len - 1].nume} marime="TextSelect" />);

                detaliiRulare.push(<Text text={"--> Baza de Date utilizata:  " + bdController} marime="TextSelect" />);
                detaliiRulare.push(<Text text={"--> Timestamp:  " + traseu.DateRulare.DateTime} marime="TextSelect" />);
                detaliiRulare.push(<Text text={"--> Pondere:  " + traseu.DateRulare.Pondere} marime="TextSelect" />);
                detaliiRulare.push(<Text text={"--> Nr de puncte intermediare:  " + traseu.DateRulare.NrPuncteIntermediare} marime="TextSelect" />);
                detaliiRulare.push(<Text text={"--> Nr de puncte evitate:  " + traseu.DateRulare.NrPuncteEvitate} marime="TextSelect" />);
                detaliiRulare.push(<Text text={"--> Timp de calcul:  " + traseu.DateRulare.TimpExecutie_ms + " ms"} marime="TextSelect" />);
                detaliiRulare.push(<Text text={"--> Memorie utilizata de BD:  " + traseu.DateRulare.MemorieUtilizata_MB + " MB"} marime="TextSelect" />);
                detaliiRulare.push(<Text text={"--> CPU:  " + traseu.DateRulare.CPU_Pr + " %"} marime="TextSelect" />);

            } catch { chestii = <Text text="Nu exista traseu !!" marime="TextSelect" />; }
            ReactDOM.render(chestii, document.getElementById('detaliiDiv'));
            ReactDOM.render(detaliiRulare, document.getElementById('detaliiRulareDiv'));
            punePunctePeHarta();
        })
        .catch(error => console.log(error));
}

export function DeschideStatistica() {
    let jsonVector = null;
    let xVector = [];
    let yVector = [];
    document.body.style.backgroundColor = '#000660';

    fetch(webPath + "Home/GetStats", { method: "POST" }).then(response => response.text())
        .then(data => {
            jsonVector = JSON.parse(data);
            ReactDOM.render(<PaginaStats
                nrSQL={jsonVector.SQLServer.length}
                nrNeo={jsonVector.Neo.length}
                dataSQL={jsonVector.SQLServer}
                dataNeo={jsonVector.Neo}
            />, document.getElementById('unDiv'))

            //SQL Server
            jsonVector.SQLServer.forEach((el) => {
                xVector.push(el.DateTime);
                yVector.push(parseInt(el.TimpExecutie_ms));
            });
            deseneazaGrafic("Timpi de executie (ms)", xVector, yVector, "Plot_Timpi_SQL");

            yVector = [];
            jsonVector.SQLServer.forEach((el) => yVector.push(parseFloat((el.MemorieUtilizata_MB).replaceAll(',', '.'))));
            deseneazaGrafic("Memorie utilizata (MB)", xVector, yVector, "Plot_Mem_SQL");

            yVector = [];
            jsonVector.SQLServer.forEach((el) => yVector.push(parseFloat((el.CPU_Pr).replaceAll(',', '.'))));
            deseneazaGrafic("CPU (%)", xVector, yVector, "Plot_CPU_SQL");

            //Neo4j
            xVector = [];
            yVector = [];
            jsonVector.Neo.forEach((el) => {
                xVector.push(el.DateTime);
                yVector.push(parseInt(el.TimpExecutie_ms));
            });
            deseneazaGrafic("Timpi de executie (ms)", xVector, yVector, "Plot_Timpi_Neo");

            yVector = [];
            jsonVector.Neo.forEach((el) => yVector.push(parseFloat(el.MemorieUtilizata_MB)));
            deseneazaGrafic("Memorie utilizata (MB)", xVector, yVector, "Plot_Mem_Neo");

            yVector = [];
            jsonVector.Neo.forEach((el) => yVector.push(parseFloat(el.CPU_Pr)));
            deseneazaGrafic("CPU (%)", xVector, yVector, "Plot_CPU_Neo");
        })
        .catch(error => console.log(error));
}

export function intoarcePg() {
    location.reload();
}

export function addPuncteEvitare() {
    if (document.getElementById("FiltruPersonalizat").checked == true)
        ReactDOM.render(<ListaDropDowns data={JSONdata.pointsData} addId="Evitate" onZeroFunc={debif} />, document.getElementById("ListaPuncteEvitate"));
    else
        ReactDOM.render("", document.getElementById("ListaPuncteEvitate"));
}

export function adaugaPuncteIntermediare() {
    document.getElementById("plusPuncteIntermediare").style.display = "";
    ReactDOM.render(<ListaDropDowns data={JSONdata.pointsData} onZeroFunc={replaceInitialText} addId="Intermediare" />, document.getElementById("plusPuncteIntermediare"));
}

export function clearTraseu() {
    ctx.clearRect(0, 0, harta.width, harta.height);
    ctx.drawImage(img, 0, 0, harta.width, harta.height);

    traseu = null;
    posX = 0;
    posY = 0;

    ReactDOM.render(null, document.getElementById('detaliiDiv'));
    ReactDOM.render(null, document.getElementById('detaliiRulareDiv'));
}

export function zoomInHarta() {
    let ceva = document.getElementById("canvasDiv");
    ceva.style.width = (parseFloat(getComputedStyle(ceva).width) + 50) + 'px';
    ceva.style.height = (parseFloat(getComputedStyle(ceva).height) + 50) + 'px';
}

export function zoomOutHarta() {
    let ceva = document.getElementById("canvasDiv");
    ceva.style.width = (parseFloat(getComputedStyle(ceva).width) - 50) + 'px';
    ceva.style.height = (parseFloat(getComputedStyle(ceva).height) - 50) + 'px';
}

export function schimbaHarta(etaj = 0) {
    let pozaHarta = "";
    hartaId = etaj == 0 ? document.getElementById("SelectEtaj").value : etaj;

    switch (hartaId) {
        case "8": pozaHarta = "Parter"; break;
        case "1": pozaHarta = "Etaj_1"; break;
        case "2": pozaHarta = "Etaj_2"; break;
        case "3": pozaHarta = "Etaj_3"; break;
        case "4": pozaHarta = "Etaj_4"; break;
        case "5": pozaHarta = "Etaj_5"; break;
        case "6": pozaHarta = "Etaj_6"; break;
        case "7": pozaHarta = "Etaj_7"; break;
    }

    img.src = "../Pics/" + pozaHarta + "_MappedIn.png";
    img.onload = function () {
        harta.width = img.width;
        harta.height = img.height;
        ctx.drawImage(img, 0, 0, harta.width, harta.height);
        punePunctePeHarta();
    }
}

function deseneazaGrafic(titlu, xVector, yVector, id) {
    let layout = {
        width: parseInt(getComputedStyle(document.getElementById(id)).width) * 1.5,
        height: parseInt(getComputedStyle(document.getElementById(id)).width),
        title: titlu,
        xaxis: { 'visible': false }
    }
    Plotly.newPlot(id, [{ x: xVector, y: yVector, type: 'scatter' }], layout);
}

function punePunctePeHarta() {
    if (traseu != null && traseu != "") {
        let len = traseu.Traseu.length;
        let label = "";

        posX = 0;
        posY = 0;

        for (let i = 0; i < len; i++)
            if (etajPunct(traseu.Traseu[i].nume, hartaId) == hartaId) {
                label = traseu.Traseu[i].nume;
                if (traseu.Traseu[i].nume == "Scari_1" || traseu.Traseu[i].nume == "Scari_2" || traseu.Traseu[i].nume == "Scari_Mici" || traseu.Traseu[i].nume == "Lift")
                    switch (hartaId) {
                        case "8": label += "_0"; break;
                        case "1": label += "_1"; break;
                        default: label += "_2_7";
                    }

                colorHarta(
                    eval("JSONdata.drawCoord." + label + ".x"),
                    eval("JSONdata.drawCoord." + label + ".y"),
                    eval("JSONdata.drawCoord." + label + ".radius"),
                    i == 0 ? 'red' : (i == len - 1 ? 'green' : 'blue')
                );
            }
    }
}

function etajPunct(punct, etaj) {
    let char = punct.charAt(2);

    if (punct == "Iesire_1" || punct == "Iesire_2") return "8";

    switch (char) {
        case '0': return "8"; break;
        case '1': return "1"; break;
        case '2': return "2"; break;
        case '3': return "3"; break;
        case '4': return "4"; break;
        case '5': return "5"; break;
        case '6': return "6"; break;
        case '7': return "7"; break;
        default:
            if (punct == "Scari_1" || punct == "Scari_2" || punct == "Lift") return etaj;
            else
                if (etaj == "8" || etaj == "1") return etaj;
    }

    return "x";
}

function colorHarta(x, y, radius, culoare) {
    let ang = 0;
    ang = Math.atan2(y - posY, x - posX);

    ctx.beginPath();
    ctx.arc(x, y, radius, 0, 2 * Math.PI);
    ctx.fillStyle = culoare;
    ctx.fill();
    ctx.lineWidth = 2;
    ctx.strokeStyle = '#003300';
    ctx.stroke();
    ctx.beginPath();
    ctx.lineWidth = 2;
    ctx.strokeStyle = '#ac7900';
    ctx.moveTo(posX, posY);
    if (posX != 0) {
        ctx.lineTo(x, y);
        ctx.lineTo(x - 15 * Math.cos(ang - Math.PI / 6), y - 15 * Math.sin(ang - Math.PI / 6));
        ctx.moveTo(x, y);
        ctx.lineTo(x - 15 * Math.cos(ang + Math.PI / 6), y - 15 * Math.sin(ang + Math.PI / 6));
    }
    posX = x;
    posY = y;
    ctx.stroke();
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

function debif() {
    document.getElementById("FiltruPersonalizat").checked = false;
}