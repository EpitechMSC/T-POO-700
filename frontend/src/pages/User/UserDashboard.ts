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
              title: 'Votre Boussole de Navigation',
              description:
                "Voici la barre de navigation principale.<br>Votre point de départ pour explorer chaque coin de l'application, sans effort.",
            },
          },
          {
            element: '#navbar-user',
            popover: {
              title: 'Naviguez avec Fluidité',
              description:
                "Tous les onglets dont vous avez besoin, exactement là où vous les attendez.<br>Accédez à l'ensemble de l'application, rapidement et sans effort.",
            },
          },
          {
            element: '#navigation_home',
            popover: {
              title: 'Le Cœur de votre Expérience',
              description:
                "Un clic, et vous voilà de retour à l'accueil. Simple et instantané.",
            },
          },
          {
            element: '#navigation_time',
            popover: {
              title: 'Maîtrisez Votre Temps',
              description:
                "Un coup d'œil, et vous avez la vision complète de vos heures de travail.<br>C'est votre espace de contrôle.",
            },
          },
          {
            element: '#navigation_calendar',
            popover: {
              title: 'Votre Calendrier, Votre Agenda',
              description:
                'Toute votre semaine en un coup d’œil. Planifiez, visualisez, maîtrisez.',
            },
          },
          {
            element: '#navigation_burger',
            popover: {
              title: 'Tout est ici',
              description:
                "Le menu qui centralise l'ensemble des fonctionnalités.<br>Vos paramètres, vos infos, tout en un seul endroit.",
            },
          },
          {
            element: '#top-bar',
            popover: {
              title: 'C’est ici que tout commence',
              description:
                "Appuyez, pointez, commencez. C'est aussi simple que ça.<br>Votre mission débute ici.",
            },
          },
          {
            element: '#navigation_clock',
            popover: {
              title: 'Votre Horloge',
              description:
                'Commencez ou terminez votre mission avec un simple clic. Précis, instantané, et toujours là quand vous en avez besoin.',
            },
          },
          {
            element: '#summary-card',
            popover: {
              title: 'Votre Performance, Résumée',
              description:
                'Un tableau de bord qui dit tout.<br>Consultez vos résultats, célébrez vos succès.',
            },
          },
          {
            element: '#working-time-chart',
            popover: {
              title: 'Visualisez Votre Progression',
              description:
                'Un graphique clair et puissant qui vous montre où vous en êtes.<br>Hebdo, mensuel, annuel : vos efforts prennent forme.',
            },
          },
          {
            element: '#balance',
            popover: {
              title: 'La Balance du Temps',
              description:
                "Cet outil change la donne.<br>Vous voyez immédiatement si vous devez faire plus d'heures ou si vous serez payé plus.<br>La clarté totale, en un coup d’œil.",
            },
          },
          {
            element: '#working-time-list',
            popover: {
              title: 'Votre Agenda de Travail',
              description:
                'Chaque minute, chaque heure, documentée.<br>Vos efforts consignés, consultables à tout moment.',
            },
          },
          {
            element: '#working-time-list-details',
            popover: {
              title: 'Une Vue à Couper le Souffle',
              description:
                "Découvrez vos heures de travail dans les moindres détails.<br><br>Besoin de corriger ? Modifier ? C'est ici que ça peut se passer.",
            },
          },
          {
            popover: {
              description:
                "<img src='https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExd2k2dGtsZ2toYXA4c3l1ZWkxbW0xeXZxaXpkNWRpbzBodDZuYXUyNSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/qVID3J8fLrlZK/giphy.gif' style='height: 100%; width: 100%;' /><span style='font-size: 15px; display: block; margin-top: 10px; text-align: center;'>Le moment est venu... Sauvez Gotham !</span>",
            },
          },
          {
            popover: {
              title: 'Un Dernier Conseil',
              description:
                "<img src='https://media2.giphy.com/media/pSFEEQMaNcFAQ/200.gif?cid=ecf05e4796gg48kv091skcbwq8s9k41hoeg8frcewzofwjaf&ep=v1_gifs_related&rid=200.gif&ct=g' style='height: 100%; width: 100%;' /><span style='font-size: 15px; display: block; margin-top: 10px; text-align: center;'>Rappelez-vous, ce tutoriel est toujours accessible en cliquant sur l'icône 'i' en bas à gauche.<br>C'est votre allié, à portée de clic.</span>",
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
