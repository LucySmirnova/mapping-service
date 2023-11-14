import config from '../config';
import * as logger from '../utils/logger';
import app from './app';

const run = async () => {
  const { port, host } = config.server;

  app.listen({ port, host }, () => {
    logger.info(`Server running at host: ${host} port: ${port}`);
  });
};

run().catch(e => {
  logger.error(`Run server error: ${e instanceof Error ? e.message : 'unknown'}`);
  process.exit(1);
});
