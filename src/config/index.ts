import { IConfig } from '../types';

const { env } = process;

const checkEnv = (envName: string): string => {
  const parsedVal = env[envName];

  if (typeof parsedVal === 'undefined' || parsedVal.trim() === '') {
    throw new Error(`Environment variable "${envName}" not set`);
  }

  return parsedVal;
};

const config: IConfig = {
  server: {
    host: checkEnv('SERVER_HOST'),
    port: parseInt(checkEnv('SERVER_PORT')),
  },
  db: {
    name: checkEnv('DB_NAME'),
    host: checkEnv('DB_HOST'),
    user: checkEnv('DB_USER'),
    pass: checkEnv('DB_PASSWORD'),
    port: parseInt(checkEnv('DB_PORT')),
    ssl: checkEnv('DB_SSL') === 'true',
  },
  logger: {
    appName: 'mapping_service',
  },
  security: {
    adminKey: checkEnv('ADMIN_API_KEY'),
    userKey: checkEnv('USER_API_KEY'),
  },
};

export default config;
