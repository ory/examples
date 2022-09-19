import { KRATOS_API_URL } from "../utils/config";
import { kratos } from "../utils/kratos";
import { SelfServiceRegistrationFlow } from "@ory/kratos-client";
import { NextPageContext } from "next";
import { InputHTMLAttributes } from "react";
import { FaGithub } from "react-icons/fa";
import { FaGoogle } from "react-icons/fa";
import { FaMicrosoft } from "react-icons/fa";
import Link from "next/dist/client/link";


const RegisterPage = ({
  flowData,
}: {
  flowData: SelfServiceRegistrationFlow;
}) => {
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

          <div className="xl:ml-20 xl:w-5/12 lg:w-5/12 md:w-8/12 mb-12 md:mb-0">
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
                  type="email"
                  id="traits.email"
                  name="traits.email"
                  required
                  placeholder="email"
                  className="form-control block w-full px-4 py-2 text-xl font-normal text-gray-700 bg-white bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
                />
              </div>
              <div className="mb-6">
                <input
                  type="text"
                  id="traits.name.first"
                  name="traits.name.first"
                  required
                  placeholder="first name"
                  className="form-control block w-full px-4 py-2 text-xl font-normal text-gray-700 bg-white bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
                />
              </div>
              <div className="mb-6">
                <input
                  type="text"
                  id="traits.name.last"
                  name="traits.name.last"
                  required
                  placeholder="last name"
                  className="form-control block w-full px-4 py-2 text-xl font-normal text-gray-700 bg-white bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
                />
              </div>
              <div className="mb-6">
                <input
                  name="password"
                  type="password"
                  id="password"
                  required
                  placeholder="password"
                  className="form-control block w-full px-4 py-2 text-xl font-normal text-gray-700 bg-white bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
                />
              </div>
              <div className="text-center lg:text-left">
                <button
                  type="submit"
                  name="method"
                  value="password"
                  className="inline-block px-7 py-3 bg-blue-600 text-white font-medium text-sm leading-snug uppercase rounded shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out"
                >
                  Register
                </button>
                <div className="flex items-center my-4 before:flex-1 before:border-t before:border-gray-300 before:mt-0.5 after:flex-1 after:border-t after:border-gray-300 after:mt-0.5">
                <p className="text-center font-semibold mx-4 mb-0">Or</p>
              </div>
                <div className="flex flex-row items-center justify-center lg:justify-start">
                <p className="text-lg mb-0 mr-4">Sign up with</p>
                <button
                  type="submit"
                  name="provider"
                  value="github"
                  data-mdb-ripple="true"
                  data-mdb-ripple-color="light"
                  className="inline-block p-3 bg-blue-600 text-white font-medium text-xs leading-tight uppercase rounded-full shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out mx-1"
                >
                  {/* <!-- Facebook --> */}
                  <FaGithub />
                </button>
                <button
                  type="submit"
                  name="provider"
                  value="google"
                  data-mdb-ripple="true"
                  data-mdb-ripple-color="light"
                  className="inline-block p-3 bg-blue-600 text-white font-medium text-xs leading-tight uppercase rounded-full shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out mx-1"
                >
                  {/* <!-- Facebook --> */}
                  <FaGoogle />
                </button>
                <button
                  type="submit"
                  name="provider"
                  value="microsoft"
                  data-mdb-ripple="true"
                  data-mdb-ripple-color="light"
                  className="inline-block p-3 bg-blue-600 text-white font-medium text-xs leading-tight uppercase rounded-full shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out mx-1"
                >
                  {/* <!-- Facebook --> */}
                  <FaMicrosoft />
                </button>
              </div>
             
              </div>
            </form>
          </div>
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
        destination: `${KRATOS_API_URL}/self-service/registration/browser`,
      },
    };
  }

  let flowData: SelfServiceRegistrationFlow | void;

  if (allCookies && flowId) {
    const data = await kratos
      .getSelfServiceRegistrationFlow(flowId.toString(), allCookies)
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

export default RegisterPage;
