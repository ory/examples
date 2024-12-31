import { ErrorResponseCode } from "./error-response-code.model";

export class ErrorOnPageModel{
  error: string;
  errorDescription: string;
  reauthenticationLocation: string;

  constructor(error: string, errorDescription: string, reauthenticationLocation: string){
    this.error = error;
    this.errorDescription = errorDescription;
    this.reauthenticationLocation = reauthenticationLocation;
  }


  public static getErrorResponseCodeRus(errorResponseCodeStr: string): string {
    let errorResponseCode: ErrorResponseCode = errorResponseCodeStr as ErrorResponseCode;
    switch (errorResponseCode) {
      case ErrorResponseCode.InvalidRequest:
        return "Ошибка параметров запроса (invalid_request)";
      case ErrorResponseCode.UnauthorizedClient:
        return "Клиент не может быть авторизован используя данный метод (unauthorized_client)";
      case ErrorResponseCode.AccessDenied:
        return "Владелец ресурса или сервер авторизации отклонили запрос (access_denied)";
      case ErrorResponseCode.UnsupportedResponseType:
        return "Сервер авторизации не поддерживает получение кода авторизации с помощью этого метода (unsupported_response_type)";
      case ErrorResponseCode.InvalidScope:
        return "Запрошенные scopes недопустимы, неизвестны или имеют неправильную форму (invalid_scope)";
      case ErrorResponseCode.ServerError:
        return "Сервер авторизации столкнулся с неожиданным условием, которое помешало ему выполнить запрос (server_error)";
      case ErrorResponseCode.TemporarilyUnavailable:
        return "Сервер авторизации в настоящее время не может обработать запрос из-за временной перегрузки или технического обслуживания сервера (temporarily_unavailable)";
      case ErrorResponseCode.InsufficientScope:
        return "Запрос требует более высоких привилегий, чем те, которые предоставляются токеном доступа (insufficient_scope)";
      case ErrorResponseCode.InvalidClient:
        return "Ошибка проверки подлинности клиента (например, неизвестный клиент, проверка подлинности клиента не включена или неподдерживаемый метод проверки подлинности) (invalid_client)";
      case ErrorResponseCode.InvalidGrant:
        return "Предоставленное разрешение на авторизацию (например, код авторизации, учетные данные владельца ресурса) или токен обновления недействительны, истек срок действия, отозваны, не соответствуют URI перенаправления, использованному в запросе на авторизацию, или были выданы другому клиенту. (invalid_grant)";
      case ErrorResponseCode.InvalidRedirectUri:
        return "Значение одного или нескольких URI перенаправления недопустимо (invalid_redirect_uri)";
      case ErrorResponseCode.InvalidToken:
        return "Предоставленный маркер доступа истек, отозван, имеет неправильную форму или недействителен по другим причинам (invalid_token)";
      case ErrorResponseCode.UnsupportedGrantType:
        return "Тип предоставления авторизации не поддерживается сервером авторизации (unsupported_grant_type)";
      case ErrorResponseCode.UnsupportedTokenType:
        return "Сервер авторизации не поддерживает отзыв представленного типа токена (unsupported_token_type)";
      default:
        return `Ошибка (${errorResponseCodeStr})`;
    }
  }

}