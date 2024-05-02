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
                <select className="selectorStyle" defaultValue='0'>
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
                <input type="checkbox" />
                <Text marime="TextSelect" text={this.props.text} />
            </div>
        );
    }
}

class ButonCalcul extends React.Component {
    cauta() {
        alert("functioneeeeeez!");
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
            <div className="MeniuStyle">
                <div style={{ width: "15%" }}><Text marime="TextTitlu" text="Precis Way" /></div>
                <DropDown text="Etaj" width="20%" data={JSONdata.etajData} />
                <SearchBar />
                <DropDown text="Baza de date utilizata" width="30%" data={JSONdata.BdData} />
            </div>
        );
    }
}

class SideBar extends React.Component {
    render() {
        return (
            <div className="BarStyle SideBarStyle">
                <Text text="Configurarea traseului" marime="TextSubtitlu"/>
                <DropDown text="Punct plecare" width="90%" data={JSONdata.pointsData} />
                <DropDown text="Punct destinatie" width="90%" data={JSONdata.pointsData} />
                <ButonCalcul />
                <br />
                <br />
                <Text text="Filtre" marime="TextSubtitlu" />
                <CheckBox text="UnFiltru_1"/>
                <CheckBox text="UnFiltru_2"/>
            </div>
        );
    }
}

class DetailBar extends React.Component {
    render() {
        return (
            <div className="BarStyle DetailBarStyle">
                <Text text="Detalii traseu" marime="TextSubtitlu" />
            </div>
        );
    }
}

class Pagina extends React.Component {
    render() {
        return (
            <><SideBar /><DetailBar /><Meniu /></>
        );
    }
}

ReactDOM.render(<Pagina />, document.getElementById('unDiv'));