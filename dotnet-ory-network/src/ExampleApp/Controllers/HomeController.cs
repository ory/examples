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
    private readonly IFrontendApiAsync _api;

    public HomeController(ILogger<HomeController> logger)
    {
        _logger = logger;
        _api = new FrontendApi(new Configuration()
        {
            BasePath = "http://localhost:4000"
        });
    }

    public IActionResult Index() => View();

    public IActionResult Privacy() => View();

    public async Task<IActionResult> Login()
    {
        var flow = await _api.CreateBrowserLoginFlowAsync();
        return Redirect( flow.RequestUrl );
    }

    public async Task<IActionResult> Logout()
    {
        var flow = await _api.CreateBrowserLogoutFlowAsync(Request.Headers["cookie"]);
        return Redirect( flow.LogoutUrl );
    }

    [Authorize]
    public IActionResult IdentityInfo()
        => View(new IdentityInfoModel { Id = HttpContext.User.Claims.SingleOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value ?? Guid.Empty.ToString() });

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
        => View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
}
