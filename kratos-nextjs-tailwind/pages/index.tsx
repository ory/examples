import { KRATOS_API_URL } from "../utils/config";
import { kratos } from "../utils/kratos";
import { SelfServiceLoginFlow } from "@ory/kratos-client";
import { NextPageContext } from "next";
import Link from "next/dist/client/link";
import { InputHTMLAttributes } from "react";
import { FaGithub } from "react-icons/fa";
import { FaGoogle } from "react-icons/fa";
import { FaMicrosoft } from "react-icons/fa";



const LoginPage = ({ flowData }: { flowData: SelfServiceLoginFlow }) => {
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
          <div className="xl:ml-20 xl:w-5/12 lg:w-5/12 md:w-8/12 mb-12 md:mb-0">
            {flowData && (
              <form method="POST" action={flowData.ui.action}>
                {/* This Adds a hidden input for CSRF Token  */}
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
                <div className="flex flex-row items-center justify-center lg:justify-start">
                  <p className="text-lg mb-0 mr-4">Sign in with</p>
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
                <div className="flex items-center my-4 before:flex-1 before:border-t before:border-gray-300 before:mt-0.5 after:flex-1 after:border-t after:border-gray-300 after:mt-0.5">
                <p className="text-center font-semibold mx-4 mb-0">Or</p>
              </div>
              <div className="mb-6">
                <input
                  id="password_identifier"
                  type="text"
                  name="password_identifier"
                  placeholder="email"
                  className="form-control block w-full px-4 py-2 text-xl font-normal text-gray-700 bg-white bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
                />
                </div>
                <div className="mb-6">
                <input name="password" type="password" placeholder="password" id="password" className="form-control block w-full px-4 py-2 text-xl font-normal text-gray-700 bg-white bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none" />
                </div>
                <div className="flex justify-between items-center mb-6">
                <div className="form-group form-check">
                  <input
                    type="checkbox"
                    className="form-check-input appearance-none h-4 w-4 border border-gray-300 rounded-sm bg-white checked:bg-blue-600 checked:border-blue-600 focus:outline-none transition duration-200 mt-1 align-top bg-no-repeat bg-center bg-contain float-left mr-2 cursor-pointer"
                    id="exampleCheck2"
                  />
                  <label
                    className="form-check-label inline-block text-gray-800"
                    htmlFor="exampleCheck2"
                  >
                    Remember me
                  </label>
                </div>
                <Link href="/recovery" className="text-gray-800">
                  Forgot password?
                </Link>
              </div>
              <div className="text-center lg:text-left">
                <button
                  type="submit"
                  name="method"
                  value="password"
                  className="inline-block px-7 py-3 bg-blue-600 text-white font-medium text-sm leading-snug uppercase rounded shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out"
                >
                  Login
                </button>
                <div className="flex justify-around items-center">
                <p className="text-sm font-semibold mt-2 mr-4 pt-1 mb-0">
                  Don't have an account?
                  
                </p>
                <Link
                    href="/register"
                    className="text-red-600 inline-block ml-4 hover:text-red-700 focus:text-red-700 transition duration-200 ease-in-out"
                  >
                    Register
                  </Link>
                </div>
              </div>
              </form>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export async function getServerSideProps(context: NextPageContext) {
  const allCookies = context.req.headers.cookie;
  const flowId = context.query.flow;

  const id = context.query.id;

  if (!flowId) {
    return {
      redirect: {
        destination: `${KRATOS_API_URL}/self-service/login/browser`,
      },
    };
  }

  let flowData: SelfServiceLoginFlow | void;

  if (allCookies && flowId) {
    const data = await kratos
      .getSelfServiceLoginFlow(flowId.toString(), allCookies)
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

export default LoginPage;
