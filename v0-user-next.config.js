/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  experimental: {
    serverActions: true,
    react: {
      version: 19,
    },
  },
}

module.exports = nextConfig
