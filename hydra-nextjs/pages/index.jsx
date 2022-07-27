import Link from 'next/link';
import React from 'react';

export const config = {
  unstable_runtimeJS: false // disable client-side javascript (in production)
};

export default function Home() {
  return (
    <>
      <div>Pages:</div>
      <ul>
        <li><Link href="/auth/sign-in"><a>Sign-in</a></Link></li>
        <li><Link href="/auth/sign-up"><a>Sign-up</a></Link></li>
        <li><Link href="/auth/sign-out"><a>Sign-out</a></Link></li>
      </ul>
    </>
  );
}
