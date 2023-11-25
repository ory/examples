import { getDefaultAuthority } from "@grpc/grpc-js/build/src/resolver";

// const grpc = require("@grpc/grpc-js");
// const {
//   relationTuples,
//   write,
//   writeService,
//   check,
//   checkService,
// } = require("@ory/keto-grpc-client");

const getData = async (request) => {
    console.log(request)
  return response.status(200).json({ message: request.method });
};

export default async function handler(req, res) {
  let result = {};
  if (req.method === "POST") {
    result = await getData(request.body)
    return
  }
}
