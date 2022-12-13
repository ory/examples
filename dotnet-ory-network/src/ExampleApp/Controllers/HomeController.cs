using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using ExampleApp.Models;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;
using Ory.Client.Api;
using Ory.Client.Client;

namespace ExampleApp.Controllers;

public class HomeController : Controller
{
    private readonly ILogger<HomeController> _logger;
    
    private readonly IFrontendApiAsync _ory;

    public HomeController(ILogger<HomeController> logger, IFrontendApiAsync ory)
    {
        _logger = logger;
        _ory = ory;
    }

    public IActionResult Index() => View();

    public IActionResult Privacy() => View();

    public async Task<IActionResult> Login()
    {
        var flow = await _ory.CreateBrowserLoginFlowAsync();
        return Redirect( flow.RequestUrl );
    }

    public async Task<IActionResult> Logout()
    {
        var flow = await _ory.CreateBrowserLogoutFlowAsync(Request.Headers["cookie"]);
        return Redirect( flow.LogoutUrl );
    }

    [Authorize]
    public IActionResult IdentityInfo()
        => View(new IdentityInfoModel { Id = HttpContext.User.Claims.SingleOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value ?? Guid.Empty.ToString() });

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
        => View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
}
