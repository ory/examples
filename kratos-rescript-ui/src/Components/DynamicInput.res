module NonStandardProps = {
  @react.component
  let make = (~props, ~children) => React.cloneElement(children, props)
}

let defaultClasses = "appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
let errorClasses = "border-red-500 appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
let submitClasses = "group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"

module InputField = {
  @react.component
  let make = (
    ~name,
    ~\"type",
    ~required,
    ~value: option<Kratos.uiNodeInputAttributesValue>,
    ~placeholder=?,
    ~hasError=false,
    ~buttonText=?,
  ) =>
    switch \"type" {
    | "submit" =>
      <NonStandardProps props={"data-testid": \"type"}>
        <button
          className={submitClasses}
          name={name}
          value={value->Belt.Option.getWithDefault("")}
          placeholder={placeholder->Belt.Option.getWithDefault("")}
          type_={\"type"}
          required={required}>
          {React.string(buttonText->Belt.Option.getWithDefault("Submit"))}
        </button>
      </NonStandardProps>
    | _ => <>
        <NonStandardProps props={"data-testid": name}>
          <input
            className={hasError ? errorClasses : defaultClasses}
            name={name}
            defaultValue={value->Belt.Option.getWithDefault("")}
            placeholder={placeholder->Belt.Option.getWithDefault("")}
            type_={\"type"}
            required={required}
          />
        </NonStandardProps>
      </>
    }
}

module Messages = {
  @react.component
  let make = (~messages: option<array<Kratos.uiText>>=?) =>
    switch messages {
    | Some(m) =>
      React.array(
        m->Js.Array2.map(msg =>
          <span
            key={msg.id->Belt.Int.toString}
            className="flex items-center font-medium tracking-wide text-red-500 text-xs mt-1 ml-1">
            {React.string(msg.text)}
          </span>
        ),
      )
    | None => React.null
    }
}

let hasErrorMessage = (messages: option<array<Kratos.uiText>>) =>
  switch messages {
  | Some(m) => m->Js.Array2.find(m => m.\"type" === "error")->Belt.Option.isSome
  | None => false
  }

@react.component
let make = (
  ~name,
  ~\"type",
  ~label: option<Kratos.uiText>=?,
  ~value: option<Kratos.uiNodeInputAttributesValue>=?,
  ~required=false,
  ~messages: option<array<Kratos.uiText>>=?,
) =>
  switch label {
  | Some(l) => <>
      <NonStandardProps props={"data-testid": "label"}>
        <label key={Js.Int.toString(l.id)} className="sr-only"> {React.string(l.text)} </label>
      </NonStandardProps>
      <InputField
        name={name}
        \"type"={\"type"}
        placeholder={l.text}
        value={value}
        required={required}
        hasError={messages->hasErrorMessage}
        buttonText={l.text}
      />
      <Messages ?messages />
    </>
  | None => <>
      <InputField name={name} \"type"={\"type"} value={value} required={required} />
      <Messages ?messages />
    </>
  }
