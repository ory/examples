%%raw("import './styles/main.css'")

switch ReactDOM.querySelector("#root") {
| None => ()
| Some(element) => ReactDOM.render(<App />, element)
}
