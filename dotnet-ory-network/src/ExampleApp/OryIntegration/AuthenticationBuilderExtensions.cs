using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;

namespace OryIntegration;

public static class AuthenticationBuilderExtensions {
    public static AuthenticationBuilder AddOry( this AuthenticationBuilder builder, Action<OryAuthSchemeOptions>? configureOptions = null ) {
        
        builder.AddScheme<OryAuthSchemeOptions, OryAuthHandler>(OryDefaults.AuthenticationScheme, configureOptions);

        return builder;
    }
}
