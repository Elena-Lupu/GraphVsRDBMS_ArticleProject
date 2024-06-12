import * as JSONdata from "./Constants.js"
import * as funcsData from "./Funcs.jsx"

export class Text extends React.Component {
    render() {
        return (
            <div className={this.props.marime}>
                <span>{this.props.text}</span>
            </div>
        );
    }
}

class Tabel extends React.Component {
    render() {
        return (
            <div className="tableBox">
                <table>
                    <thead>
                        <tr>
                            <th>TimeStamp</th>
                            <th>Nr. puncte intermediare</th>
                            <th>Timp executie (ms)</th>
                            <th>Memorie utilizata (MB)</th>
                            <th>CPU (%)</th>
                        </tr>
                    </thead>
                    <tbody>
                        {
                            this.props.data.map((item) => {
                                return (
                                    <tr>
                                        <td>{item.DateTime}</td>
                                        <td>{item.NrPuncteIntermediare}</td>
                                        <td>{item.TimpExecutie_ms}</td>
                                        <td>{item.MemorieUtilizata_MB}</td>
                                        <td>{item.CPU_Pr}</td>
                                    </tr>
                                );
                            })
                        }
                    </tbody>
                </table>
            </div>
        );
    }
}

export class DropDown extends React.Component {
    render() {
        return (
            <div style={{ width: this.props.width, display: "flex" }}>
                <Text marime="TextSelect" text={this.props.text} />
                <select className="selectorStyle" defaultValue='0' id={this.props.id} onChange={() => this.props.func()}>
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

export class ListaDropDowns extends React.Component {
    state = { nr: 1 };

    add = () => {
        if (this.state.nr < 3)
            this.setState({ nr: this.state.nr + 1 });
    }

    remove = () => {
        if (this.state.nr > 0)
            this.setState(
                { nr: this.state.nr - 1 },
                () => {
                    if (this.state.nr == 0) this.props.onZeroFunc()
                }
            );
    }

    render() {
        let lista = [];

        for (let i = 1; i < this.state.nr + 1; i++)
            lista.push(<DropDown text={i.toString() + ". "} data={this.props.data} width="73%" id={"Punct-" + this.props.addId + i.toString()} />);

        return (
            <>
                {lista}
                {lista.length > 0 && (
                        <>
                            <ButonIco svg="plus" func={this.add} />
                            <ButonIco svg="minus" func={this.remove} />
                        </>
                    )
                }
            </>
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
                <input type="checkbox" id={this.props.id} onClick={() => this.props.func()} />
                <Text marime="TextSelect" text={this.props.text} />
            </div>
        );
    }
}

class ButonText extends React.Component {
    render() {
        return (
            <button className="butonStyle" onClick={() => this.props.func()}>
                <Text text={this.props.text} marime="TextButon" />
            </button>
        );
    }
}

export class ButonIco extends React.Component {
    render() {
        return (
            <button className="butonIcoStyle" onClick={() => this.props.func()}>
                <img src={"../SVG/" + this.props.svg + ".svg"} style={{ width: "20px", height: "20px" }} />
            </button>
        );
    }
}

class Meniu extends React.Component {
    render() {
        return (
            <div className="TopBarStyle MeniuStyle">
                <div style={{ width: "15%" }}><Text marime="TextTitlu" text="Precis Way" /></div>
                <DropDown text="Etaj" width="12%" data={JSONdata.etajData} id="SelectEtaj" func={funcsData.schimbaHarta} />
                <div style={{ display: "flex", width: "15%" }}>
                    <ButonIco svg="zoomIn" func={funcsData.zoomInHarta} />
                    <ButonIco svg="zoomOut" func={funcsData.zoomOutHarta} />
                </div>
                <SearchBar />
                <DropDown text="Baza de date utilizata" width="30%" data={JSONdata.BdData} id="BDuser" />
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
                <div style={{ display: "flex" }} id="plusPuncteIntermediare">
                    <ButonIco svg="plus" func={funcsData.adaugaPuncteIntermediare} />
                    <Text text="Adauga puncte intermediare" />
                </div>
                <DropDown text="Punct destinatie" width="90%" data={JSONdata.pointsData} id="PunctDestinatie" />
                <ButonText text="Calculeaza Traseul" func={funcsData.cauta} />
                <br />
                <br />
                <Text text="Filtre" marime="TextSubtitlu" />
                <CheckBox text="Evita Scarile" id="FiltruScari" />
                <CheckBox text="Evita ..." id="FiltruPersonalizat" func={funcsData.addPuncteEvitare} />
                <div id="ListaPuncteEvitate"></div>
                {/*<ButonText text="Teste" func={funcsData.testButon} />*/}
            </div>
        );
    }
}

class DetailBar extends React.Component {
    render() {
        return (
            <div className="BarStyle DetailBarStyle">
                <div style={{ display: "flex" }}>
                    <Text text="Detalii traseu" marime="TextSubtitlu" />
                    <div style={{ padding: "15px" }}><ButonIco svg="trash" func={funcsData.clearTraseu} /></div>
                </div>
                <div id="detaliiDiv"></div>
            </div>
        );
    }
}

class RunDetailsBar extends React.Component {
    render() {
        return (
            <div className="TopBarStyle RunDetailBarStyle">
                <div style={{ flexDirection: "column" }}>
                    <Text text="Detalii rulare" marime="TextSubtitlu" />
                    <br />
                    <ButonText text="Statistica" func={funcsData.DeschideStatistica} />
                </div>
                <div id="detaliiRulareDiv"></div>
            </div>
        );
    }
}

class PozaCentrala extends React.Component {
    render() {
        return (
            <div id="canvasDiv" className="canvasStyle">
                <canvas id="canvasCentral" className="canvasStyle"></canvas>
            </div>
        );
    }
}

export class Pagina extends React.Component {
    render() {
        return (
            <>
                <PozaCentrala />
                <SideBar />
                <DetailBar />
                <RunDetailsBar />
                <Meniu />
            </>
        );
    }
}

export class PaginaStats extends React.Component {
    render() {
        return (
            <div style={{ padding: "10px", height: "100vh" }}>
                <ButonIco svg="inapoi" func={funcsData.intoarcePg} />
                <Text text="Statistici" marime="TextTitlu" />

                <Text text="MS SQL Server" marime="TextSubtitlu" />
                <Text text={"Astazi au fost procesate cu succes " + this.props.nrSQL + " cereri catre server:"} marime="TextSelect" />
                <Tabel data={this.props.dataSQL} />
                <div style={{ display: "flex" }}>
                    <div id="Plot_Timpi_SQL" style={{ width: "20%", paddingRight: "12%" }}></div>
                    <div id="Plot_Mem_SQL" style={{ width: "20%", paddingRight: "12%" }}></div>
                    <div id="Plot_CPU_SQL" style={{ width: "20%", paddingRight: "12%" }}></div>
                </div>

                <br />
                <br />

                <Text text="Neo4j" marime="TextSubtitlu" />
                <Text text={"Astazi au fost procesate cu succes " + this.props.nrNeo + " cereri catre server:"} marime="TextSelect" />
                <Tabel data={this.props.dataNeo} />
                <div style={{ display: "flex" }}>
                    <div id="Plot_Timpi_Neo" style={{ width: "20%", paddingRight: "12%" }}></div>
                    <div id="Plot_Mem_Neo" style={{ width: "20%", paddingRight: "12%" }}></div>
                    <div id="Plot_CPU_Neo" style={{ width: "20%", paddingRight: "12%" }}></div>
                </div>
            </div>
        );
    }
}

ReactDOM.render(<Pagina />, document.getElementById('unDiv'));