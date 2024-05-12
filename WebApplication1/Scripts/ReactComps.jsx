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

export class DropDown extends React.Component {
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
                <ButonText text="Calculeaza Traseul" func={funcsData.cauta} />
                <br />
                <br />
                <Text text="Filtre" marime="TextSubtitlu" />
                <CheckBox text="Evita Scarile" id="FiltruScari" />
                <CheckBox text="Evita ..." id="FiltruPersonalizat" func={funcsData.addPuncteEvitare} />
                <div id="ListPuncteEvitate"></div>
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