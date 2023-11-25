import type { NextPage } from "next";
import Head from "next/head";
import Link from "next/link";
import Image from "next/image";
import { Session, Identity } from "@ory/client";
import { edgeConfig } from "@ory/integrations/next";
import { useRouter } from "next/router";
import { ChangeEvent, useEffect, useState } from "react";
import { kratos } from "../utils/kratos";
import Navbar from "../components/Navbar";
import CreateRelationtuple from "../components/CreateRelationtuple";
import Checkrelation from "../components/Checkrelation";
import Deleterelationtuple from "../components/Deleterelationtuple";

import axios from "axios";

const getUserName = (identity: Identity) => {
  return identity.traits.email || identity.traits.username;
};

const Home: NextPage = (): any => {
  const [email, setEmail] = useState("");

  const [session, setSession] = useState<Session | undefined>();
  const [logoutUrl, setLogoutUrl] = useState<string>("");
  const [allowed, setAllowed] = useState<boolean>(false);
  const router = useRouter();
  const SendMail = async (e) => {
    axios
      .post("http://localhost:3000/api/email", { email })
      .then((res) => {
        alert(res);
        setEmail("");
      })
      .catch((e) => console.log(e));
  };
  const check = async (session: Session) => {
    const data = {
      object: "homepage",
      relation: "view",
      subject: session.identity.traits.email,
    };
    try {
      //  const headers ={
      //     "Access-Control-Allow-Origin": "http://127.0.0.1:4455"
      //   }
      const res = await axios.post("http://localhost:4000/checkrelation", data);
      // console.log(res.data);
      setAllowed(res.data.allowed);
      console.log(res.data.allowed);
    } catch (e) {
      console.log(e);
      return <h1>you are not authorized</h1>;
    }
  };

  useEffect(() => {
    if (session) {
      return;
    }

    kratos
      .toSession()
      .then(({ data: session }) => {
        setSession(session);
        console.log(session.identity.traits.email);
         check(session);
        // console.log(allowed)
        return kratos
          .createSelfServiceLogoutFlowUrlForBrowsers()
          .then(({ data }) => {
            setLogoutUrl(data.logout_url);
            // console.log(data.logout_url);
          });
      })
      .catch((err) => {
        // An error occurred while loading the session or fetching
        // the logout URL. Let's show that!
        router.push(edgeConfig.basePath + "/self-service/login/browser");
      });
  }, [session, router]);
  if (!session) {
    // Still loading
    return null;
  }
  if (allowed) {
    return (
      <div className="bg-gray-300">
        <Head>
          <title>ADMIN PAGE</title>
        </Head>
        <Navbar logout={logoutUrl} />
        <CreateRelationtuple />
        <Checkrelation />
        <Deleterelationtuple />
      </div>
    );
  }
  if (!allowed) {
    return (
      <div className="bg-gray-500 w-full min-h-screen flex flex-col justify-center items-center">
        <Head>denied</Head>
        <h1 className="text-5xl font-serif">
          You are not authorized to view this page
        </h1>
        <h1 className="text-3xl mt-6 text-yellow-500 font-extralight">
          Provide your email we will contact you
        </h1>
        <form className="mt-10">
          <input
            type="email"
            placeholder="Enter Mail"
            required
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className=" p-3 rounded-l-lg"
          ></input>
          <button
            className="p-3 bg-gray-900 text-white rounded-r-lg"
            onClick={SendMail}
          >
            Send
          </button>
        </form>{" "}
      </div>
    );
  }
};

export default Home;
