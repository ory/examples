@react.component
let make = () => {
  let (methods, setMethods) = React.useState(_ => None)

  React.useEffect0(() => {
    KratosClient.api
    ->Kratos.initializeSelfServiceRecoveryFlowForBrowsers(
      ~returnTo=None,
      ~options=Url.paramsFromSourceURL())
    ->Promise.Js.toResult
    ->Promise.get(res => {
      switch res {
      | Ok(payload) => setMethods(_prev => Some(payload.data.ui))
      | Error(payload) =>
        switch payload.response.status {
        | _ => RescriptReactRouter.push("/login")
        }
      }
    })

    None
  })
  let loginForms = (container: Kratos.uiContainer) =>
    <div
      className="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-md w-full space-y-8">
        <div>
          <h2 className="mt-6 text-center text-3xl font-extrabold text-gray-900">
            {React.string(Messages.Recovery.title)}
          </h2>
        </div>
        {switch container.messages {
        | Some(m) => <ActionMessages messages={m} />
        | None => React.null
        }}
        <Form ui={container} />
      </div>
    </div>

  <div>
    {switch methods {
    | Some(m) => loginForms(m)
    | None => React.null
    }}
  </div>
}
