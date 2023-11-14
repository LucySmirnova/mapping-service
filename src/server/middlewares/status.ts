import { FastifyReply, FastifyRequest } from 'fastify';

const status = async (_req: FastifyRequest, res: FastifyReply) => {
  const result = { code: 'OK', result: 'Status', error: null };

  void res.code(200).send(result);
};

export default status;
