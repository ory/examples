import { SelfServiceError } from "@ory/kratos-client";
import { NextPageContext } from "next";
import dynamic from "next/dynamic";
import { KRATOS_API_URL } from "../utils/config";
import { kratos } from "../utils/kratos";

const JsonView = dynamic(import("react-json-view"), { ssr: false });
const ErrorPage = ({ flowData }: { flowData: SelfServiceError }) => {
  console.log(flowData);
  return (
    <div>
      <h1>Error component</h1>
      {flowData && typeof window !== "undefined" && (
        <JsonView
          src={flowData}
          style={{ fontSize: "20px", marginTop: "30px" }}
          enableClipboard={false}
          displayDataTypes={false}
        />
      )}
    </div>
  );
};

export async function getServerSideProps(context: NextPageContext) {
  const id = context.query.id;

  if (!id) {
    return {
      redirect: {
        destination: `${KRATOS_API_URL}/self-service/login/browser`,
      },
    };
  }

  let flowData: SelfServiceError | void;

  const data = await kratos
    .getSelfServiceError(id.toString())
    .then(({ data: flow }) => {
      return flow;
    })
    .catch((err) => {
      console.log("err", err);
    });
  flowData = data;

  return {
    props: {
      flowData: flowData ? flowData : null,
    },
  };
}

export default ErrorPage;