import { SMTPClient } from "emailjs";
export default function handler(req, res) {
  const { email } = req.body;
  const client = new SMTPClient({
    user: process.env.mail,
    password: process.env.password,
    host: "smtp.gmail.com",
    ssl: true,
  });
  try {
    client.send({
      text: `Thank You For Contacting Us
      Feel free to mail us your concerns to
      vijeyash@gmail.com.`,
      from: process.env.mail,
      to: email,
      subject: "Response from vizual team",
    });
  } catch (e) {
    res.status(400).end(JSON.stringify({ message: "Error" }));
    return;
  }

  res.status(200).end(JSON.stringify({ message: "Sent email to you" }));
}
