/**
 * @description This is the URL where Kratos server is running
 */
export const KRATOS_API_URL =
  process.env.NEXT_PUBLIC_API_URL.length > 0
    ? process.env.NEXT_PUBLIC_API_URL
    : "http://127.0.0.1:4433";
