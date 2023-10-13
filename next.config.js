/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
}

module.exports = {
  async rewrites() {
    return [
      {
        source: '/api/:path*',
        destination: `http://${process.env.NEXT_PUBLIC_SERVER}:3000/api/:path*`, // Cambia esto a la URL de tu API
      },
    ]
  },
}

module.exports = nextConfig
