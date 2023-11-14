import {
  FastifyError,
  FastifyReply,
  FastifyRequest,
} from 'fastify';

export interface IConfig {
    server: {
        host: string;
        port: number;
    };
    db: {
        name: string;
        host: string;
        user: string;
        pass: string;
        port: number;
        ssl: boolean;
    };
    logger: {
        appName: string;
    };
    security: {
        adminKey: string;
        userKey: string;
    };
}

export type THttpMethod = 'get' | 'post' | 'put' | 'delete';
type TMiddleware = (req: FastifyRequest, res: FastifyReply) => Promise<void>;
type TPreHandler = (req: FastifyRequest, res: FastifyReply, done: (err?: FastifyError) => void) => Promise<void>;

export interface IRoute {
    type: THttpMethod;
    path: string;
    middleware: TMiddleware;
    preHandler?: TPreHandler;
}
