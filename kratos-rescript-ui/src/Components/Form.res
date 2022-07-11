@react.component
let make = (~ui: Kratos.uiContainer, ~children: React.element=React.null) =>
  <form className="mt-8 space-y-6" action={ui.action} method={ui.method}>
    <div className="mt-8 space-y-6"> <DynamicInputList nodes={ui.nodes} /> </div>
    <div className="flex items-center justify-between">
      <div className="text-sm"> children </div>
    </div>
    <div />
  </form>
