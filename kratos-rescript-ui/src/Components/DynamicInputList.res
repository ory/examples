@react.component
let make = (~nodes: array<Kratos.uiNode>) =>
  React.array(
    nodes->Js.Array2.mapi((node, i) =>
      switch node->Kratos.parseAttrs {
      | Kratos.UiNodeInputAttributes(attrs) =>
        <DynamicInput
          key={i->Belt.Int.toString}
          name={attrs.name}
          \"type"={attrs.\"type"}
          label=?node.meta.label
          value=?attrs.value
          messages=?{node.messages->Js.Nullable.toOption}
          required={attrs.required->Belt.Option.getWithDefault(false)}
        />
      | _ => React.null
      }
    ),
  )
