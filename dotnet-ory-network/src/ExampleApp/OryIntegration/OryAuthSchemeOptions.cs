using Microsoft.AspNetCore.Authentication;

namespace OryIntegration;

public sealed class OryAuthSchemeOptions : AuthenticationSchemeOptions
{
    public string? BasePath { get; set; }
}
