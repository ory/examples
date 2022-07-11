type t

@new @module("url-parse")
external new: (string, string, bool) => t = "default"

@get
external queryParams: t => Obj.t = "query"
