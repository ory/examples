import type { NextPage } from 'next'
import Link from 'next/link'

export const config = {
  unstable_runtimeJS: false // disable client-side javascript (in production)
}

const Home: NextPage = () => {
  return (
    <>
      <div>Pages:</div>
      <ul>
        <li><Link href="/sign-in"><a>Sign-in</a></Link></li>
        <li><Link href="/sign-up"><a>Sign-up</a></Link></li>
        <li><Link href="/consent"><a>Consent</a></Link></li>
        <li><Link href="/sign-out"><a>Sign-out</a></Link></li>
      </ul>
    </>
  )
}

export default Home
