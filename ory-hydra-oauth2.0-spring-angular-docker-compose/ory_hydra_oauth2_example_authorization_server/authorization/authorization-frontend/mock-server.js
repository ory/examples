const jsonServer = require('json-server');
const server = jsonServer.create();
const router = jsonServer.router('mock-data.json');
const middlewares = jsonServer.defaults();

server.use(middlewares);

server.post('/login', (req, res) => {
  res.status(200).jsonp({
    redirect_to: "/consent"
  })
})

server.get('/somesome', (req, res) => {
  res.status(200).jsonp({
    "test": "aaaaaaaaaaaaaaaaaaaaaaaa!"
  })
})

server.get('/consent/scopes', (req, res) => {
  res.status(200).jsonp(["read", "write"])
})

server.get('/consent/subject', (req, res) => {
  res.status(200).jsonp('So Good Man')
})

server.get('/consent/client-name', (req, res) => {
  res.status(200).jsonp('Some App')
})

server.put('/consent', (req, res) => {
  res.status(200).jsonp({
    redirect_to: "some_redirect"
  });
})

server.delete('/consent/cancel', (req, res) => {
  res.status(200).jsonp({
    redirect_to: "some_redirect"
  });
})

server.put('/logout', (req, res) => {
  res.status(200).jsonp({
    redirect_to: "/logout/sssaaa"
  });
})

server.post('/registration', (req, res) => {
  res.status(200).jsonp({});
})



server.use(router);

server.listen(3000, () => {
  console.log('JSON Server is running');
});
