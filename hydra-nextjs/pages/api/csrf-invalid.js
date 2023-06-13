export default function handler(req, res) {
  res.status(403).send('invalid csrf token');
}
