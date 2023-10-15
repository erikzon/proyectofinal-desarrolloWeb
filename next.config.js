/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
}

const withPWA = require('next-pwa')({
  dest: 'public',
  async rewrites() {
    return [
      {
        source: '/api/:path*',
        destination: `http://${process.env.NEXT_PUBLIC_SERVER}:3000/api/:path*`, // Cambia esto a la URL de tu API
      },
    ]
  },
});

export default withPWA(nextConfig);
