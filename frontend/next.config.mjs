/** @type {import('next').NextConfig} */
const nextConfig = {
  async redirects() {
    return [
      {
        source: '/',
        destination: '/deposit',
        permanent: false,
      },
    ]
  },
};

export default nextConfig;
