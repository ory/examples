import { KRATOS_API_URL } from "../utils/config";
import { kratos } from "../utils/kratos";
import { SelfServiceSettingsFlow } from "@ory/kratos-client";
import { NextPageContext } from "next";
import Link from "next/dist/client/link";
import { InputHTMLAttributes, useEffect, useState } from "react";

const SettingsPage = ({ flowData }: { flowData: SelfServiceSettingsFlow }) => {
  const [firstName, setFirstName] = useState<string>("");
  const [lastName, setLastName] = useState<string>("");
  const [email, setEmail] = useState<string>("");

  // This useEffect is to add the values in their respective fields
  useEffect(() => {
    setEmail(flowData.identity.recovery_addresses[0].value);
    setFirstName(flowData.identity.traits.name.first);
    setLastName(flowData.identity.traits.name.last);
  }, [flowData]);

  console.log("flowData", flowData);

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
                <div className="mb-6">
                  <label>
                    <input
                      name="traits.email"
                      type="email"
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      placeholder="E-Mail"
                      className="form-control block w-full px-4 py-2 text-xl font-normal text-gray-700 bg-white bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
                    />
                  </label>
                </div>
                <div className="mb-6">
                  <label>
                    <input
                      name="traits.name.first"
                      type="text"
                      value={firstName}
                      onChange={(e) => setFirstName(e.target.value)}
                      placeholder="First Name"
                      className="form-control block w-full px-4 py-2 text-xl font-normal text-gray-700 bg-white bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
                    />
                  </label>
                </div>
                <div className="mb-6">
                  <label>
                    <input
                      name="traits.name.last"
                      type="text"
                      value={lastName}
                      onChange={(e) => setLastName(e.target.value)}
                      placeholder="Last Name"
                      className="form-control block w-full px-4 py-2 text-xl font-normal text-gray-700 bg-white bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
                    />
                  </label>
                </div>
                {/* This button will update the email, first and last name  */}
                <button
                  name="method"
                  type="submit"
                  value="profile"
                  className="inline-block px-7 py-3 bg-blue-600 text-white font-medium text-sm leading-snug uppercase rounded shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out mb-6"
                >
                  Update Profile
                </button>
                <div className="flex items-center my-4 before:flex-1 before:border-t before:border-gray-300 before:mt-0.5 after:flex-1 after:border-t after:border-gray-300 after:mt-0.5">
                  <p className="text-center font-semibold mx-4 mb-0">Or</p>
                </div>
                <div className="mb-6">
                  <label>
                    <input
                      name="password"
                      type="password"
                      placeholder="new Password"
                      className="form-control block w-full px-4 py-2 text-xl font-normal text-gray-700 bg-white bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
                    />
                  </label>
                </div>
                {/* This button is used to upadate the password  */}
                <button name="method" type="submit" value="password"
                className="inline-block px-7 py-3 bg-blue-600 text-white font-medium text-sm leading-snug uppercase rounded shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out mb-6">
                  Update Password
                </button>
              </form>
            )}
            <Link href="/welcome" >
             {`<- Back to Homepage`}
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
};

// Server side props for getting the Cookies and flow id etc
export async function getServerSideProps(context: NextPageContext) {
  const allCookies = context.req.headers.cookie;
  const flowId = context.query.flow;

  if (!flowId) {
    return {
      redirect: {
        destination: `${KRATOS_API_URL}/self-service/settings/browser`,
        // This url needs to change according to the work you are intending it to do
      },
    };
  }

  let flowData: SelfServiceSettingsFlow | void;

  if (allCookies) {
    const data = await kratos
      .getSelfServiceSettingsFlow(flowId.toString(), undefined, allCookies)
      .then(({ data: flow }) => {
        return flow;
      })
      .catch((err) => {
        console.log(err);
      });
    flowData = data;
  }

  return {
    props: {
      flowData: flowData ? flowData : null,
    },
  };
}

export default SettingsPage;
