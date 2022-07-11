@react.component
let make = (~messages: array<Kratos.uiText>) => {
  React.array(
    messages->Js.Array2.map(m => {
      let classes = switch m.\"type" {
      // The expected states here don't seem to be documented. For now
      // it's either an error or info.
      // https://github.com/ory/kratos/issues/691#issuecomment-687787429
      | "error" => "flex justify-center items-center m-1 font-small py-1 px-2 bg-white rounded-md text-red-700 bg-red-100 border border-red-300"
      | _ => "flex justify-center items-center m-1 font-small py-1 px-2 bg-white rounded-md text-green-700 bg-green-100 border border-green-300"
      }
      <p className={classes} key={m.id->Belt.Int.toString}> {React.string(m.text)} </p>
    }),
  )
}
