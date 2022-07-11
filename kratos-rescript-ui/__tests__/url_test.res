open Jest

describe("parseSearchParams", () => {
    open Expect;

    let url: RescriptReactRouter.url = {
      path: list{"login"},
      hash: "",
      search: "flow=foobar",
    }

    test("returns search params as key value pairs", () => {
      let test = url

      let params = Url.parseSearchParams(test)

      expect(params->Belt.Map.get("flow")) |> toBe(Some("foobar"))
    })

    test("returns nothing is key is not paired with value", () => {
      let test = {
        ...url,
        search: "flow",
      }

      let params = Url.parseSearchParams(test)

      expect(params->Belt.Map.isEmpty) |> toBe(true)
    })

    test("returns empty map if no search params exist", () => {
      let test = {
        ...url,
        path: list{""},
        search: "",
      }

      let params = Url.parseSearchParams(test)

      expect(params->Belt.Map.isEmpty) |> toBe(true)
    })

    test("returns multiple search params as key value pairs", () => {
      let test = {
        ...url,
        search: "search=coffee&referrer=shop",
      }
      let expected = Belt.Map.make(~id=module(Url.SearchKeyCmp))
      -> Belt.Map.set("search", "coffee")
      -> Belt.Map.set("referrer", "shop")

      let params = Url.parseSearchParams(test)

      params |> expect |> toEqual(expected)
    })
})

