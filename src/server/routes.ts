import { IRoute } from '../types';
import middlewares from './middlewares';

const routes: Array<IRoute> = [
  { type: 'get', path: '/status', middleware: middlewares.status },
];

export default routes;
