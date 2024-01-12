export const enum ErrorResponseCode {

    //   invalid_request
    //   The request is missing a required parameter, includes an
    //   invalid parameter value, includes a parameter more than
    //   once, or is otherwise malformed.
    InvalidRequest = "invalid_request",
  
    // unauthorized_client
    //   The client is not authorized to request an authorization
    //   code using this method.
    UnauthorizedClient = "unauthorized_client",
  
    // access_denied
    //   The resource owner or authorization server denied the
    //   request.
    AccessDenied = "access_denied",
  
    // unsupported_response_type
    //   The authorization server does not support obtaining an
    //   authorization code using this method.
    UnsupportedResponseType = "unsupported_response_type",
  
    // invalid_scope
    //   The requested scope is invalid, unknown, or malformed.
    InvalidScope = "invalid_scope",
  
    // server_error
    //   The authorization server encountered an unexpected
    //   condition that prevented it from fulfilling the request.
    //   (This error code is needed because a 500 Internal Server
    //   Error HTTP status code cannot be returned to the client
    //   via an HTTP redirect.)
    ServerError = "server_error",
  
    // temporarily_unavailable
    //   The authorization server is currently unable to handle
    //   the request due to a temporary overloading or maintenance
    //   of the server.  (This error code is needed because a 503
    //   Service Unavailable HTTP status code cannot be returned
    //   to the client via an HTTP redirect.)
    TemporarilyUnavailable = "temporarily_unavailable",
    // insufficient_scope -
    // The request requires higher privileges than provided by the access token.
    InsufficientScope = "insufficient_scope",
    // invalid_client - Client authentication failed (e.g., unknown client, no client authentication included, or unsupported authentication method)
    InvalidClient = "invalid_client",
    // invalid_grant - The provided authorization grant (e.g., authorization code, resource owner credentials) or refresh token is invalid, expired,
    // revoked, does not match the redirection URI used in the authorization request, or was issued to another client.
    InvalidGrant = "invalid_grant",
    // invalid_redirect_uri - The value of one or more redirection URIs is invalid.
    InvalidRedirectUri = "invalid_redirect_uri",
    // invalid_token - The access token provided is expired, revoked, malformed, or invalid for other reasons
    InvalidToken = "invalid_token",
    //unsupported_grant_type - The authorization grant type is not supported by the authorization server.
    UnsupportedGrantType = "unsupported_grant_type",
    // unsupported_token_type - The authorization server does not support the revocation of the presented token type
    UnsupportedTokenType = "unsupported_token_type"
  
  
  }