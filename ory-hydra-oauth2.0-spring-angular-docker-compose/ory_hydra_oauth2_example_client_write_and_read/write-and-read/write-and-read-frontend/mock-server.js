const jsonServer = require('json-server');
const server = jsonServer.create();
const router = jsonServer.router('mock-data.json');
const middlewares = jsonServer.defaults();

server.use(middlewares);

server.get('/logged-in', (req, res) => {
  res.status(200).jsonp({
    redirect_to: "/somesome"
  })
})

server.get('/somesome', (req, res) => {
  res.status(200).jsonp({
    "test": "aaaaaaaaaaaaaaaaaaaaaaaa!"
  })
})

server.put('/change', (req, res) => {
  res.status(200).jsonp({})
})

server.use(router);

server.listen(3000, () => {
  console.log('JSON Server is running');
});
