import Fastify, { FastifyInstance } from 'fastify';

import routes from './routes';

const server: FastifyInstance = Fastify({});

for (const route of routes) {
  const { preHandler, middleware } = route;

  server[route.type](route.path, { preHandler, handler: middleware });
}

export default server;
