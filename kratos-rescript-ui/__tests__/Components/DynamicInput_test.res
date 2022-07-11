open Jest
open JestDom

describe("DynamicInputComponent", () => {
    open ReactTestingLibrary

    let createComponent = () => 
      <DynamicInput
        name={"password"}
        \"type"={"password"}
        required={true} />

    let createComponentWithLabel = () => {
      let label: Kratos.uiText = {
        context: None,
        id: 10,
        text: "Cool Label",
        \"type": "info",
      }
      <DynamicInput
      name={"password"}
      \"type"={"password"}
      label={label}
      required={true} />
    }

    test("when label is provided then matches expected", () =>
      createComponentWithLabel()
        -> render
        |> container
        |> Expect.expect
        |> Expect.toMatchSnapshot
    )

    test("when no label is provided then matches snapshot", () =>
      createComponent()
        -> render
        |> container
        |> Expect.expect
        |> Expect.toMatchSnapshot
    )

    test("when label is provided then has visible label", () =>
      createComponentWithLabel()
        |> render
        |> getByTestId(~matcher=#Str("label"))
        |> expect
        |> toHaveTextContent(#Str("Cool Label"))
    )
})
