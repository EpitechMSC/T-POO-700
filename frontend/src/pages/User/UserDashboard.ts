import { defineComponent } from 'vue';
import SummaryCard from '../../components/Card/SummaryCard/SummaryCard.vue';
import WorkingTimeChart from '../../components/Chart/WorkingTimeChart/WorkingTimeChart.vue';
import WorkingTimeList from '../../components/WorkingTimes/WorkingTimeList.vue';
import TopBar from '../../components/TopBar/TopBar.vue';
import Balance from '../../components/Balance/BalanceComponent.vue';

import { driver } from 'driver.js';
import 'driver.js/dist/driver.css';

export default defineComponent({
  name: 'UserDashboardPage',
  components: {
    TopBar,
    SummaryCard,
    WorkingTimeChart,
    WorkingTimeList,
    Balance,
  },

  setup() {
    const startTutorial = () => {
      const driverObj = driver({
        showProgress: true,
        showButtons: ['next', 'previous'],
        steps: [
          {
            element: '#navigation_primary',
            popover: {
              title: 'Your Navigation Compass',
              description:
                'This is the main navigation bar.<br>Your starting point to effortlessly explore every corner of the application.',
            },
          },
          {
            element: '#navbar-user',
            popover: {
              title: 'Navigate Smoothly',
              description:
                'All the tabs you need, right where you expect them.<br>Access the entire application, quickly and easily.',
            },
          },
          {
            element: '#navigation_home',
            popover: {
              title: 'The Heart of Your Experience',
              description:
                "One click, and you're back home. Simple and instant.",
            },
          },
          {
            element: '#navigation_time',
            popover: {
              title: 'Master Your Time',
              description:
                'A quick glance, and you have a complete view of your working hours.<br>This is your control space.',
            },
          },
          {
            element: '#navigation_calendar',
            popover: {
              title: 'Your Calendar, Your Agenda',
              description:
                'Your entire week at a glance. Plan, visualize, master.',
            },
          },
          {
            element: '#navigation_burger',
            popover: {
              title: 'Everything Is Here',
              description:
                'The menu that centralizes all functionalities.<br>Your settings, your info, all in one place.',
            },
          },
          {
            element: '#top-bar',
            popover: {
              title: 'This Is Where It All Starts',
              description:
                "Press, clock in, get started. It's as simple as that.<br>Your mission begins here.",
            },
          },
          {
            element: '#navigation_clock',
            popover: {
              title: 'Your Clock',
              description:
                'Start or end your shift with a single click. Precise, instant, and always there when you need it.',
            },
          },
          {
            element: '#summary-card',
            popover: {
              title: 'Your Performance, Summarized',
              description:
                'A dashboard that tells it all.<br>Check your results, celebrate your achievements.',
            },
          },
          {
            element: '#working-time-chart',
            popover: {
              title: 'Visualize Your Progress',
              description:
                'A clear and powerful graph that shows where you stand.<br>Weekly, monthly, yearly: your efforts take shape.',
            },
          },
          {
            element: '#balance',
            popover: {
              title: 'The Time Balance',
              description:
                "This tool changes the game.<br>You can immediately see if you need to work more hours or if you'll get extra pay.<br>Total clarity, at a glance.",
            },
          },
          {
            element: '#working-time-list',
            popover: {
              title: 'Your Work Agenda',
              description:
                'Every minute, every hour, documented.<br>Your efforts recorded, accessible anytime.',
            },
          },
          {
            element: '#working-time-list-details',
            popover: {
              title: 'A Breathtaking View',
              description:
                'See your working hours in every detail.<br><br>Need to correct? Edit? This is where it happens.',
            },
          },
          {
            popover: {
              description:
                "<img src='https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExd2k2dGtsZ2toYXA4c3l1ZWkxbW0xeXZxaXpkNWRpbzBodDZuYXUyNSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/qVID3J8fLrlZK/giphy.gif' style='height: 100%; width: 100%;' /><span style='font-size: 15px; display: block; margin-top: 10px; text-align: center;'>The time has come... Save Gotham!</span>",
            },
          },
          {
            popover: {
              title: 'One Last Tip',
              description:
                "<img src='https://media2.giphy.com/media/pSFEEQMaNcFAQ/200.gif?cid=ecf05e4796gg48kv091skcbwq8s9k41hoeg8frcewzofwjaf&ep=v1_gifs_related&rid=200.gif&ct=g' style='height: 100%; width: 100%;' /><span style='font-size: 15px; display: block; margin-top: 10px; text-align: center;'>Remember, this tutorial is always accessible by clicking the 'i' icon at the bottom left.<br>It's your ally, just a click away.</span>",
            },
          },
        ],
      });

      driverObj.drive();
    };

    return {
      startTutorial,
    };
  },
});
