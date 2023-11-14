import config from '../config';
import { FastifyRequest } from 'fastify';

const LEVEL_ERROR = 'ERROR';
const LEVEL_WARNING = 'WARNING';
const LEVEL_INFO = 'INFO';

type TLevel = 'ERROR' | 'WARNING' | 'INFO';

const writeLog = (level: TLevel, message: string | unknown) => {
  if (typeof message !== 'string') {
    try {
      message = JSON.stringify(message);
    } catch (e) {
      message = 'non-serializable value';
    }
  }

  const data = {
    app: config.logger.appName,
    date: new Date().toISOString(),
    level,
    message,
  };

  console.log(JSON.stringify(data));
};

export const error = (message: string | unknown) => {
  writeLog(LEVEL_ERROR, message);
};

export const info = (message: string | unknown) => {
  writeLog(LEVEL_INFO, message);
};

export const warning = (message: string | unknown) => {
  writeLog(LEVEL_WARNING, message);
};

export const apiError = (name: string, request: FastifyRequest, error: unknown) => {
  const { url } = <{ url: string }>request;
  const data = [`name: ${name}`, `url: ${url}`];

  try {
    const payload = <Record<string, unknown>>Object.assign({}, request.body);

    if (typeof payload.password !== 'undefined') {
      payload.password = '********';
    }

    data.push(`body: ${JSON.stringify(payload)}`);
  } catch (e) {
    data.push('body: unserializable');
  }

  try {
    data.push(`query: ${JSON.stringify(request.query)}`);
  } catch (e) {
    data.push('query: unserializable');
  }

  try {
    const message = error instanceof Error ? error.message : JSON.stringify(error);

    data.push(`error: ${message}`);
  } catch (e) {
    data.push('error: unserializable');
  }

  writeLog(LEVEL_ERROR, data.join(' '));
};
