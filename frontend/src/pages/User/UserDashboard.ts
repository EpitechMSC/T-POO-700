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
              title: 'Barre de navigation principale',
              description:
                "Ceci est la barre de navigation principale.<br>Vous pouvez naviguer entre les différentes pages de l'application.",
            },
          },
          {
            element: '#navbar-user',
            popover: {
              title: 'une navigation simple ',
              description:
                "Retrouvez ici les différents onglets de l'application.<br>Vous pouvez naviguer efficassemnt dans l'ensemble de l'application.",
            },
          },
          {
            element: '#navigation_home',
            popover: {
              title: 'Accueil',
              description: "Cliquez ici pour revenir à la page d'accueil.",
            },
          },
          {
            element: '#navigation_time',
            popover: {
              title: 'Temps de travail',
              description:
                "Cliquez ici pour voir l'ensemble de vos temps de travail.",
            },
          },
          {
            element: '#navigation_calendar',
            popover: {
              title: 'Calendrier',
              description: 'Cliquez ici pour voir votre calendrier.',
            },
          },
          {
            element: '#navigation_burger',
            popover: {
              title: 'Menu',
              description:
                "Cliquez ici pour voir l'ensemble des fonctionnalités de l'application<br> ainsi que vos paramètre et informations.",
            },
          },
          {
            element: '#top-bar',
            popover: {
              title: 'là où tout commence',
              description:
                "C'est ici que vous pouvez clocker quand vous commencez une mission.",
            },
          },
          {
            element: '#navigation_clock',
            popover: {
              title: "L'horloge",
              description:
                'Cliquez ici pour clocker quand vous commencez ou terminez une mission.',
            },
          },
          {
            element: '#summary-card',
            popover: {
              title: 'Résumé',
              description:
                "C'est ici que vous pouvez voir un résumé de vos différents efforts et temps de travail.",
            },
          },
          {
            element: '#working-time-chart',
            popover: {
              title: 'Visualisation Efficace',
              description:
                "C'est ici que vous pouvez voir graphiquement de votre temps de travail.<br>Vous pouvez voir votre temps de travail par semaine, mois ou à l'année.<br>Vos efforts comme vous ne les avez jamais vue.",
            },
          },
          {
            element: '#balance',
            popover: {
              title: 'La balance',
              description:
                'Cet outil unique vous permet de vous rendre compte de vos heures acomplis de la semaine.<br>Voyez rapidement si vous devez travailler plus ou si vous allez gagner plus.',
            },
          },
          {
            element: '#working-time-list',
            popover: {
              title: "Les 'Workings Times'",
              description:
                "C'est ici que vous pouvez avoir un apperçu de vos temps de travail.",
            },
          },
          {
            element: '#working-time-list-details',
            popover: {
              title: 'Une vue à couper le souffle',
              description:
                'Avec cette incroyable sivualisation de vos temps de travail vous pouvez voir en détail vos heures travaillées et quand.<br><br>Un problème ? Un oubli ?<br>Vous pouvez modifier vos temps de travail à tout moment ici.',
            },
          },
          {
            popover: {
              description:
                "<img src='https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExd2k2dGtsZ2toYXA4c3l1ZWkxbW0xeXZxaXpkNWRpbzBodDZuYXUyNSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/qVID3J8fLrlZK/giphy.gif' style='height: 100%; width: 100%;' /><span style='font-size: 15px; display: block; margin-top: 10px; text-align: center;'>Il est temps d'aller sauver Gotham</span>",
            },
          },
          {
            popover: {
              title: 'Dernière information',
              description:
                "<img src='https://media2.giphy.com/media/pSFEEQMaNcFAQ/200.gif?cid=ecf05e4796gg48kv091skcbwq8s9k41hoeg8frcewzofwjaf&ep=v1_gifs_related&rid=200.gif&ct=g' style='height: 100%; width: 100%;' /><span style='font-size: 15px; display: block; margin-top: 10px; text-align: center;'>Noubliez pas que vous avez toujours accès à ce tutoriel en cliquant sur l'icone 'i' en bas à gauche de l'écran.</span>",
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
