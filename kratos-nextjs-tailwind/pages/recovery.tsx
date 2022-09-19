import { KRATOS_API_URL } from "../utils/config";
import { kratos } from "../utils/kratos";
import { SelfServiceRecoveryFlow } from "@ory/kratos-client";
import { NextPageContext } from "next";
import { InputHTMLAttributes } from "react";
import Link from "next/link";

const RecoveryPage = ({ flowData }: { flowData: SelfServiceRecoveryFlow }) => {
  console.log(flowData);
  return (
    <div className="h-screen bg-rose-50">
      <div className="px-6 h-full text-gray-800">
        <div className="flex xl:justify-center lg:justify-between justify-center items-center flex-wrap h-full g-6">
          <div className="grow-0 shrink-1 md:shrink-0 basis-auto xl:w-6/12 lg:w-6/12 md:w-9/12 mb-12 md:mb-0">
            <img
              src="https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-login-form/draw2.webp"
              className="w-full"
              alt="Sample image"
            />
          </div>

          {flowData && (
            <form method="POST" action={flowData.ui.action}>
              {flowData.ui.nodes
                .filter((node) => node.group === "default")
                .map((node) => {
                  return (
                    <input
                      {...(node.attributes as InputHTMLAttributes<HTMLInputElement>)}
                      key="csrf_token"
                    />
                  );
                })}
              <div className="mb-6">
                <input
                  name="email"
                  type="text"
                  id="email"
                  required
                  placeholder="recovery email"
                  className="form-control block w-full px-4 py-2 text-xl font-normal text-gray-700 bg-white bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
                />
              </div>
              <div className="text-center lg:text-left">

              <button type="submit" name="method" value="link" className="inline-block px-7 py-3 bg-blue-600 text-white font-medium text-sm leading-snug uppercase rounded shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out mb-6">
                Recover
              </button>
              </div>
              <Link href="/" className="text-gray-800 mt-10">
                  Back To Login
                </Link>
            </form>
          )}
        </div>
      </div>
    </div>
  );
};

export async function getServerSideProps(context: NextPageContext) {
  const allCookies = context.req.headers.cookie;
  const flowId = context.query.flow;

  if (!flowId) {
    return {
      redirect: {
        destination: `${KRATOS_API_URL}/self-service/recovery/browser`,
      },
    };
  }

  let flowData: SelfServiceRecoveryFlow | void;

  if (allCookies && flowId) {
    const data = await kratos
      .getSelfServiceRecoveryFlow(flowId.toString(), allCookies)
      .then(({ data: flow }) => {
        return flow;
      })
      .catch((err) => {
        console.log("err", err);
      });
    flowData = data;
  }

  return {
    props: {
      flowData: flowData ? flowData : null,
    },
  };
}

export default RecoveryPage;
