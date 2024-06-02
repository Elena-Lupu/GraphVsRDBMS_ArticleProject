﻿import { Text, ListaDropDowns, ButonIco } from "./ReactComps.jsx"
import * as JSONdata from "./Constants.js"

let harta = null;
let ctx = null;
let img = null;

window.onload = function () {
    harta = document.getElementById("canvasCentral");
    ctx = harta.getContext('2d');
    img = new Image();

    img.src = "../Pics/OmuletulToamnei.JPG";
    img.onload = function () {
        harta.width = img.width;
        harta.height = img.height;
        ctx.drawImage(img, 0, 0, harta.width, harta.height);
    }

    //Doar pt a extrage coordonatele punctelor de pe harta --> Comenteaza dupa !!!
    function getMousePos(harta, event) {
        const rect = harta.getBoundingClientRect();
        return {
            x: (event.clientX - rect.left) * (harta.width / rect.width),
            y: (event.clientY - rect.top) * (harta.height / rect.height)
        };
    }

    harta.addEventListener('click', function (event) {
        const pos = getMousePos(harta, event);
        console.log(`Mouse position: ${pos.x}, ${pos.y}`);
    });


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
            /* stop moving when mouse button is released:*/
            document.onmouseup = null;
            document.onmousemove = null;
        }
    }

    dragElement(document.getElementById("canvasDiv"));
}

export function testButon() {
    ctx.beginPath();
    ctx.arc(1981, 688, 10, 0, 2 * Math.PI);
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
                    if (tempdata.Traseu[i - 1].nume != tempdata.Traseu[i].nume)
                        chestii.push(<Text text={tempdata.Traseu[i - 1].nume + " ---> " + tempdata.Traseu[i].nume} marime="TextSelect" />);
                chestii.push(<Text text={"FINISH:   " + tempdata.Traseu[len - 1].nume} marime="TextSelect" />);

            } catch { chestii = <Text text="Nu exista traseu !!" marime="TextSelect" />; }
            ReactDOM.render(chestii, document.getElementById('detaliiDiv'));
        })
        .catch(error => console.log(error));
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