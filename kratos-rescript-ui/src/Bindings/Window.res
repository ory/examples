module Unsafe = {
  @set external setHref: (Dom.location, string) => unit = "href"

  @get external href: Dom.location => string = "href"
}

type errors = ErrorObjectNotFound(string)

let redirect = (url: string) => {
  switch %external(location) {
  | Some(loc) => {
      // Side effect: browser window should redirect.
      loc->Unsafe.setHref(url)
      Ok()
    }
  | None => Error(ErrorObjectNotFound("Location object not found in global namespac."))
  }
}
