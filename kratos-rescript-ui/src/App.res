@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()

  switch url.path {
  | list{} => <Dashboard />
  | list{"login"} => <Login />
  | list{"register"} => <Register />
  | list{"recovery"} => <Recovery />
  | _ => <NotFound />
  }
}
