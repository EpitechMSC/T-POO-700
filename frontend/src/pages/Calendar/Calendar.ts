import { defineComponent, ref, onMounted, computed, watch } from 'vue';
import FullCalendar from '@fullcalendar/vue3';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import interactionPlugin from '@fullcalendar/interaction';
import Swal from 'sweetalert2';
import TopBar from '../../components/TopBar/TopBar.vue';
import {
  useAuthenticateStore,
  useEventsStore,
  useTeamStore,
} from '../../app/store/store';
import { CalendarEvent, Event } from '../../app/models/event';
import SummaryCard from '../../components/Card/SummaryCard/SummaryCard.vue';

export default defineComponent({
  name: 'CalendarComponent',
  components: {
    FullCalendar,
    TopBar,
    SummaryCard,
  },
  setup() {
    const eventsStore = useEventsStore();
    const authenticateStore = useAuthenticateStore();
    const teamStore = useTeamStore();
    const today = new Date().toISOString().split('T')[0];

    const userRole = computed(() => authenticateStore.getUserRole);

    const calendarOptions = ref({
      plugins: [dayGridPlugin, timeGridPlugin, interactionPlugin],
      initialDate: today,
      headerToolbar: {
        left: 'prev,next today',
        center: 'title',
        right: 'dayGridMonth,timeGridWeek,timeGridDay',
      },
      navLinks: true,
      selectable: true,
      selectMirror: true,
      editable: true,
      dayMaxEvents: true,
      events: [] as CalendarEvent[],
      select: handleSelect,
      eventClick: handleEventClick,
    });

    const userTeams = computed(() => teamStore.teams || []);

    const calendarEvents = computed(() => {
      return (eventsStore.events ?? []).map(event => ({
        title: event.title,
        start: event.start,
        end: event.end,
        allDay: event.all_day,
        id: event.id,
      })) as CalendarEvent[];
    });

    watch(calendarEvents, newEvents => {
      calendarOptions.value.events = newEvents;
    });

    onMounted(async () => {
      await teamStore.fetchTeamByUserId(authenticateStore.user!.id);
      await eventsStore.fetchUserEvents();
      calendarOptions.value.events = calendarEvents.value;
    });

    async function handleSelect(arg: any) {
      if (userTeams.value.length === 0) {
        Swal.fire({
          text: 'You need to be part of a team to create events!',
          icon: 'error',
          confirmButtonText: 'Ok',
          customClass: {
            confirmButton:
              'bg-red-500 hover:bg-red-600 text-white font-bold py-2 px-4 rounded',
          },
        });
        return;
      }

      if (userRole.value === 'Manager' || userRole.value === 'Supervisor') {
        const { value } = await Swal.fire({
          html: `
            <div class="mb-4 text-lg">Create a new event?</div>
            <div class="font-semibold mb-3">Event name:</div>
            <input type="text" class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring focus:ring-indigo-200" name="event_name" />
            <div class="font-semibold mt-3">Select a team:</div>
            <select id="team_select" class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring focus:ring-indigo-200">
              ${userTeams.value.map(id => `<option value="${id}">${id}</option>`).join('')}
            </select>
          `,
          icon: 'info',
          showCancelButton: true,
          confirmButtonText: 'Yes, create!',
          cancelButtonText: 'No, cancel',
          customClass: {
            confirmButton:
              'bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded',
            cancelButton:
              'bg-gray-300 hover:bg-gray-400 text-gray-700 font-bold py-2 px-4 rounded',
          },
        });

        if (value) {
          const title = (
            document.querySelector(
              'input[name="event_name"]'
            ) as HTMLInputElement
          ).value;
          const teamId = (
            document.getElementById('team_select') as HTMLSelectElement
          ).value;

          if (title && teamId) {
            const newEvent: Event = {
              title,
              start: arg.start,
              end: arg.end,
              all_day: arg.allDay,
              team_id: Number(teamId),
            };

            await eventsStore.createEvent(newEvent);
          }
          arg.view.calendar.unselect();
        } else if (value === null) {
          Swal.fire({
            text: 'Event creation has been canceled!',
            icon: 'error',
            confirmButtonText: 'Got it!',
            customClass: {
              confirmButton:
                'bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded',
            },
          });
        }
      } else {
        Swal.fire({
          text: 'You are not authorized to create events!',
          icon: 'error',
          confirmButtonText: 'Ok',
          customClass: {
            confirmButton:
              'bg-red-500 hover:bg-red-600 text-white font-bold py-2 px-4 rounded',
          },
        });
      }
    }

    async function handleEventClick(arg: any) {
      if (userRole.value === 'Manager' || userRole.value === 'Supervisor') {
        const { value } = await Swal.fire({
          text: 'Are you sure you want to delete this event?',
          icon: 'warning',
          showCancelButton: true,
          confirmButtonText: 'Yes, delete!',
          cancelButtonText: 'No, go back',
          customClass: {
            confirmButton:
              'bg-red-500 hover:bg-red-600 text-white font-bold py-2 px-4 rounded',
            cancelButton:
              'bg-gray-300 hover:bg-gray-400 text-gray-700 font-bold py-2 px-4 rounded',
          },
        });

        if (value) {
          await eventsStore.deleteEvent(arg.event.id, arg.event.team_id);
        } else if (value === null) {
          Swal.fire({
            text: 'The event was not deleted!',
            icon: 'error',
            confirmButtonText: 'Got it!',
            customClass: {
              confirmButton:
                'bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded',
            },
          });
        }
      } else {
        Swal.fire({
          text: 'You are not authorized to delete events!',
          icon: 'error',
          confirmButtonText: 'Ok',
          customClass: {
            confirmButton:
              'bg-red-500 hover:bg-red-600 text-white font-bold py-2 px-4 rounded',
          },
        });
      }
    }

    return {
      calendarOptions,
    };
  },
});
