import * as JSONdata from "./Constants.js"

class Text extends React.Component {
    render() {
        return (
            <div className={this.props.marime}>
                <span>{this.props.text}</span>
            </div>
        );
    }
}

class DropDown extends React.Component {
    render() {
        return (
            <div style={{ width: this.props.width, display: "flex" }}>
                <Text marime="TextSelect" text={this.props.text} />
                <select className="selectorStyle" defaultValue='0' id={this.props.id}>
                    {this.props.data[0].groupName == null
                        ? this.props.data.map((item) => { return (<option value={item.id}>{item.nume}</option>); })
                        : this.props.data.map((item) => {
                            return (
                                <>
                                <option value="0" disabled hidden>...</option>
                                <optgroup label={item.groupName}>
                                    {item.points.map((item2) => { return (<option value={item2.id}>{item2.nume}</option>); })};
                                </optgroup>
                                </>
                            );
                        })
                    };
                </select>
            </div>
        );
    }
}

class SearchBar extends React.Component {
    render() {
        return (
            <div style={{ width: "40%" }}><input className="selectorStyle" placeholder="Cauta..." style={{ width: "50%" }} /></div>
        );
    }
}

class CheckBox extends React.Component {
    render() {
        return (
            <div className="CheckBoxStyle">
                <input type="checkbox" id={this.props.id} />
                <Text marime="TextSelect" text={this.props.text} />
            </div>
        );
    }
}

class ButonCalcul extends React.Component {
    cauta() {
        let bd = document.getElementById("BDuser").value;
        let punctPlecare = document.getElementById("PunctPlecare").value;
        let punctDestinatie = document.getElementById("PunctDestinatie").value;
        let bdController = "";
        let chestii = [];
        let filtruScari = document.getElementById("FiltruScari").checked;

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

        let params = new URLSearchParams();
        params.append("punctPlecare", punctPlecare);
        params.append("punctDestinatie", punctDestinatie);
        params.append("filtruScari", filtruScari);

        let options = {
            method: "POST",
            body: params
        };

        fetch(webPath + bdController +"/CalculeazaTraseu", options).then(response => response.text())
            .then(data => {
                var tempdata = JSON.parse(data);
                var len = Object.keys(tempdata.Traseu).length;

                chestii.push(<Text text={"START:   " + tempdata.Traseu[0].nume} marime="TextSelect" />);
                for (var i = 1; i < len; i++)
                    chestii.push(<Text text={tempdata.Traseu[i-1].nume + " ---> " + tempdata.Traseu[i].nume} marime="TextSelect" />);
                chestii.push(<Text text={"FINISH:   " + tempdata.Traseu[len-1].nume} marime="TextSelect" />);

                ReactDOM.render(chestii, document.getElementById('detaliiDiv'));
            })
            .catch(error => console.log(error));
    }

    render() {
        return (
            <button className="butonStyle" onClick={() => this.cauta() }>
                <Text text="Calculeaza Traseul" marime="TextButon" />
            </button>
        );
    }
}

class Meniu extends React.Component {
    render() {
        return (
            <div className="TopBarStyle MeniuStyle">
                <div style={{ width: "15%" }}><Text marime="TextTitlu" text="Precis Way" /></div>
                <DropDown text="Etaj" width="20%" data={JSONdata.etajData} />
                <SearchBar />
                <DropDown text="Baza de date utilizata" width="30%" data={JSONdata.BdData} id="BDuser"/>
            </div>
        );
    }
}

class SideBar extends React.Component {
    render() {
        return (
            <div className="BarStyle SideBarStyle">
                <Text text="Configurarea traseului" marime="TextSubtitlu"/>
                <DropDown text="Punct plecare" width="90%" data={JSONdata.pointsData} id="PunctPlecare" />
                <DropDown text="Punct destinatie" width="90%" data={JSONdata.pointsData} id="PunctDestinatie" />
                <ButonCalcul />
                <br />
                <br />
                <Text text="Filtre" marime="TextSubtitlu" />
                <CheckBox text="Evita Scarile" id="FiltruScari"/>
                <CheckBox text="Evita ..." id="FiltruPersonalizat"/>
            </div>
        );
    }
}

class DetailBar extends React.Component {
    render() {
        return (
            <div className="BarStyle DetailBarStyle">
                <Text text="Detalii traseu" marime="TextSubtitlu" />
                <div id="detaliiDiv"></div>
            </div>
        );
    }
}

class RunDetailsBar extends React.Component {
    render() {
        return (
            <div className="TopBarStyle RunDetailBarStyle">
                <Text text="Detalii rulare" marime="TextSubtitlu" />
                <div id="detaliiRulareDiv"></div>
            </div>
        );
    }
}

class Pagina extends React.Component {
    render() {
        return (
            <>
                <SideBar />
                <DetailBar />
                <RunDetailsBar />
                <Meniu />
            </>
        );
    }
}

ReactDOM.render(<Pagina />, document.getElementById('unDiv'));