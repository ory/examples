using Microsoft.AspNetCore.Authorization;
using Ory.Client.Api;
using OryIntegration;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

var oryBasePath = builder.Configuration.GetValue<string>("ORY_BASEPATH") ?? "http://localhost:4000";

builder.Services.AddSingleton<IFrontendApiAsync>(_ => new FrontendApi(oryBasePath));

builder.Services.AddAuthentication(opt => {
    opt.DefaultAuthenticateScheme = OryDefaults.AuthenticationScheme;
}).AddOry(o => {
    o.BasePath = oryBasePath;
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    // app.UseHsts();
}

app.UseStatusCodePages();

// app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
