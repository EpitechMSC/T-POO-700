import Users from './modules/users';
import Clocks from './modules/clocks';
import WorkingTimes from './modules/workingtimes';
import Authenticate from './modules/authenticate';
import Contrats from './modules/contrat';
import Events from './modules/events';
import Teams from './modules/teams';

const agent = {
  Users,
  Clocks,
  WorkingTimes,
  Authenticate,
  Contrats,
  Events,
  Teams,
};

export default agent;
