import { kratos } from "../utils/kratos";
import { NextPageContext } from "next";
import dynamic from "next/dynamic";
import Link from "next/link";
import { useEffect, useState } from "react";

const JsonView = dynamic(import("react-json-view"), { ssr: false });

const getUserName = (data) => {
  return data.identity.traits.username || data.identity.traits.email;
};

const DashboardPage = ({ flowData }: { flowData: string }) => {
  const [userIdentity, setUserIdentity] = useState();
  const [errorData, setErrorData] = useState();
  const [userName, setUserName] = useState("");

  useEffect(() => {
    // Get the info on user who is using the session
    fetch("http://127.0.0.1:4433/sessions/whoami", { credentials: "include" })
      .then((response) => response.json())
      .then((data) => {
        if (data.error) {
          setErrorData(data);
        } else if (data.active) {
          setUserIdentity(data);
          setUserName(getUserName(data));
        }
      }).catch(()=>{
        console.log("error")
      }
      )
  }, []);

  if (typeof window === "undefined") {
    return null;
  }

  if (errorData || !userIdentity) {
    return (
      <div>
        <Link href="/">Login</Link>
        <br />
        <Link href="/register">Register</Link>

        <JsonView
          src={errorData}
          style={{ fontSize: "20px", marginTop: "30px" }}
          enableClipboard={false}
          displayDataTypes={false}
        />
      </div>
    );
  }
  return (
    <div>

      {userIdentity && (
        <>
          <Link href={flowData}>LOGOUT</Link>
          <br />
          <Link href="/settings">Settings</Link> 
<h1>{`welcome ${userName} to ory kratos custom welcome page` }</h1>
           <JsonView
            src={userIdentity}
            style={{ fontSize: "20px", marginTop: "30px" }}
            enableClipboard={false}
            displayDataTypes={false}
          />
        </>
      )}
    </div>
  );
};

export async function getServerSideProps(context: NextPageContext) {
  const allCookies = context.req.headers.cookie;

  let flowData: string | void;

  if (allCookies) {
    const data = await kratos
      .createSelfServiceLogoutFlowUrlForBrowsers(allCookies)
      .then(({ data }) => {
        return data.logout_url;
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

export default DashboardPage;

