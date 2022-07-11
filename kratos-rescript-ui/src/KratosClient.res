@val @scope(("process", "env")) @return(nullable) external basePath: option<string> = "KRATOS_API"

let opts: Kratos.options = {
  basePath: basePath->Belt.Option.getWithDefault(""),
  baseOptions: {
    withCredentials: true,
    timeout: None,
  },
}
let api = opts |> Kratos.makeConfiguration |> Kratos.makePublicAPI
