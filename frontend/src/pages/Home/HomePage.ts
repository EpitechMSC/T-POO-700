import { defineComponent } from 'vue';
import { User } from '../../app/models/user';
import TableComponent from '../../components/Table/TableComponent.vue';
import CardComponent from '../../components/Card/CardComponent.vue';

export default defineComponent({
  name: 'HomePage',
  components: {
    TableComponent,
    CardComponent,
  },
  data() {
    return {
      users: [
        { id: 1, username: 'john_doe', email: 'john@example.com' },
        { id: 2, username: 'jane_doe', email: 'jane@example.com' },
        { id: 3, username: 'sam_smith', email: 'sam@example.com' },
      ] as User[],
    };
  },
});
