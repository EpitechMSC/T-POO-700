import { defineComponent, ref } from 'vue';
import FullCalendar from '@fullcalendar/vue3';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import interactionPlugin from '@fullcalendar/interaction';
import Swal from 'sweetalert2';
import TopBar from '../../components/TopBar/TopBar.vue';

export default defineComponent({
  name: 'CalendarComponent',
  components: {
    FullCalendar,
    TopBar,
  },
  setup() {
    const today = new Date().toISOString().split('T')[0];

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
      events: [
        { title: 'All Day Event', start: today },
        {
          title: 'Long Event',
          start: new Date(new Date().setDate(new Date().getDate() + 3))
            .toISOString()
            .split('T')[0],
          end: new Date(new Date().setDate(new Date().getDate() + 5))
            .toISOString()
            .split('T')[0],
        },
        {
          groupId: 999,
          title: 'Repeating Event',
          start: new Date(new Date().setDate(new Date().getDate() + 7))
            .toISOString()
            .split('T')[0],
        },
        {
          groupId: 999,
          title: 'Repeating Event',
          start: new Date(new Date().setDate(new Date().getDate() + 14))
            .toISOString()
            .split('T')[0],
        },
        {
          title: 'Conference',
          start: new Date(new Date().setDate(new Date().getDate() + 10))
            .toISOString()
            .split('T')[0],
          end: new Date(new Date().setDate(new Date().getDate() + 12))
            .toISOString()
            .split('T')[0],
        },
        {
          title: 'Meeting',
          start: new Date().toISOString().split('T')[0] + 'T10:30:00',
          end: new Date().toISOString().split('T')[0] + 'T12:30:00',
        },
        {
          title: 'Lunch',
          start: new Date().toISOString().split('T')[0] + 'T12:00:00',
        },
        {
          title: 'Meeting',
          start: new Date().toISOString().split('T')[0] + 'T14:30:00',
        },
        {
          title: 'Happy Hour',
          start: new Date().toISOString().split('T')[0] + 'T17:30:00',
        },
        {
          title: 'Dinner',
          start: new Date().toISOString().split('T')[0] + 'T20:00:00',
        },
        {
          title: 'Birthday Party',
          start:
            new Date(new Date().setDate(new Date().getDate() + 1))
              .toISOString()
              .split('T')[0] + 'T07:00:00',
        },
        {
          title: 'Click for Google',
          url: 'http://google.com/',
          start: new Date(new Date().setDate(new Date().getDate() + 16))
            .toISOString()
            .split('T')[0],
        },
      ],
      select(arg: any) {
        Swal.fire({
          html: `
            <div class="mb-4 text-lg">Create new event?</div>
            <div class="font-semibold mb-3">Event Name:</div>
            <input type="text" class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring focus:ring-indigo-200" name="event_name" />
          `,
          icon: 'info',
          showCancelButton: true,
          confirmButtonText: 'Yes, create it!',
          cancelButtonText: 'No, return',
          customClass: {
            confirmButton:
              'bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded',
            cancelButton:
              'bg-gray-300 hover:bg-gray-400 text-gray-700 font-bold py-2 px-4 rounded',
          },
        }).then(result => {
          if (result.value) {
            const title = (
              document.querySelector(
                'input[name="event_name"]'
              ) as HTMLInputElement
            ).value;
            if (title) {
              calendarOptions.value.events.push({
                title: title,
                start: arg.start,
                end: arg.end,
                allDay: arg.allDay,
              });
            }
            arg.view.calendar.unselect();
          } else if (result.dismiss === 'cancel') {
            Swal.fire({
              text: 'Event creation was declined!',
              icon: 'error',
              confirmButtonText: 'Ok, got it!',
              customClass: {
                confirmButton:
                  'bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded',
              },
            });
          }
        });
      },
      eventClick(arg: any) {
        Swal.fire({
          text: 'Are you sure you want to delete this event?',
          icon: 'warning',
          showCancelButton: true,
          confirmButtonText: 'Yes, delete it!',
          cancelButtonText: 'No, return',
          customClass: {
            confirmButton:
              'bg-red-500 hover:bg-red-600 text-white font-bold py-2 px-4 rounded',
            cancelButton:
              'bg-gray-300 hover:bg-gray-400 text-gray-700 font-bold py-2 px-4 rounded',
          },
        }).then(result => {
          if (result.value) {
            arg.event.remove();
          } else if (result.dismiss === 'cancel') {
            Swal.fire({
              text: 'Event was not deleted!',
              icon: 'error',
              confirmButtonText: 'Ok, got it!',
              customClass: {
                confirmButton:
                  'bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded',
              },
            });
          }
        });
      },
    });

    return {
      calendarOptions,
    };
  },
});
